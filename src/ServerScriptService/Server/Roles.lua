--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local Armory = require(game.ServerScriptService.Server.Armory)

local Role = Class:extend()

function Role:new(name: string, maxPlayers: number)
	assert(name)
	assert(maxPlayers)
	self.MAXIMUM_PLAYERS_ROLE = maxPlayers

	self._name = name
	self._players = {}

	self.PlayerAdded = GoodSignal.new()
	self.PlayerRemoved = GoodSignal.new()
end

function Role:destroy()
	self._team:Destroy()
	table.clear(self)
	self = nil
end

function Role:assign(player: Player)
	if self:isPlayerRole(player) == true then
		return
	end

	local maxPlayers = self.MAXIMUM_PLAYERS_ROLE :: number
	if #self._players == maxPlayers then
		return
	end
	
	table.insert(self._players, player)
end

function Role:unassign(player: Player)
	local foundIndex = table.find(self._players, player)
	if not foundIndex then
		return
	end

	table.remove(self._players, foundIndex)
end

function Role:isPlayerRole(player: Player): boolean
	return table.find(self._players, player) ~= nil
end

function Role:getName(): string
	return self._name :: string
end

function Role:getPlayers(): Array<Player>
	return self._players
end

function Role:getMaxPlayersCount(): number
	return self.MAXIMUM_PLAYERS_ROLE
end

function Role:getPlayerCount(): number
	return #self._players
end
--[=[
 
]=]
local Sheriff = Role:extend()
function Sheriff:new()
	local TEAM_NAME = CustomEnum:Find("Roles")["Sheriff"].Name
	local MAX_PLAYERS = 1
	self.super:new(TEAM_NAME, MAX_PLAYERS)
end

function Sheriff:assign(player: Player)
	self.super:assign()
	if self:isPlayerRole(player) == false then
		return
	end

	Armory:giveGun(player, "Winchester")
	PlayerStats:setHealth(player, 8)
end
--
local Bandit = Role:extend()
function Bandit:new()
	local TEAM_NAME = CustomEnum:Find("Roles")["Bandit"].Name
	local MAX_PLAYERS = 2
	self.super:new(TEAM_NAME, MAX_PLAYERS)
end
--
local Cowboy = Role:extend()
function Cowboy:new()
	local TEAM_NAME = CustomEnum:Find("Roles")["Cowboy"].Name
	local MAX_PLAYERS = 3
	self.super:new(TEAM_NAME, MAX_PLAYERS)
end
--
local PlagueDoctor = Role:extend()
function PlagueDoctor:new()
	local TEAM_NAME = CustomEnum:Find("Roles")["Plague doctor"].Name
	local MAX_PLAYERS = 1
	self.super:new(TEAM_NAME, MAX_PLAYERS)
end

function PlagueDoctor:assign(player: Player)
	self.super:assign()
	if self:isPlayerRole(player) == false then
		return
	end
	PlayerStats:setHealth(player, 8)
end
--
local Psycho = Role:extend()
function Psycho:new()
	local TEAM_NAME = CustomEnum:Find("Roles")["Psycho"].Name
	local MAX_PLAYERS = 1
	self.super:new(TEAM_NAME, MAX_PLAYERS)
end

return {
	["Sheriff"] = Sheriff,
	["Bandit"] = Bandit,
	["Cowboy"] = Cowboy,
	["Plague doctor"] = PlagueDoctor,
	["Psycho"] = Psycho
}
