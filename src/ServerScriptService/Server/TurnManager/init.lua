--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local Promise = require(game.ReplicatedStorage.Shared.Promise)

local CardInput = require(game.ServerScriptService.Server.CardIput)

local TurnManager = Class:extend()

local inGamePlayers: Array<Player>
local currentPlayerIndex = 0
local turnOwner

function TurnManager:initialize(players: Array<Player>)
    inGamePlayers = players
end

function TurnManager:nextTurn()
    currentPlayerIndex += 1
    turnOwner = inGamePlayers[currentPlayerIndex]

    if currentPlayerIndex == #inGamePlayers then
        currentPlayerIndex = 0
    end
end

function TurnManager:beginTurn()
    return Promise.new(function()
        
    end)
end

function TurnManager:endTurn()
    
end

function TurnManager:getTurnOwnerCardUsed()
    return CardInput:listen(turnOwner)
end

function TurnManager:cardRequest(player, cardName)
    
end

function TurnManager:disablePlayerNearestTurn()
    
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