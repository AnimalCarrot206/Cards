--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)
local CardOverrides = require(game.ServerScriptService.Server.CardOverrides)

local ErrorCodes = require(script.ErrorCodes)

type UseInfo = {
    CardOwner: Player,
    Other: {any}
}

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
    
    _checkUseInfo = function(useInfo: UseInfo, card)
        return true
    end
end

function CardInterpreter:interpret(cardId: string, useInfo: UseInfo)
    local foundCard = _findCard(useInfo.CardOwner, cardId)
    if not foundCard then
        return ErrorCodes.InvalidId
    end

    local isUseInfoValid = _checkUseInfo(useInfo, foundCard)
    if not isUseInfoValid then
        return ErrorCodes.InvalidUseInfo
    end
    local isCardHaveOverride = 
        CardOverrides:isCardHaveOverride(useInfo.CardOwner, foundCard:getName())
    
    if isCardHaveOverride then
        foundCard["use"] = 
            CardOverrides:getOverride(useInfo.CardOwner, foundCard:getName())
    end
    return ErrorCodes.Success, foundCard
end

return CardInterpreter