--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local RolesManager = require(game.ServerScriptService.Server.RolesManager)
local Guns = require(game.ServerScriptService.Server.Guns)

local Armory = Class:extend()

local createdGuns = {}

local function _setPlayerAttributes(player: Player, gun)
    PlayerStats:setRange(player, gun:getRange())
end

local _calculateRange do

    local sits: {{next: number,  previous: number, value: number}} = {
        [1] = {next = 2, previous = 3, value = 1},
        [2] = {next = 4, previous = 1, value = 2},
        [3] = {next = 1, previous = 5, value = 3},
        [4] = {next = 6, previous = 2, value = 4},
        [5] = {next = 3, previous = 7, value = 5},
        [6] = {next = 8, previous = 4, value = 6},
        [7] = {next = 5, previous = 8, value = 7},
        [8] = {next = 7, previous = 6, value = 8},
    }
    --[=[
                1
            2       3
        4               5
            6       7
                8
    ]=]
    _calculateRange = function(playerASitPlace: number, playerBSitPlace: number)
        if playerASitPlace + playerBSitPlace == 9  then
            return 4
        end

		local current = sits[playerASitPlace]

		local i = 0
		
		local isDeadendReached = false
        while true do
            if isDeadendReached == true then
                current = sits[current.previous]
            elseif isDeadendReached == false then
                current = sits[current.next]
            end
            
			i += 1
            if playerASitPlace + current.value == 9 then
				i = 0
				isDeadendReached = true
                current = sits[playerASitPlace]		
			end
			
			if current.value == playerBSitPlace then
				return i
			end
        end
    end
end

function Armory:prepareGuns()
    local allPlayers = Players:GetPlayers()

    for _, player in ipairs(allPlayers) do
        local newGun = Guns["Rusty revolver"]()
        table.insert(createdGuns, newGun)

        _setPlayerAttributes(player, newGun)
    end
end

function Armory:disableGuns()
    for _, gun in ipairs(createdGuns) do
        gun:destroy()
    end
end

function Armory:calculateRange(playerA: Player, playerB: Player)
    local playerASitPlace = PlayerStats:getPlayerSitPlace(playerA)
    local playerBSitPlace = PlayerStats:getPlayerSitPlace(playerB)
    
    
end

function Armory:test(num1, num2)
    return _calculateRange(num1, num2)
end

function Armory:giveGun(player: Player, gunName: string)
    local foundGun = Guns[gunName]

    for index, gun in ipairs(createdGuns) do
        if gun:getOwner() == player then
            gun:destroy()
            table.remove(createdGuns, index)
        end
    end

    local newGun = foundGun(player)
    table.insert(createdGuns, newGun)
    _setPlayerAttributes(player, newGun)
end

function Armory:getPlayerGun(player: Player)
    for _, gun in ipairs(createdGuns) do
        if gun:getOwner() == player then
            return gun
        end
    end
end

return Armory