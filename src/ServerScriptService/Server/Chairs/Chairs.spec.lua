--!strict
local chairs = require(script.Parent)

repeat
	game.Players.PlayerAdded:Wait()
until #game.Players:GetPlayers() >= 8

chairs:assignAllPlayers()
