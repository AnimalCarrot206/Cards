--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)

local CardInterpreter
local CardDeckManager
local TurnManager = require(game.ServerScriptService.Server.TurnManager)

local RoundManager = Class:extend()