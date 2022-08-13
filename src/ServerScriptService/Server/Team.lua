--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
--[[
 	TEAM CLASS BEGIN
]]
local Team = Class:extend()

function Team:new(name: string, maxPlayers: number)
	self.MAXIMUM_PLAYERS_IN_TEAM = maxPlayers

	local team = Instance.new("Team")
	team.Name = name

	self.PlayerAdded = team.PlayerAdded
	self.PlayerRemoved = team.PlayerRemoved

	self._team = team
end

function Team:destroy()
	self._team:Destroy()
	table.clear(self)
	self = nil
end

function Team:assign(player: Player)
	local maxPlayers = self.MAXIMUM_PLAYERS_IN_TEAM :: number
	
	if #self._team:GetPlayers() == maxPlayers then
		return
	end
	
	player.Team = self._team
end

function Team:unassign(player: Player)
	if player.Team == self._team then
		player.Team = nil
	end
end


--function Team:isWon()
--	error("Not implemented method!")
--end

function Team:isPlayerInTeam(player: Player)
	return player.Team == self._team
end

function Team:getName()
	return self._team.Name
end

function Team:getPlayerCount()
	return #self._team:GetPlayers()
end
--[[
 	TEAM CLASS END
]]

return Team
