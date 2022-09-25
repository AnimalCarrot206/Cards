--!strict
local CardManager = require(game.ReplicatedStorage.Client.ClientCardManager)
local DraggableObject = require(game.ReplicatedStorage.Client.DraggableObject)

local Fusion = require(game.ReplicatedStorage.Client.Fusion)
local New = Fusion.New
local Children = Fusion.Children

local frame = script.Parent.Frame :: Frame

local function Card(props: {CardName: string, CardId: string})
	return New "TextButton" {
		Parent = frame,

		Name = props.CardName,
		Text = "",
		BackgroundColor3 = 
		Color3.fromRGB(math.random(0, 255),math.random(0, 255),math.random(0, 255)),
		ClipsDescendants = true,
		LayoutOrder = 1,
		Size = UDim2.fromScale(0.15, 0.9),

		[Children] = {
			New "UICorner" {
				Name = "UICorner",
			},
			New "UIAspectRatioConstraint" {
				Name = "UIAspectRatioConstraint",
				AspectRatio = 0.75,
				AspectType = Enum.AspectType.ScaleWithParentSize,
				DominantAxis = Enum.DominantAxis.Height,
			},
			New "Label" {
				Name = "Label",
				FontFace = Font.new(
	  		"rbxasset://fonts/families/Arial.json",
	  		Enum.FontWeight.Bold,
	  		Enum.FontStyle.Normal
			),
				Text = props.CardName,
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextScaled = true,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.1),
				Size = UDim2.fromScale(1, 0.2),

				[Children] = {
					New "UIPadding" {
						Name = "UIPadding",
						PaddingLeft = UDim.new(0.15, 0),
						PaddingRight = UDim.new(0.15, 0),
					},
					New "UICorner" {Name = "UICorner"}
				}
			},
			New "ImageLabel" {
				Name = "Image",
				ImageColor3 = Color3.fromRGB(255,255,255),
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.fromScale(0.5, 0.2),
				Size = UDim2.fromScale(1, 0.8),
				--image.Image = CardManager:getCardImage(cardName),
			}
		}
	}
end

return Card