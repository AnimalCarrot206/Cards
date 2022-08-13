---@diagnostic disable: empty-block
--!strict
local Players = game.Players

local class = require(game.ReplicatedStorage.Shared.Class)
local Team = require(game.ServerScriptService.Server.Team)

local TeamsManager = class:extend()

local createdTeams = {}

local DEFFAULT_TEAMS = {
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

function TeamsManager:createTeams()
	for index, teamTable: {name: string, maxPlayers: number, assign: () -> ()} in ipairs(DEFFAULT_TEAMS) do
		local createdTeam = Team:new(teamTable.name, teamTable.maxPlayers)
		createdTeam.PlayerAdded:Connect(teamTable.assign)
	end
end

function TeamsManager:assignPlayers()
	local allPlayers = Players:GetPlayers()
	
	for i, team in ipairs(createdTeams) do
		local randomIndex = math.random(1, #allPlayers)
		team:assign(allPlayers[randomIndex])
		table.remove(allPlayers, 1)
	end
end

function TeamsManager:unassignPlayers()
	local allPlayers = Players:GetPlayers()

	for index, player in ipairs(allPlayers) do
		player.Team = nil
		player:LoadCharacter()
	end
end

function TeamsManager:getTeam(teamName: string)
	for index, team in ipairs(createdTeams) do
		if team:getName() == teamName then
			return team
		end
	end
end

function TeamsManager:getPlayerTeam(player)
	for index, team in ipairs(createdTeams) do
		if team:isPlayerInTeam(player) == true then
			return team
		end
	end
end

function TeamsManager:getAllTeams()
	return createdTeams
end

return TeamsManager
