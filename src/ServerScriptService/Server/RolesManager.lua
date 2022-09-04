--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)

local Roles = require(game.ServerScriptService.Server.Roles)

local RolesManager = Class:extend()

local createdRoles = {}
--[=[
	Creates all in-game roles, must be called on game start
]=]
function RolesManager:createRoles()
	for roleName, role in pairs(Roles) do
		local newRole = role()
		table.insert(createdRoles, newRole)
	end
end
--[=[
	Assigns all players in game to roles, must be called after roles creating
]=]
function RolesManager:assignPlayers()
	assert(#createdRoles > 0)
	local allPlayers = Players:GetPlayers()
	
	for roleIndex, role in pairs(createdRoles) do
		for i = role:getMaxPlayersCount(), 0, -1 do
			local randomIndex = math.random(1, #allPlayers)
			local player = allPlayers[randomIndex]

			role:assign(player)
			table.remove(allPlayers, randomIndex)
		end
	end
end
--[=[
	Unassigns all players roles, must be called on game ends
]=]
function RolesManager:unassignPlayers()
	local allPlayers = Players:GetPlayers()

	for roleIndex, role in pairs(createdRoles) do
		local players = role:getPlayers() :: Array<Player>

		for index, player in ipairs(players) do
			role:unassign(player)
		end
		role:destroy()
		table.remove(createdRoles, roleIndex)
		role = nil
	end
end
--[=[
	Returns role associated with name [roleName]
]=]
function RolesManager:getRole(roleName: string)
	for roleIndex, role in ipairs(createdRoles) do
		if role:getName() == roleName then
			return role
		end
	end
end
--[=[
	Returns player role
]=]
function RolesManager:getPlayerRole(player: Player)
	for roleIndex, role in ipairs(createdRoles) do
		if role:isPlayerRole(player) == true then
			return role
		end
	end
end
--[=[
	Returns all created roles by createRoles() method
]=]
function RolesManager:getAllRoles()
	return createdRoles
end

return RolesManager