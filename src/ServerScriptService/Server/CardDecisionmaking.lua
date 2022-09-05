--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)

local CardsAction = require(game.ServerScriptService.Server.CardsAction)
local CardDecksManager = require(game.ServerScriptService.Server.CardDecksManager)

local CardDecisionmaking = Class:extend()

local cards: {{owner: Player, enemy: Player?}} = {}



return CardDecisionmaking