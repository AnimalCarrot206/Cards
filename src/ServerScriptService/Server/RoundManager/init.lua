--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local CardInterpreter
local CardDeckManager
local TurnManager = require(game.ServerScriptService.Server.TurnManager)

local MINIMUM_PLAYERS = 5

local inGamePlayers: Array<Player> = {}

local isGameStarted = false

local RoundManager = Class:extend()
RoundManager.GameStarted = GoodSignal.new()
RoundManager.GameEnded = GoodSignal.new()
RoundManager.GameCancelled = GoodSignal.new()

local function _startGame()
    
end

local function _endGame()
    
end

local function _cancellGame()
    
end

local function _isEnoughPlayersInGame()
    return #Players:GetPlayers() >= MINIMUM_PLAYERS
end

local function _playerHasLeft()
    return Promise.fromEvent(Players.PlayerRemoving, function(player)
        if table.find(inGamePlayers, player) then
            return _isEnoughPlayersInGame()
        end
    end)
end

local function _playerHasJoined()
    return Promise.fromEvent(Players.PlayerAdded, function(player)
        if not isGameStarted then
            table.insert(inGamePlayers, player)
        end
        return #inGamePlayers >= MINIMUM_PLAYERS
    end)
end

