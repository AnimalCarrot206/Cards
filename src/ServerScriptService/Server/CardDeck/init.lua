--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local Promise = require(game.ReplicatedStorage.Shared.Promise)

local Cards = require(game.ServerScriptService.Server.Cards)
local CardInput = require(game.ServerScriptService.Server.CardDeck.CardIput)

local CardDeck = Class:extend()

function CardDeck:new(owner: Player)
    self._owner = owner
    self._cards = {}
    self.CardActivated = Promise.new()
end

function CardDeck:destroy()
    
end

function CardDeck:getOwner()
    return self._owner
end

function CardDeck:addCard(cardName)
    
end

function CardDeck:removeCard(cardId)
    
end

function CardDeck:activateCard(cardId)
    
end

function CardDeck:cardRequest()
    return Promise.new(function(resolve, reject, onCancel)
        
    end)
end

