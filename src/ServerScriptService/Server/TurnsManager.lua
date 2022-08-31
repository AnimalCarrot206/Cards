--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local List = require(game.ReplicatedStorage.Shared.List)

local TurnStartedRemoteEvent = nil :: RemoteEvent
local TurnEndedRemoteEvent = nil :: RemoteEvent

local TurnsManager = Class:extend()

TurnsManager.TurnStarted = GoodSignal.new()
TurnsManager.TurnEnded = GoodSignal.new()

local turns: {{Player}} = {}

local function _playerPrioritySort(player1, player2)
    
end


function TurnsManager:preloadTurns()
    local allPlayers = Players:GetPlayers()

    
    for i, player in ipairs(allPlayers) do
        table.insert()
    end

end

function TurnsManager:clearTurns()

end

function TurnsManager:nextTurn()

end

function TurnsManager:getTurnOwner(): Player
    
end

return TurnsManager