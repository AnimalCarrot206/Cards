--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)

local CardManager = Class:extend()
--Fires when server adds card to player deck
-- (cardName, cardId)
CardManager.CardAdded = GoodSignal.new()
--Fires when server removes card from player deck
-- (cardName, cardId)
CardManager.CardRemoved = GoodSignal.new()

local images = {}
local descriptions = {}

local cachedCards: {[string]: string} = {}
--[=[
    Returns cardName by provided id
]=]
function CardManager:getCardName(cardId: string): string?
    return cachedCards[cardId]
end
--[=[
    Returns cached cards that client must have at the moment
]=]
function CardManager:getAllReceivedCards()
    return cachedCards
end
--[=[
    Returns card imageId by provided cardName
]=]
function CardManager:getCardImage(cardName: string): string
    return images[cardName]
end
--[=[
    Returns card description by provided cardName
]=]
function CardManager:getCardDescription(cardName: string): string
    return descriptions[cardName]
end
--[=[
    Fires server with given cardId and useInfo
]=]
function CardManager:useCard(cardId: string, useInfo)
    Remotes.CardActivateOnClient:Fire(cardId, useInfo)
end
--[=[
    When card was added to player deck caches it and fire event
]=]
Remotes.CardAdded.OnClientEvent:Connect(function(cardName, cardId)
    CardManager.CardAdded:Fire(cardName, cardId)
    cachedCards[cardId] = cardName
end)
--[=[
    When card was removed from player deck uncaches it and fire event
]=]
Remotes.CardRemoved.OnClientEvent:Connect(function(cardName, cardId)
    CardManager.CardRemoved:Fire(cardName, cardId)
    cachedCards[cardId] = nil
end)

return CardManager