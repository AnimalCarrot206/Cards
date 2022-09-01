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

local function _checkArgument(arg, type: string)
    if typeof(arg) ~= type then
        return false
    end
    return true
end

local function _checkCardUseArguments(card, ...)
    local args = {...}

    if card:getUseType() == CustomEnum.CardUseType.OnePlayerUse then
        return true
    elseif card:getUseType() == CustomEnum.CardUseType.TwoPlayerUse then
        for index, value in ipairs(args) do
            if typeof(value) == "Instance" and value:IsA("Player") then
                return true
            end
        end
    end
end

local function _getCard(player: Player, cardId: string, ...)
    assert(player == turnOwner, NOT_YOUR_TURN_ERROR)
    assert(#playerCards < 3, CARD_USING_LIMIT_ERROR)
    assert(_checkArgument(cardId, "string"), WRONG_ARGUMENT_TYPE_ERROR)

    local commonDeck = CardDecksManager:getPlayerCommonDeck(player)
    local bonusDeck = CardDecksManager:getPlayerBonusDeck(player)

    local foundCard = commonDeck:findCard(cardId) or bonusDeck:findCard(cardId)

    assert(_checkCardUseArguments(foundCard, ...))
    assert(foundCard ~= nil, WRONG_CARD_ID_ERROR)
    return foundCard
end

local function _checkForGameRules(player: Player, cardId: string)
    local foundCard = _getCard(player, cardId)
    local cardName = foundCard:getName()

    local result = false

    if cardName == CustomEnum.Cards["Bang!!"].Name then
        local count = 0
        for index, card in ipairs(playerCards) do
            if card:getName() ~= cardName then
                continue
            end
            count += 1
        end
        if count == 0 then
            result = true
        end
        if Armory:getPlayerGun(player) == CustomEnum.Guns["Shawed off"] and count <= 1 then
            result = true
        end
    end

    if cardName == CustomEnum["Cage"].Name then
        
    end
end

local function _cardUseHandler(player: Player, cardId: string, ...)
    local foundCard = _getCard()

    table.insert(playerCards, foundCard)
end

function CardInput:handOverCards()
    
end


CardUsed.OnServerEvent:Connect(_cardUseHandler)
IsCardCanBeUsed.OnServerInvoke()