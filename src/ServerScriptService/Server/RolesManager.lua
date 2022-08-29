--!strict
local Players = game.Players

local Class = require(game.ReplicatedStorage.Shared.Class)

local Role = require(game.ServerScriptService.Server.Role)

local RolesManager = Class:extend()

local createdRoles = {}

local DEFFAULT_ROLES = {
	{name = "Sheriff", maxPlayers = 1, assign = function()
		
	end},

	{name = "Bandit", maxPlayers = 1, assign = function()
		
	end},

	{name = "Cowboy", maxPlayers = 2, assign = function()
		
	end},

	{name = "Psycho", maxPlayers = 1, assign = function()
		
	end},

	{name = "PlagueDoctor", maxPlayers = 1, assign = function()
		
	end}
}

function RolesManager:createRoles()
	for index, roleTable: {name: string, maxPlayers: number, assign: () -> ()} in ipairs(DEFFAULT_ROLES) do
		local createdTeam = Role:new(roleTable.name, roleTable.maxPlayers)
		createdTeam.PlayerAdded:Connect(roleTable.assign)
	end
end

function RolesManager:assignPlayers()
	local allPlayers = Players:GetPlayers()
	
	for i, role in ipairs(createdRoles) do
		local randomIndex = math.random(1, #allPlayers)
		role:assign(allPlayers[randomIndex])
		table.remove(allPlayers, 1)
	end
end

function RolesManager:unassignPlayers()
	local allPlayers = Players:GetPlayers()

	for index, player in ipairs(allPlayers) do
		player.Team = nil
		player:LoadCharacter()
	end
end

function RolesManager:getRole(roleName: string)
	for _, role in ipairs(createdRoles) do
		if role:getName() == roleName then
			return role
		end
	end
end

function RolesManager:getPlayerRole(player: Player)
	for _, role in ipairs(createdRoles) do
		if role:isPlayerRole(player) == true then
			return role
		end
	end
end

function RolesManager:getAllRoles()
	return createdRoles
end

return RolesManager