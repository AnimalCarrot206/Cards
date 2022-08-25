--!strict

local Class = require(game.ReplicatedStorage.Shared.Class)

local CardDecisionmaking = Class:extend()

local CardDeckManager = nil :: any

CardDecisionmaking.PlayerCard = nil
CardDecisionmaking.EnemyCard = nil

local function _getCard(player: Player, cardName: string)
    local playerDeck = CardDeckManager:getPlayerDeck(player)
    assert(playerDeck)

    local foundCard = playerDeck:getCard(cardName)
    assert(foundCard)
    return foundCard
end

function CardDecisionmaking:setPlayerActivatedCard(player: Player, cardName: string)
    self.PlayerCard = _getCard(player, cardName)
end

function CardDecisionmaking:setEnemyActivaredCard(enemy: Player, cardName: string)
    self.EnemyCard = _getCard(enemy, cardName)
end

function CardDecisionmaking:makeDecision()
    
end