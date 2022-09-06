--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local TurnManager = require(game.ServerScriptService.Server.TurnManager)
local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)

local CardInterpreter = Class:extend()


local function _activateSelfUseCard(player: Player, cardInfo)
    local deck = CardDeckManager:getPlayerDeck(player)
    local cardUseInfo = {cardOwner = player, cardOwnerDeck = deck}
    deck:activateCard(cardInfo.id, cardUseInfo)
end

local function _activateOnPlayerUseCard(player: Player, cardInfo)
    local playerDeck = CardDeckManager:getPlayerDeck(player)
    local defenderDeck = CardDeckManager:getPlayerDeck(playerDeck)
    
end

local function _activateCoupleUsePlayersCard(player: Player, cardInfo)
    
end

function CardInterpreter:startInterpreting(player: Player)
    return Promise.new(function(resolve, reject, onCancel)
        for i = 1, 3, 1 do
            local playerCardInfo = TurnManager:getTurnOwnerCardUsed()
            local literal = string.sub(playerCardInfo.id, 1,2)
            
            if literal == CustomEnum.CardIdLiteral.OnPlayerUseCard then
                _activateOnPlayerUseCard(player, playerCardInfo)
            end
            if literal == CustomEnum.CardIdLiteral.SelfUseCard then
                _activateSelfUseCard(player, playerCardInfo)
            end
            if literal == CustomEnum.CardIdLiteral.CouplePlayersUseCard then
                _activateCoupleUsePlayersCard(player, playerCardInfo)
            end

        end
    end)
end

function CardInterpreter:stopInterpreting()
    
end