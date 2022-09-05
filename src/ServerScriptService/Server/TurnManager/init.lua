--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local Promise = require(game.ReplicatedStorage.Shared.Promise)

local CardInput = require(game.ServerScriptService.Server.CardIput)

local TurnManager = Class:extend()

local inGamePlayers: Array<Player>
local diasabledTurns: Array<number> = {}
local currentPlayerIndex = 0
local turnOwner

function TurnManager:initialize(players: Array<Player>)
    inGamePlayers = players
end

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
end

function TurnManager:beginTurn()
    Remotes.TurnStarted:FireClient(turnOwner)

end

function TurnManager:endTurn()
    Remotes.TurnEnded:FireClient(turnOwner)
end

function TurnManager:getTurnOwnerCardUsed()
    return CardInput:listen(turnOwner)
end

function TurnManager:cardRequest(player, cardName)
    return CardInput:listen(player, cardName)
end

function TurnManager:disablePlayerNearestTurn(player: Player)
    local playerIndex = table.find(inGamePlayers, player)
    if not playerIndex then
        return
    end
    table.insert(diasabledTurns, playerIndex)
end

Players.PlayerRemoving:Connect(function(player)
    local foundPlayer = table.find(inGamePlayers, player)
    local isPlayerWasInGame = foundPlayer ~= nil

    table.remove(inGamePlayers, foundPlayer)
    if currentPlayerIndex >= #inGamePlayers then
        currentPlayerIndex = 0
    end
end)

return TurnManager