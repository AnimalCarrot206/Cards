--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)


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
		
		local isLeftSideCycle = true
        if playerBSitPlace % 2 ~= 0 then
            isLeftSideCycle = false
        end

        while true do
            if isLeftSideCycle == true then
                current = sits[current.next]
            elseif isLeftSideCycle == false then
                current = sits[current.previous]
            end
            
			i = i + 1
			
			if current.value == playerBSitPlace then
				return i
			end
        end
    end
end
--[=[
    Gives to all players Rusty Revolver, must be called on game start
]=]
function Armory:prepareGuns()
    local allPlayers = Players:GetPlayers()

    for _, player in ipairs(allPlayers) do
        local newGun = Guns["Rusty revolver"]()
        table.insert(createdGuns, newGun)

        _setPlayerAttributes(player, newGun)
    end
end
--[=[
    Takes away all players guns, must be called on game end
]=]
function Armory:disableGuns()
    for _, gun in ipairs(createdGuns) do
        gun:destroy()
    end
end
--[=[
    Calculates range between two players, by their sit places
]=]
function Armory:calculateRange(playerA: Player, playerB: Player)
    local playerASitPlace = PlayerStats:getPlayerSitPlace(playerA)
    local playerBSitPlace = PlayerStats:getPlayerSitPlace(playerB)
    
    return _calculateRange(playerASitPlace, playerBSitPlace)
end
--[=[
    Gives player gun, if it found, then destroys previous gun, and changes characteristics
]=]
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
--[=[
    Finds and returns player gun
]=]
function Armory:getPlayerGun(player: Player)
    for _, gun in ipairs(createdGuns) do
        if gun:getOwner() == player then
            return gun
        end
    end
end

return Armory