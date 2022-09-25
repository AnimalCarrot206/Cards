--!strict
local CardManager = require(game.ReplicatedStorage.Client.ClientCardManager)

local CardUI = require(game.ReplicatedFirst.CardUI)

local Fusion = require(game.ReplicatedStorage.Client.Fusion)
local New = Fusion.New
local Computed = Fusion.Computed
local ComputedPairs = Fusion.ComputedPairs
local State = Fusion.State
local Children = Fusion.Children

local CardDeck = {}

local connections = {
    CardAdded = nil,
    CardRemoved = nil,
}

local Cards = State({})

local Positions do
    local CENTER_POSITION = UDim2.fromScale(0.5, 0.5)
	
	local START_POSITION = UDim2.fromScale(0, 0.6)
	local END_POSITION = UDim2.fromScale(1, 0.5)

    Positions = ComputedPairs(Cards, function(index, value)
        local length = Cards:get()
        local stepX = (END_POSITION.X.Scale - START_POSITION.X.Scale) / length
        local stepY = (END_POSITION.Y.Scale - START_POSITION.Y.Scale) / length

        return UDim2.new(
            START_POSITION.X.Scale + stepX * index,
            START_POSITION.Y.Scale + stepY * index
        )
    end)
end

function CardDeck:initialize()
    CardManager.CardAdded:Connect(function(cardName: string, cardId: string)
        local card = CardUI({CardName = cardName, CardId = cardId})
        card:SetAttribute("CardName", cardName)
        card:SetAttribute("CardId", cardId)
        
        local newTable = Cards:get()
        table.insert(newTable, card)
        Cards:set(newTable)
    end)

    CardManager.CardRemoved:Connect(function(cardName: string, cardId: string)
        local newTable = Cards:get()

        for index, card in ipairs(newTable) do
            if card:GetAttribute("CardId") == cardId then
                table.remove(newTable, index)
                card:Destroy()
            end
        end
        Cards:set(newTable)
    end)

    local fake = Instance.new("Frame")
    fake.Name = "Fake"
    fake.AnchorPoint = Vector2.new(0.5, 0)
    fake.BackgroundTransparency = 1
    fake.Position = UDim2.fromScale(0.5, 0.665)
    fake.Size = UDim2.fromScale(0.1, 0.15)
    
    local uIScale = Instance.new("UIScale")
    uIScale.Name = "UIScale"
    uIScale.Scale = 1.75
    uIScale.Parent = fake

    return New "Frame" {
        Name = "Fake",
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.665),
        Size = UDim2.fromScale(0.175, 0.2625),

        [Children] = Cards
    }
end

return CardDeck