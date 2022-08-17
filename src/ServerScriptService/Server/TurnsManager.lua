--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local List = require(game.ReplicatedStorage.Shared.List)

local TurnsManager = Class:extend()

TurnsManager.TurnStarted = GoodSignal.new()
TurnsManager.TurnEnded = GoodSignal.new()

local turns = List()

local function _sortPlayersBySit(playerA: Player, playerB: Player)
    local a,b = playerA:GetAttribute("SitPlace"), playerB:GetAttribute("SitPlace")

    return a > b
end

local _next do

    local previousIndex = 0

    _next = coroutine.wrap(function()
        while true do
            local allPlayers = Players:GetPlayers()

            if previousIndex >= #allPlayers then
                previousIndex = 0
            end

            coroutine.yield(allPlayers[previousIndex + 1])
        end
    end)    
end

function TurnsManager:preloadTurns()
    local allPlayers = Players:GetPlayers()

    table.sort(allPlayers, _sortPlayersBySit)

    for index, player in ipairs(allPlayers) do
        turns:pushleft(player)
    end
end

function TurnsManager:clearTurns()
    table.clear(turns)
end

function TurnsManager:nextTurn()
    local previousPlayer = turns:popright()
    self.TurnEnded:Fire(previousPlayer)

    local nextPlayer = _next()
    self.TurnStarted:Fire(nextPlayer)
    turns:pushleft(nextPlayer)
end

return TurnsManager