--!strict

local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)

local CardDecisionmaking = require(game.ServerScriptService.Server.CardDecisionmaking)
local CardDecksManager = require(game.ServerScriptService.Server.CardDecksManager)
local AbilityManager
local Armory = require(game.ServerScriptService.Server.Armory)

local CardUsed = Remotes.CardUsed
local IsCardCanBeUsed = Remotes.IsCardCanBeUsed

local NOT_YOUR_TURN_ERROR = "Not your turn"
local WRONG_ARGUMENT_TYPE_ERROR = "Wrong type"
local WRONG_CARD_ID_ERROR = "Wrong card id"
local CARD_USING_LIMIT_ERROR = "Maximum cards used"

local CardInput = Class:extend()

CardInput.CardsActivated = GoodSignal:new()

local playerCards = {}

local turnOwner: Player
local cardInputConnection: RBXScriptConnection


