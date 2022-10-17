--!strict
local CardManager = require(game.ReplicatedStorage.Client.ClientCardManager)

local CardUIElements = require(game.ReplicatedStorage.Client.CardUIElements)
local DraggableObject = require(game.ReplicatedStorage.Client.DraggableObject)
local Animate = require(game.ReplicatedStorage.Shared.Animate)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)


local CenterFrame = Instance.new("Frame")
CenterFrame.Size = UDim2.fromScale(0.1, 0.2)
CenterFrame.Name = "CenterFrame"
CenterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CenterFrame.Position = UDim2.fromScale(0.5, 0.5)

local function getNonRaisedCardCount(cards: {GuiObject})
	local n = 0
	for i, card in ipairs(cards) do
		if card:GetAttribute("IsRaised") == true then continue end
		n += 1
	end
	return n
end

local getPositions do
	local CENTER_POSITION = UDim2.fromScale(0.5, 0.5)

	local START_POSITION = UDim2.fromScale(0, 0.6)
	local END_POSITION = UDim2.fromScale(1, 0.5)

	getPositions = function(cards): {UDim2}
		local length = getNonRaisedCardCount(cards)
		local stepX = (END_POSITION.X.Scale - START_POSITION.X.Scale) / (length + 1)
		local stepY = (END_POSITION.Y.Scale - START_POSITION.Y.Scale) / (length + 1)

		local positions = {}
		local currentStep = 1
		for _, card:GuiObject in ipairs(cards) do
			if card:GetAttribute("IsRaised") == true then
				table.insert(positions, card.Position)
			end
			local position = UDim2.fromScale(
				START_POSITION.X.Scale + stepX * currentStep,
				START_POSITION.Y.Scale + stepY * currentStep
			)
			table.insert(positions, position)
		end
		return positions
	end
end

local getRotations do
	local MIN_ROTATION = -10
	local MAX_ROTATION = 10

	getRotations = function(cards): {number}
		local length = getNonRaisedCardCount(cards)
		local rotationStep = (math.abs(MIN_ROTATION) + MAX_ROTATION) / (length + 1)

		local rotations = {}
		local currentStep = 1
		for index, card in ipairs(cards) do
			if card:GetAttribute("IsRaised") == true then
				table.insert(rotations, 0)
			end
			local rotation = MIN_ROTATION + rotationStep * currentStep
			table.insert(rotations, rotation)
		end
		return rotations
	end
end


local raiseCard
local releaseCard
do
	local tweenInfo = 
		TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	releaseCard = function(card: GuiObject)
		Animate:animate(card, {
			Position = card:GetAttribute("StartPosition"),
			Rotation = card:GetAttribute("StartRotation")
		}, tweenInfo)
	end
	raiseCard = function(card: GuiObject)
		local position = UDim2.new(card.Position.X.Scale, 0, -0.2, 0)
		local rotation = 0
		Animate:animate(card, {
			Position = position,
			Rotation = rotation
		}, tweenInfo)
	end
end

local addCard
local removeCard
local activateCard
local prepareConnections

do
	local Cards = {}

	local function _handlePositions()
		local positions = getPositions(Cards)
		local rotations = getRotations(Cards)
		local tweenInfo =
			TweenInfo.new(0.1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

		for i, card: Instance in ipairs(Cards) do
			local position = positions[i]
			local rotation = rotations[i]
			card:SetAttribute("StartPosition", position)
			card:SetAttribute("StartRotation", rotation)
			Animate:animateWithYielding(card, {
				Position = position,
				Rotation = rotation
			}, tweenInfo)
		end
	end

	removeCard = function(cardName: string, cardId: string)
		for i, card in ipairs(Cards) do
			if card:GetAttribute("CardId") == cardId then
				table.remove(Cards, i)
				card:Destroy()
				_handlePositions()
			end
		end
	end

	addCard = function(container: Frame, cardName: string, cardId: string)
		local card = CardUIElements:getCardUI(cardName, cardId)
		card:SetAttribute("CardName", cardName)
		card:SetAttribute("CardId", cardId)
		card:SetAttribute("IsRaised", false)

		local cardUseType = CardManager:getUseType(cardId)
		card:SetAttribute("CardUseType", cardUseType)

		table.insert(Cards, card)
		card.Parent = container
		_handlePositions()
		prepareConnections(card)

	end

	do
		local CardPackage = require(script.CardPackage)

		local previousRaisedCard = nil
		local cardRaised = GoodSignal.new()
		local cardReleased = GoodSignal.new()

		prepareConnections = function(card: CanvasGroup)
			local draggableObject = DraggableObject.new(card)
			draggableObject:Enable()

			do
                local cardButton = card.CardButton :: GuiButton
				local count = 0
				local threshHold = 2
				local clickTime = 0.3

				cardButton.MouseButton1Click:Connect(function()
					if draggableObject.Dragging == true then return end
					count += 1
					local isRaised = card:GetAttribute("IsRaised")

					if count % threshHold == 0 and isRaised == false then
						card:SetAttribute("IsRaised", true)
						if previousRaisedCard ~= nil and previousRaisedCard ~= card then
							previousRaisedCard:SetAttribute("IsRaised", false)
						end
						previousRaisedCard = card
						cardRaised:Fire()
					elseif isRaised == true then
						card:SetAttribute("IsRaised", false)
						cardReleased:Fire()
					end
					task.wait(clickTime)
					count -= 1
				end)
				
				card.AttributeChanged:Connect(function(attributeName)
					if attributeName ~= "IsRaised" then return end
					local isRaised = card:GetAttribute("IsRaised")
					if isRaised == true then
						raiseCard(card)
					else
						releaseCard(card)
					end
				end)
				
				cardReleased:Connect(function()
					draggableObject:Enable()
				end)
				cardRaised:Connect(function()
					draggableObject:Disable()
				end)
			end

			local cardUseType = card:GetAttribute("CardUseType")

			draggableObject.DragEnded:Connect(function()
				if 
					cardUseType == "SelfUseCard" or 
					cardUseType == "CouplePlayersUseCard" or
					card:GetAttribute("CardName") == "Miss"
				then
					CardPackage.selfUseCardActivate(card)
				elseif card:GetAttribute("Bang!!") then
					local player = CardPackage.getMouseTargetingPlayer()
					if player and CardPackage.isCanShoot(game.Players.LocalPlayer, player) then
						CardManager:useCard(card:GetAttribute("CardId"), player)
					end
				elseif cardUseType == "OnPlayerUseCard" then
					CardPackage.onPlayerUseCardActivate(card)
				end
				releaseCard(card)
			end)

			draggableObject.DragStarted:Connect(function()
				if card:GetAttribute("CardName") == "Bang!!" then
					CardPackage.highlightPlayersForShoot()
				end
				if cardUseType == "OnPlayerUseCard" then
					CardPackage.highlightPlayers()
				end
			end)


		end
	end

end

function CardDeck()
	local container = Instance.new("Frame")
    container.Name = "CardContainer"
    container.AnchorPoint = Vector2.new(0.5, 0)
    container.BackgroundTransparency = 1
    container.Position = UDim2.fromScale(0.5, 0.665)
    container.Size = UDim2.fromScale(0.175, 0.2625)

	CardManager.CardAdded:Connect(function(cardName: string, cardId: string)
		addCard(container, cardName, cardId)
	end)

	CardManager.CardRemoved:Connect(function(cardName: string, cardId: string)
		removeCard(cardName, cardId)
	end)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CardDeckScreenGui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false

    CenterFrame.Parent = screenGui
    container.Parent = screenGui
end

return CardDeck