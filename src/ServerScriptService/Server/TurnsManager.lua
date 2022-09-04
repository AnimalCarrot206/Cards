--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)


local TurnStartedRemoteEvent = Remotes.TurnStarted
local TurnSkippedRemoteEvent = Remotes.TurnSkipped
local TurnEndedRemoteEvent = Remotes.TurnEnded

local TurnsManager = Class:extend()

TurnsManager.TurnStarted = GoodSignal.new()
TurnsManager.TurnEnded = GoodSignal.new()

local turns: {{Player}} = {}

local function _getPlayersSortedBySitPlace()
    local allPlayers = Players:GetPlayers()
    local sortedPlayers = {}

    table.foreachi(allPlayers, function(i, player)
        local sitPlace = PlayerStats:getPlayerSitPlace(player)
        sortedPlayers[sitPlace] = player
    end)

    return sortedPlayers
end


function TurnsManager:preloadTurns()
    local allPlayers = _getPlayersSortedBySitPlace()

    
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