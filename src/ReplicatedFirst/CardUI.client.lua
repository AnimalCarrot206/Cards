--!strict
local CardManager = require(game.ReplicatedStorage.Client.ClientCardManager)
local DraggableObject = require(game.ReplicatedStorage.Client.DraggableObject)

local prepareConnections
local clearConnections
do
	prepareConnections = function(guiButton: GuiButton)
		local mouseEnterConnection
		local mouseLeaveConnection

		local mouseButtonDubleClickedConnection

		local frameDrag = DraggableObject.new(guiButton)

		do
			mouseEnterConnection = guiButton.MouseEnter:Connect(function(x, y)
				
			end)
			mouseLeaveConnection = guiButton.MouseLeave:Connect(function(x, y)
				
			end)
		end

		do
			mouseButtonDubleClickedConnection = guiButton.MouseButton1Click:Connect(function()
				
			end)
		end

		do
			frameDrag:Enable()
			frameDrag.DragStarted = function()
				
			end
			frameDrag.Dragged = function(newPosition)
				
			end
			frameDrag.DragEnded = function()
				
			end
		end
	end
end

local frame = script.Parent.Frame :: Frame

local function createCard(cardName: string, cardId: string)
	local card = Instance.new("TextButton")
	card.Name = cardName
	card.Text = ""
	card.BackgroundColor3 = 
		Color3.fromRGB(math.random(0, 255),math.random(0, 255),math.random(0, 255))
	card.ClipsDescendants = true
	card.LayoutOrder = 1
	card.Size = UDim2.fromScale(0.15, 0.9)

	card:SetAttribute("CardId", cardId)
	card:SetAttribute("CardName", cardName)
	
	local uICorner = Instance.new("UICorner")
	uICorner.Name = "UICorner"
	uICorner.Parent = card
	
	local uIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	uIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
	uIAspectRatioConstraint.AspectRatio = 0.75
	uIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
	uIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	uIAspectRatioConstraint.Parent = card
	
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.FontFace = Font.new(
	  "rbxasset://fonts/families/Arial.json",
	  Enum.FontWeight.Bold,
	  Enum.FontStyle.Normal
	)
	label.Text = cardName
	label.TextColor3 = Color3.fromRGB(0, 0, 0)
	label.TextScaled = true
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	label.BorderSizePixel = 0
	label.Position = UDim2.fromScale(0.5, 0.1)
	label.Size = UDim2.fromScale(1, 0.2)
	
	local uIPadding = Instance.new("UIPadding")
	uIPadding.Name = "UIPadding"
	uIPadding.PaddingLeft = UDim.new(0.15, 0)
	uIPadding.PaddingRight = UDim.new(0.15, 0)
	uIPadding.Parent = label
	
	local uICorner1 = Instance.new("UICorner")
	uICorner1.Name = "UICorner"
	uICorner1.Parent = label
	
	label.Parent = card
	
	local image = Instance.new("ImageLabel")
	image.Name = "Image"
	image.ImageColor3 = Color3.fromRGB(255,255,255)
	image.AnchorPoint = Vector2.new(0.5, 0)
	image.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	image.BackgroundTransparency = 1
	image.BorderSizePixel = 0
	image.Position = UDim2.fromScale(0.5, 0.2)
	image.Size = UDim2.fromScale(1, 0.8)
	image.Parent = card
	--image.Image = CardManager:getCardImage(cardName)
end

local function destroyCard(cardName: string, cardId: string)
	for index, card in ipairs(frame:GetChildren()) do
		if not card:IsA("TextButton") then return end
		
		if 
			card:GetAttribute("CardName") == cardName and
			card:GetAttribute("CardId") == cardId 
		then
				
		end
	end
end

CardManager.CardAdded:Connect(createCard)
CardManager.CardRemoved:Connect(destroyCard)