--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local Armory = Class:extend()

export type Gun = {
    name: string,
    range: number,
    model: Model,
}

local Guns: {[string]: Gun} = {
    ["Rusty revolver"] = {
        name = "Rusty revolver",
        range = 3,
        model = nil
    },
    ["Shawed off"] = {
        name = "Shawed off",
        range = 2,
        model = nil,
    },
    ["Judi"] = {
        name = "Judi",
        range = 3,
        model = nil
    },
    ["Navy revolver"] = {
        name = "Navy revolver",
        range = 4,
        model = nil
    },
    ["Winchester"] = {
        name = "Winchester",
        range = 7,
        model = nil
    },
}

local createdGuns: {[string]: Gun} = {}

local function _setPlayerAttributes(player: Player, gun: Gun)
    PlayerStats:setRange(player, gun.range)
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
        local newGun = Guns["Rusty revolver"]
        createdGuns[player.Name] = newGun

        _setPlayerAttributes(player, newGun)
    end
end
--[=[
    Takes away all players guns, must be called on game end
]=]
function Armory:disableGuns()
    table.clear(Guns)
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

    for playerName, gun in pairs(createdGuns) do
        if playerName == player.Name then
            createdGuns[playerName] = nil
        end
    end

    local newGun = Guns[gunName]
    createdGuns[player.Name] = newGun
    _setPlayerAttributes(player, newGun)
end
--[=[
    Finds and returns player gun
]=]
function Armory:getPlayerGun(player: Player)
    for playerName, gun in pairs(createdGuns) do
        if playerName == player.Name then
            return gun
        end
    end
end

return Armory