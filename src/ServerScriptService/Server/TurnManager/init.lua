--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local CardInput = require(game.ServerScriptService.Server.CardIput)

local TurnManager = Class:extend()

local inGamePlayers: Array<Player>
local diasabledTurns: Array<number> = {}
local currentPlayerIndex = 0
local turnOwner
--[=[
    Initializes TurnManager, must be called on game start
]=]
function TurnManager:initialize(players: Array<Player>)
    inGamePlayers = players
end
do
    local status = CustomEnum.TurnStatus.End
--[=[
    Creates new turn, must be called before TurnManager:beginTurn() and after TurnManager:endTurn().

    nextTurn()->beginTurn()->endTurn()
    -----
]=]
function TurnManager:nextTurn()
    currentPlayerIndex += 1
    local disabledTurnsIndex  

    repeat
        disabledTurnsIndex = table.find(diasabledTurns, currentPlayerIndex)
        currentPlayerIndex = if #inGamePlayers then 1 else currentPlayerIndex + 1
    until disabledTurnsIndex == nil

    turnOwner = inGamePlayers[currentPlayerIndex]

    if currentPlayerIndex == #inGamePlayers then
        currentPlayerIndex = 0
    end
    status = CustomEnum.TurnStatus.Created
end
--[=[
    Starts created turn, and notifies client.
    Must be called after TurnManager:nextTurn() and before TurnManager:endTurn()
]=]
function TurnManager:beginTurn()
    Remotes.TurnStarted:FireClient(turnOwner)
    status = CustomEnum.TurnStatus.Begin

end
--[=[
    Ends created turn, and notifies client.
    Must be called after TurnManager:beginTurn() and before TurnManager:nextTurn()
]=]
function TurnManager:endTurn()
    Remotes.TurnEnded:FireClient(turnOwner)
    status = CustomEnum.TurnStatus.End
end
--[=[
    Returns turn status (CustomEnum.TurnStatus)
]=]
function TurnManager:getTurnStatus()
    return status
end
end
--[=[
    Retunrs turnOwner player used card from client, !not checked!
    
    @Yields
]=]
function TurnManager:getTurnOwnerCardUsed()
    return CardInput:listen(turnOwner)
end
--[=[
    Retunrs player used card from client, !not checked!

    @Yields
]=]
function TurnManager:cardRequest(player, cardName)
    return CardInput:listen(player, cardName)
end
--[=[
    Disables player nearest player turn
]=]
function TurnManager:disablePlayerNearestTurn(player: Player)
    local playerIndex = table.find(inGamePlayers, player)
    if not playerIndex then
        return
    end
    table.insert(diasabledTurns, playerIndex)
    Remotes.TurnDisabled:FireClient(player)
end
--[=[
    When player, that was in-game, leaves, it removes him from array.
    Ends and creates new turn if the current turn was leaving player turn
]=]
Players.PlayerRemoving:Connect(function(player)
    local foundPlayer = table.find(inGamePlayers, player)
    local isPlayerWasInGame = foundPlayer ~= nil

    table.remove(inGamePlayers, foundPlayer)
    diasabledTurns[foundPlayer] = nil
    if currentPlayerIndex >= #inGamePlayers then
        currentPlayerIndex = 0
    end
    if turnOwner == player then
        TurnManager:endTurn()
        TurnManager:nextTurn()
    end
end)
--[=[
    When player skips his turn, ends and create another
]=]
Remotes.TurnSkipped.OnServerEvent:Connect(function(player)
    if player ~= turnOwner then
        return
    end
    TurnManager:endTurn()
    TurnManager:nextTurn()
end)

return TurnManager