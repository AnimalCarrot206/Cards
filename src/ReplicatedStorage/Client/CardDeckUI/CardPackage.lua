local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local CardManager = require(game.ReplicatedStorage.Client.ClientCardManager)
local CalculateRange = require(game.ReplicatedStorage.Shared.CalculateRange)

function _highlightPlayers()
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

local function _isCollidesWith(gui1: GuiObject, gui2: GuiObject)
	local gui1_topLeft = gui1.AbsolutePosition
	local gui1_bottomRight = gui1_topLeft + gui1.AbsoluteSize

	local gui2_topLeft = gui2.AbsolutePosition
	local gui2_bottomRight = gui2_topLeft + gui2.AbsoluteSize

	return ((gui1_topLeft.X < gui2_bottomRight.X and gui1_bottomRight.X > gui2_topLeft.X) and
		(gui1_topLeft.Y < gui2_bottomRight.Y and gui1_bottomRight.Y > gui2_topLeft.Y)) 
end

function _isCanShoot(playerA, playerB)
	local playerASitPlace = PlayerStats:getPlayerSitPlace(playerA)
	local playerBSitPlace = PlayerStats:getPlayerSitPlace(playerB)

	local distance = 
		CalculateRange(playerASitPlace, playerBSitPlace)
		+ PlayerStats:getAdditionalRemoteness(playerB)

	return distance > PlayerStats:getRange(game.Players.LocalPlayer) 
end

function _highlightPlayersForShoot()
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

function _disableHighlights()
	local allPlayers = game.Players:GetPlayers()
	for i, player in ipairs(allPlayers) do
		local character = player.Character
		local highlight = character:FindFirstChildOfClass("Highlight")
		if highlight then highlight:Destroy() end
	end
end

function _selfUseCardActivate(card, centerFrame)
	local isCollideWithCenterFrame = _isCollidesWith(card, centerFrame)
	if isCollideWithCenterFrame == true then
		CardManager:useCard(card:GetAttribute("CardId"))
		--removeCard(card:GetAttribute("CardName"), card:GetAttribute("CardId"))
	end
end

function _getMouseTargetingPlayer(): Player?
	local Mouse = game.Players.LocalPlayer:GetMouse()
	local mouseTarget = Mouse.Target
	if mouseTarget and mouseTarget:FindFirstAncestorOfClass("Model") then
		local Character = mouseTarget:FindFirstAncestorOfClass("Model")
		local Player = game.Players:GetPlayerFromCharacter(Character)
		return Player
	end
	return nil
end

function _onPlayerUseCardActivate(card)
	local Player = _getMouseTargetingPlayer()
	if Player then
		CardManager:useCard(card:GetAttribute("CardId"), Player)
		_disableHighlights()
	end
end

return {
	highlightPlayers = _highlightPlayers,
	isCollidesWith = _isCollidesWith,
	isCanShoot = _isCanShoot,
	highlightPlayersForShoot = _highlightPlayersForShoot,
	disableHighlights = _disableHighlights,
	selfUseCardActivate = _selfUseCardActivate,
	getMouseTargetingPlayer = _getMouseTargetingPlayer,
	onPlayerUseCardActivate = _onPlayerUseCardActivate,
}
