--!strict

local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local CardDecisionmaking = require(game.ServerScriptService.Server.CardDecisionmaking)
local CardDecksManager = require(game.ServerScriptService.Server.CardDecksManager)

local CardUsed = Instance.new("RemoteEvent")
local CardUsedCancel = Instance.new("RemoteEvent")
local CardUsedApprove = Instance.new("RemoteEvent")

local WRONG_ARGUMENT_TYPE_ERROR = "Wrong type"
local WRONG_CARD_ID_ERROR = "Wrong card id"
local CARD_USING_LIMIT_ERROR = "Maximum cards used"

local CardInput = Class:extend()

CardInput.CardsActivated = GoodSignal:new()

local playerCards = {}

local turnOwner: Player
local cardInputConnection: RBXScriptConnection

local function _checkArgument(arg, type: string)
    if typeof(arg) ~= type then
        return false
    end
    return true
end

local function _handler(player: Player, cardId: string)
    if player ~= turnOwner then
        CardUsedCancel:FireClient()
    end

    if #playerCards >= 3 then
        CardUsedCancel:FireClient(player, CARD_USING_LIMIT_ERROR)
    end

    if not _checkArgument(cardId) then
        CardUsedCancel:FireClient(player, WRONG_ARGUMENT_TYPE_ERROR)
    end

    local commonDeck = CardDecksManager:getPlayerCommonDeck(player)
    local bonusDeck = CardDecksManager:getPlayerBonusDeck(player)

    local foundCard = commonDeck:findCard(cardId) or bonusDeck:findCard(cardId)

    if not foundCard then
        CardUsedCancel:FireClient(player, WRONG_ARGUMENT_TYPE_ERROR)
    end
end

function CardInput:startListening(player: Player)
    turnOwner = player
    cardInputConnection = CardUsed.OnServerEvent:Connect(_handler)
end

function CardInput:handOverCards()
    
end

function CardInput:stopListening()
    turnOwner = nil
    cardInputConnection:Disconnect()
end