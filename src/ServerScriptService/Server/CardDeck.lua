--!strict

local Class = require(game.ReplicatedStorage.Shared.Class)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)

local Cards = require(game.ServerScriptService.Server.Cards)

local CardDeck = Class:extend()

local DEFAULT_DECK_CAPACITY = 6
--[=[
    Finds a card returned by Cards module
]=]
local function _findCard(cardName: string)
    local success, result = pcall(function()
        return Cards[cardName]
    end)

    if success then
        return result
    else 
        error(string.format("Card %s doesn't exist", cardName))
    end
end

local function _notifyClientThatCardRemoved(player: Player, cardId: string)
    Remotes.CardRemoved:FireClient(player, cardId)
end

local function _notifyClientThatCardAdded(player: Player, cardId: string)
    Remotes.CardAdded:FireClient(player, cardId)
end

function CardDeck:new(owner: Player, deckCapacity: number?)
    self._owner = owner
    self._cards = {}
    self._capacity = deckCapacity or DEFAULT_DECK_CAPACITY
end

function CardDeck:destroy()
    for playerName, card in pairs(self._cards) do
        card:destroy()
        self._cards[playerName] = nil
    end

    table.clear(self)
    self = nil
end
--[=[
    Adds a card into the deck, if there's enough space for it
]=]
function CardDeck:addCard(cardName: string)
    local foundCard = _findCard(cardName)
    local createdCard = foundCard()
    
    if self:getDeckFreeSpace() > 0 then
        table.insert(self._cards, createdCard)
        _notifyClientThatCardAdded(self._owner, createdCard:getId())
    end
end
--[=[
    Removes a card from the deck and destroys it
]=]
function CardDeck:removeCard(cardId: string)
    for i, card in ipairs(self._cards) do
        if card:getId() == cardId then
            table.remove(self._cards, i)
            card:destroy()
            _notifyClientThatCardRemoved(self._owner, cardId)
            return
        end
    end
end
--[=[
    Adds a card into the deck, without space limit
]=]
function CardDeck:addExtraCard(cardName: string)
    local foundCard = _findCard(cardName)
    local createdCard = foundCard()

    table.insert(self._cards, createdCard)
    _notifyClientThatCardAdded(self._owner, createdCard:getId())
end
--[=[
    Returns the first found card with the cardName
]=]
function CardDeck:findFirstCard(cardName: string)
    for i, card in ipairs(self._cards) do
        if card:getName() == cardName then
            return card
        end
    end
end
--[=[
    Returns a card with same cardId
]=]
function CardDeck:findCard(cardId: string)
    for i, card in ipairs(self._cards) do
        if card:getId() == cardId then
            return card
        end
    end
end
--[=[
    Returns player deck capacity number
]=]
function CardDeck:getDeckCapacity()
    return self._capacity :: number
end
--[=[
    Returns amount of free space in the deck
]=]
function CardDeck:getDeckFreeSpace(): number
    return  self._capacity - #self._cards
end

return CardDeck