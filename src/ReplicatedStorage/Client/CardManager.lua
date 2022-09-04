--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local cardAdded = nil :: RemoteEvent
local cardRemoved = nil :: RemoteEvent

local CardManager = Class:extend()

CardManager.CardAdded = GoodSignal.new()
CardManager.CardRemoved = GoodSignal.new()

function CardManager:getCardName(cardId: string): string
    
end

function CardManager:getCardId(cardName: string): string
    
end

function CardManager:getCardImage(cardName: string): string
    
end

function CardManager:getCardDescription(cardName: string): string
    
end

function CardManager:useCard(cardId: string)
    
end

cardAdded.OnClientEvent:Connect(function(cardId)
    CardManager.CardAdded:Fire(cardId)
end)

cardRemoved.OnClientEvent:Connect(function(cardId)
    CardManager.CardRemoved:Fire(cardId)
end)

return CardManager