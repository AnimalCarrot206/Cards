--!strict
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local TweenService = game:GetService("TweenService")

local CardManager = require(game.ReplicatedStorage.Client.ClientCardManager)
local CardUIElements = require(game.ReplicatedStorage.Client.CardUIElements)

local CardPositions = require(script.CardPositions)
local CardRotation = require(script.CardRotations)

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Container = script.Parent :: Frame

local CARD_ID_ATTRIBUTE_NAME = "CardId"
local CARD_NAME_ATTRIBUTE_NAME = "CardName"
local IS_CARD_RAISED_ATTRIBUTE_NAME = "IsRaised"

do
    local Cards: {GuiObject} = {}

	local function onCardAdded(cardName: string, cardId: string)
        local card = CardUIElements:getCardUI(cardName, cardId)

		table.insert(Cards, card)

		card:SetAttribute(CARD_ID_ATTRIBUTE_NAME, cardId)
        card:SetAttribute(CARD_NAME_ATTRIBUTE_NAME, cardName)

		CardPositions.setPositionsInOrder(Cards)
	end

	local function onCardRemoved(_, cardId: string)
		for index, card in ipairs(Cards) do
			if card:GetAttribute(CARD_ID_ATTRIBUTE_NAME) ~= cardId then continue end

			table.remove(Cards, index)
			CardPositions.setPositionsInOrder(Cards)
		end
	end
	
    CardManager.CardAdded:Connect(onCardAdded)
    CardManager.CardRemoved:Connect(onCardRemoved)
end