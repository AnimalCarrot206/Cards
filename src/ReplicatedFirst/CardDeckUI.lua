--!strict
local CardManager = require(game.ReplicatedStorage.Client.ClientCardManager)

local CardUI = require(game.ReplicatedFirst.CardUI)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local DraggableObject = require(game.ReplicatedStorage.Client.DraggableObject)
local Animate = require(game.ReplicatedStorage.Shared.Animate)
local CalculateRange = require(game.ReplicatedStorage.Shared.CalculateRange)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local Fusion = require(game.ReplicatedStorage.Client.Fusion)
local New = Fusion.New
local Children = Fusion.Children

local CenterFrame = Instance.new("Frame")
CenterFrame.Size = UDim2.fromScale(0.1, 0.2)
CenterFrame.Name = "CenterFrame"
CenterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CenterFrame.Position = UDim2.fromScale(0.5, 0.5)

local getPositions do
	local CENTER_POSITION = UDim2.fromScale(0.5, 0.5)

	local START_POSITION = UDim2.fromScale(0, 0.6)
	local END_POSITION = UDim2.fromScale(1, 0.5)

	getPositions = function(Cards): {UDim2}
		local length = #Cards
		local stepX = (END_POSITION.X.Scale - START_POSITION.X.Scale) / (length + 1)
		local stepY = (END_POSITION.Y.Scale - START_POSITION.Y.Scale) / (length + 1)

		local positions = {}
		for index, card in ipairs(Cards) do
			local position = UDim2.fromScale(
				START_POSITION.X.Scale + stepX * index,
				START_POSITION.Y.Scale + stepY * index
			)
			positions[index] = position
		end
		return positions
	end
end

local getRotations do
	local MIN_ROTATION = -10
	local MAX_ROTATION = 10

	getRotations = function(Cards): {number}
		local length = #Cards
		local rotationStep = (math.abs(MIN_ROTATION) + MAX_ROTATION) / (length + 1)

		local rotations = {}
		for index, card in ipairs(Cards) do
			local rotation = MIN_ROTATION + rotationStep * index
			rotations[index] = rotation
		end
		return rotations
	end
end

local addCard
local removeCard
local raiseCard
local releaseCard
local activateCard
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

	local function _isCollidesWith(gui1: GuiObject, gui2: GuiObject)
		local gui1_topLeft = gui1.AbsolutePosition
		local gui1_bottomRight = gui1_topLeft + gui1.AbsoluteSize

		local gui2_topLeft = gui2.AbsolutePosition
		local gui2_bottomRight = gui2_topLeft + gui2.AbsoluteSize

		return ((gui1_topLeft.X < gui2_bottomRight.X and gui1_bottomRight.X > gui2_topLeft.X) and
			(gui1_topLeft.Y < gui2_bottomRight.Y and gui1_bottomRight.Y > gui2_topLeft.Y)) 
	end

	do
		local _prepareConnections do
			local previousRaisedCard = nil
			local cardRaised = GoodSignal.new()
			local cardReleased = GoodSignal.new()

			local function _highlightPlayers()
				local allPlayers = game.Players:GetPlayers()
				for i, player in ipairs(allPlayers) do
					if player:GetAttribute("IsInGame") ~= true then continue end
					if player == game.Players.LocalPlayer then continue end
					local character = player.Character
					local highlight = Instance.new("Highlight")
					highlight.FillColor = Color3.fromRGB(7, 197, 255)
					highlight.OutlineColor = Color3.fromRGB(87, 241, 255)
					highlight.FillTransparency = 0.2
					highlight.Parent = character
				end
			end

			local function _isCanShoot(playerA, playerB)
				local playerASitPlace = PlayerStats.sitPlace:get(playerA)
				local playerBSitPlace = PlayerStats.sitPlace:get(playerA)

				local distance = 
					CalculateRange(playerASitPlace, playerBSitPlace)
						+ PlayerStats.additionalRemoteness:get(playerB)
					
				return distance > PlayerStats.range:get(playerA)
			end

			local function _highlightPlayersForShoot()
				local allPlayers = game.Players:GetPlayers()
				for i, player in ipairs(allPlayers) do
					if player:GetAttribute("IsInGame") ~= true then continue end
					if player == game.Players.LocalPlayer then continue end

					local character = player.Character
					local highlight = Instance.new("Highlight")
					highlight.FillColor = Color3.fromRGB(7, 197, 255)
					highlight.OutlineColor = Color3.fromRGB(87, 241, 255)
					highlight.FillTransparency = 0.2

					if _isCanShoot(game.Players.LocalPlayer, player) == false then
						highlight.FillColor = Color3.fromRGB(199, 23, 23)
						highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
					end

					highlight.Parent = character
				end
			end

			local function _disableHighlights()
				local allPlayers = game.Players:GetPlayers()
				for i, player in ipairs(allPlayers) do
					local character = player.Character
					local highlight = character:FindFirstChildOfClass("Highlight")
					if highlight then highlight:Destroy() end
				end
			end

			local function _selfUseCardActivate(card)
				local isCollideWithCenterFrame = _isCollidesWith(card, CenterFrame)
				if isCollideWithCenterFrame == true then
					CardManager:useCard(card:GetAttribute("CardId"))
					removeCard(card:GetAttribute("CardName"), card:GetAttribute("CardId"))
				end
			end
			
			local function _getMouseTargetingPlayer()
				local Mouse = game.Players.LocalPlayer:GetMouse()
				local mouseTarget = Mouse.Target
				if mouseTarget and mouseTarget:FindFirstAncestorOfClass("Model") then
					local Character = mouseTarget:FindFirstAncestorOfClass("Model")
					local Player = game.Players:GetPlayerFromCharacter(Character)
					return Player
				end
			end
			
			local function _onPlayerUseCardActivate(card)
				local Player = _getMouseTargetingPlayer()
				if Player then
					CardManager:useCard(card:GetAttribute("CardId"), Player)
					_disableHighlights()
				end
			end

			_prepareConnections = function(card: GuiButton)	
				local draggableObject = DraggableObject.new(card)
				draggableObject:Enable()

				card:SetAttribute("IsRaised", false)
				do
					local count = 0
					local threshHold = 2
					local clickTime = 0.3

					card.MouseButton1Click:Connect(function()
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
				end
				card.AttributeChanged:Connect(function(attribute)
					if attribute == "IsRaised" then
						local isRaised = card:GetAttribute("IsRaised")
						if isRaised == true then
							raiseCard(card)
							return
						end
						if isRaised == false then
							releaseCard(card)
							return
						end
					end
				end)
				cardReleased:Connect(function()
					draggableObject:Enable()
				end)
				cardRaised:Connect(function()
					draggableObject:Disable()
				end)
				do 
					local cardUseType = card:GetAttribute("CardUseType")

					draggableObject.DragEnded:Connect(function()
						if 
							cardUseType == "SelfUseCard" or 
							cardUseType == "CouplePlayersUseCard" or
							card:GetAttribute("CardName") == "Miss"
						then
							_selfUseCardActivate(card)
						elseif card:GetAttribute("Bang!!") then
							local player = _getMouseTargetingPlayer()
							if player and _isCanShoot(game.Players.LocalPlayer, player) then
								CardManager:useCard(card:GetAttribute("CardId"), player)
							end
						elseif cardUseType == "OnPlayerUseCard" then
							_onPlayerUseCardActivate(card)
						end
						releaseCard(card)
					end)

					draggableObject.DragStarted:Connect(function()
						if card:GetAttribute("CardName") == "Bang!!" then
							_highlightPlayersForShoot()
						end
						if cardUseType == "OnPlayerUseCard" then
							_highlightPlayers()
						end
					end)

				end
			end
		end
		addCard = function(container: Instance, cardName: string, cardId: string)
			local card = CardUI({
				CardName = cardName,
				CardId = cardId,
				StartPos = UDim2.fromScale(0.5, -1.5)
			})
			card:SetAttribute("CardName", cardName)
			card:SetAttribute("CardId", cardId)

			local cardUseType = CardManager:getUseType(cardId)
			card:SetAttribute("CardUseType", cardUseType)

			table.insert(Cards, card)
			card.Parent = container
			_handlePositions()
			_prepareConnections(card)

		end
	end
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

end

function CardDeck()
	local container = New "Frame" {
		Name = "CardContainer",
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.5, 0.665),
		Size = UDim2.fromScale(0.175, 0.2625),
	}

	CardManager.CardAdded:Connect(function(cardName: string, cardId: string)
		addCard(container, cardName, cardId)
	end)

	CardManager.CardRemoved:Connect(function(cardName: string, cardId: string)
		removeCard(cardName, cardId)
	end)
	return New "ScreenGui" {
		Name = "CardDeckScreenGui",
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		ResetOnSpawn = true,

		[Children] = {
			container,
			CenterFrame
		}
	}
end

return CardDeck