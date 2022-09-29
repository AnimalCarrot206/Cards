--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local PlayerUI = require(game.ServerScriptService.Server.PlayerCardUI_Server)
local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)

local TurnManager = Class:extend()

local inGamePlayers: Array<Player>
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
    local playerWhichTurnDisabled = nil
--[=[
    Creates new turn, must be called before TurnManager:beginTurn() and after TurnManager:endTurn().

    nextTurn()->beginTurn()->endTurn()
    -----
]=]
    function TurnManager:nextTurn()
        currentPlayerIndex += 1

        turnOwner = inGamePlayers[currentPlayerIndex]
        local isTurnDisabled = PlayerStats.isTurnDisabled:get(turnOwner)

        if isTurnDisabled == true then
            self:disablePlayerNearestTurn(turnOwner)
            if playerWhichTurnDisabled ~= nil then
                -- Меняем свойство
            end
            self:nextTurn()
        end

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
        PlayerUI:showText(turnOwner, "Your turn!")
    end

--[=[
    Ends created turn, and notifies client.
    Must be called after TurnManager:beginTurn() and before TurnManager:nextTurn()
]=]
    function TurnManager:endTurn()
        Remotes.TurnEnded:FireClient(turnOwner)
        status = CustomEnum.TurnStatus.End
        PlayerUI:clearText(turnOwner)

        CardDeckManager:dealCardsToPlayers()
    end
--[=[
    Returns turn status (CustomEnum.TurnStatus)
]=]
    function TurnManager:getTurnStatus()
        return status
    end
end
--[=[
    Disables player nearest player turn
]=]
function TurnManager:disablePlayerNearestTurn(player: Player)
    local playerIndex = table.find(inGamePlayers, player)
    if not playerIndex then
        return
    end
    Remotes.TurnDisabled:FireClient(player)
end
--[=[
    When player, that was in-game, leaves, it removes him from array.
    Ends and creates new turn if the current turn was leaving player turn
]=]
Players.PlayerRemoving:Connect(function(player)
    local foundPlayer = table.find(inGamePlayers, player)
    local isPlayerWasInGame = foundPlayer ~= nil

    if isPlayerWasInGame == false then
        return
    end

    table.remove(inGamePlayers, foundPlayer)
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