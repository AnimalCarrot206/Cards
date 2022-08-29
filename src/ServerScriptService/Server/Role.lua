--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)

local Role = Class:extend()

function Role:new(name: string, maxPlayers: number)
	assert(name)
	assert(maxPlayers)
	self.MAXIMUM_PLAYERS_ROLE = maxPlayers

	local team = Instance.new("Team")
	team.Name = name

	self.PlayerAdded = team.PlayerAdded
	self.PlayerRemoved = team.PlayerRemoved

	self._team = team
end

function Role:destroy()
	self._team:Destroy()
	table.clear(self)
	self = nil
end

function Role:assign(player: Player)
	local maxPlayers = self.MAXIMUM_PLAYERS_ROLE :: number
	
	if #self._team:GetPlayers() == maxPlayers then
		return
	end
	
	player.Team = self._team
end

function Role:unassign(player: Player)
	if player.Team == self._team then
		player.Team = nil
	end
end

--function Team:isWon()
--	error("Not implemented method!")
--end

function Role:isPlayerRole(player: Player): boolean
	return player.Team == self._team
end

function Role:getName(): string
	return self._team.Name :: string
end

function Role:getPlayers(): Array<Player>
	return self._team:GetPlayers()
end

function Role:getPlayerCount(): number
	return #self._team:GetPlayers()
end
--[[
 	ROLE CLASS END
]]

return Role
