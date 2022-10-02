--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)

local CardUIElements = Class:extend()

do  
    local card = Instance.new("CanvasGroup")
    card.Name = "Card"
    card.AnchorPoint = Vector2.new(0.5, 1)
    card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    card.BackgroundTransparency = 1
    card.Position = UDim2.fromScale(0.5, 1)
    card.Size = UDim2.fromScale(0.175, 1)
    
    local cardButton = Instance.new("TextButton")
    cardButton.Name = "CardButton"
    cardButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    cardButton.Text = ""
    cardButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    cardButton.TextSize = 14
    cardButton.AutoButtonColor = false
    cardButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cardButton.BackgroundTransparency = 1
    cardButton.Size = UDim2.fromScale(1, 1)
    
    local uICorner = Instance.new("UICorner")
    uICorner.Name = "UICorner"
    uICorner.CornerRadius = UDim.new(0, 10)
    uICorner.Parent = cardButton
    
    cardButton.Parent = card
    
    local cardImage = Instance.new("ImageLabel")
    cardImage.Name = "CardImage"
    cardImage.Image = "http://www.roblox.com/asset/?id=8821058019"
    cardImage.ImageColor3 = Color3.fromRGB(227, 255, 181)
    cardImage.AnchorPoint = Vector2.new(0.5, 1)
    cardImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    cardImage.Position = UDim2.fromScale(0.5, 1)
    cardImage.Size = UDim2.fromScale(1, 0.85)
    
    local uICorner1 = Instance.new("UICorner")
    uICorner1.Name = "UICorner"
    uICorner1.CornerRadius = UDim.new(0, 10)
    uICorner1.Parent = cardImage
    
    cardImage.Parent = card
    
    local cardLabel = Instance.new("TextLabel")
    cardLabel.Name = "CardLabel"
    cardLabel.FontFace = Font.new(
      "rbxasset://fonts/families/Arial.json",
      Enum.FontWeight.Bold,
      Enum.FontStyle.Normal
    )
    cardLabel.Text = ""
    cardLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    cardLabel.TextScaled = true
    cardLabel.TextSize = 14
    cardLabel.TextWrapped = true
    cardLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    cardLabel.Size = UDim2.fromScale(1, 0.15)
    
    local uICorner2 = Instance.new("UICorner")
    uICorner2.Name = "UICorner"
    uICorner2.CornerRadius = UDim.new(0, 10)
    uICorner2.Parent = cardLabel
    
    local uIPadding = Instance.new("UIPadding")
    uIPadding.Name = "UIPadding"
    uIPadding.PaddingLeft = UDim.new(0.1, 0)
    uIPadding.PaddingRight = UDim.new(0.1, 0)
    uIPadding.Parent = cardLabel
    
    cardLabel.Parent = card
    
    local uIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    uIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    uIAspectRatioConstraint.AspectRatio = 0.75
    uIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
    uIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    uIAspectRatioConstraint.Parent = card

    function CardUIElements:getCardUI(cardName: string, cardId: string)
        local newCard = card:Clone()
        newCard.CardLabel.Text = cardName
        --return newCard
        return card
    end
end

do
    function CardUIElements:getDeckUI()
        
    end
end

return CardUIElements



