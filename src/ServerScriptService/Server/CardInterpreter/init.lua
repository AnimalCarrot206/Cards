--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)
local CardOverrides = require(game.ServerScriptService.Server.CardOverrides)

local ErrorCodes = require(script.ErrorCodes)

local UseInfo = require(game.ServerScriptService.Server.UseInfo)
type MixinUseInfo = UseInfo.SelfUseInfo | UseInfo.OnPlayerUseInfo | UseInfo.CouplePlayersUseInfo

local CardInterpreter = Class:extend()

local usedCard = {}

local function _findCard(player: Player, cardId: string)
    local playerDeck = CardDeckManager:getPlayerDeck(player)
    if not playerDeck then
        return
    end
    local card = playerDeck:getCard(cardId)
    return card
end

local _checkUseInfo do
    
    _checkUseInfo = function(useInfo: MixinUseInfo, card)
        return true
    end
end

function CardInterpreter:getUseInfo(player: Player, cardId: string, ...)
    local card = _findCard(cardId)
    if not card then return end
    local args = {...}
    local cardUseType = card:getUseType()

    if cardUseType == "CouplePlayersUseCard" then
        if not (args[1] and typeof(args[1]) == "Instance" and args[1]:IsA("Player")) then
            return
        end
        local useInfo = {}
        useInfo.players = {unpack(args)}
        useInfo.decks = {}
        for _, player in ipairs(useInfo.players) do
            local deck = CardDeckManager:getPlayerDeck(player)
            table.insert(useInfo.decks, deck)
        end
        return useInfo
    end
    local useInfo = {}
    useInfo.cardOwner = player
    useInfo.cardOwnerDeck = CardDeckManager:getPlayerDeck(player)

    if cardUseType == "OnPlayerUseCard" then
        local defender = args[1]
        if not (defender and typeof(defender) == "Instance" and defender:IsA("Player")) then
            return
        end
        useInfo.defender = defender
        useInfo.defenderDeck = CardDeckManager:getPlayerDeck(defender)
    end
    return useInfo
end

function CardInterpreter:interpret(cardId: string, useInfo: MixinUseInfo)
    local foundCard = _findCard(useInfo.CardOwner, cardId)
    if foundCard == nil then
        return ErrorCodes.InvalidId
    end

    local isUseInfoValid = _checkUseInfo(useInfo, foundCard)
    if isUseInfoValid  == false then
        return ErrorCodes.InvalidUseInfo
    end
    local isCardHaveOverride = 
        CardOverrides:isCardHaveOverride(useInfo.CardOwner, foundCard:getName())
    
    if isCardHaveOverride == true then
        foundCard["use"] = 
            CardOverrides:getOverride(useInfo.CardOwner, foundCard:getName())
    end
    return ErrorCodes.Success, foundCard
end

return CardInterpreter