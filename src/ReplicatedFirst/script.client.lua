--!strict
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local TweenService = game:GetService("TweenService")

local CardManager = require(game.ReplicatedStorage.Client.ClientCardManager)
local CardUIElemnts = require()

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Container = script.Parent

do
    local Cards = {}

	local function onCardAdded(cardName: string, cardId: string)

	end

	local function onCardRemoved(cardName: string, cardId: string)

	end
	
    CardManager.CardAdded:Connect(onCardAdded)
    CardManager.CardRemoved:Connect(onCardRemoved)
end