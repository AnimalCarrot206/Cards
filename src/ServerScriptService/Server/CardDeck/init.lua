--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local Cards = require(game.ServerScriptService.Server.Cards):: {[string]: any}
local CardInput = require(game.ServerScriptService.Server.CardDeck.CardIput)

local DEFFAULT_DECK_CAPACITY = 6
local PLAYER_CARD_INPUT_TIMEOUT_IN_SECONDS = 20

local CardDeck = Class:extend()

local function _findCard(container, cardId: string)
    for index, card in ipairs(container) do
        if card:getId() == cardId then
            return card
        end
    end
end

function CardDeck:new(owner: Player, capacity: number?)
    self._owner = owner
    self._cards = {}
    self._capacity = capacity or DEFFAULT_DECK_CAPACITY
    self.CardActivated = Promise.new()
    self.CardAdded = GoodSignal.new()
end

function CardDeck:destroy()
    for index, card in ipairs(self._cards) do
        card:destroy()
        card = nil
    end
    table.clear(self._cards)
    table.clear(self)
    self = nil
end

function CardDeck:getOwner(): Player
    return self._owner
end

function CardDeck:addCard(cardName: string, isConsideringCapacity: true?)
    if isConsideringCapacity == true then
        if #self._cards >= self._capacity then
            error(string.format("Can't add card to player deck %s", self._owner.Name))
        end
    end
    local createdCard = Cards[cardName]()
    table.insert(self._cards)
    self.CardAdded:Fire(createdCard)
end

function CardDeck:removeCard(cardId: string)
    for index, card in ipairs(self._cards) do
        if card:getId() == cardId then
            card:destroy()
            table.remove(self._cards, index)
            card = nil
            return
        end
    end
end

function CardDeck:_getCards()
    return self._cards
end

function CardDeck:_addCard(cardName)
    table.insert(self._cards, cardName)
end

function CardDeck:activateCard(cardId: string, cardInfo)
    local card = _findCard(self._cards, cardId)

    local idLiteral = string.sub(cardId, 1, 2)

    assert(cardInfo.cardOwner ~= nil)
    assert(cardInfo.cardOwnerDeck ~= nil)
    if idLiteral == CustomEnum.CardIdLiteral.OnPlayerUseCard then
        assert(cardInfo.defender ~= nil)
        assert(cardInfo.defenderDeck ~= nil)
    end
    if idLiteral == CustomEnum.CardIdLiteral.CouplePlayersUseCard then
        assert(cardInfo.players ~= nil)
    end
    card:use(cardInfo)
end

function CardDeck:getCapacity()
    return self._capacity
end

function CardDeck:getFreeSpace(): number
    local capacity = self._capacity
    local occupiedPlace = #self._cards

    if occupiedPlace > capacity then
        return capacity
    end
    return capacity - occupiedPlace
end

function CardDeck:isCardInDeck(cardId: string): boolean
    return _findCard(self._cards, cardId) ~= nil
end

function CardDeck:cardRequest(cardName: string?)
    return Promise.new(function(resolve, reject, onCancel)
        return CardInput:listen(self._owner, cardName)
    end)
    :timeout(PLAYER_CARD_INPUT_TIMEOUT_IN_SECONDS)
end

return CardDeck