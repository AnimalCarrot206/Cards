--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)

local gunsContainer = game.ReplicatedStorage.Guns

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
        model = gunsContainer["Rusty revolver"]
    },
    ["Shawed off"] = {
        name = "Shawed off",
        range = 2,
        model = gunsContainer["Sawed off"],
    },
    ["Judi"] = {
        name = "Judi",
        range = 3,
        model = gunsContainer.Judi,
    },
    ["Navy revolver"] = {
        name = "Navy revolver",
        range = 4,
        model = gunsContainer["Navy revolver"],
    },
    ["Winchester"] = {
        name = "Winchester",
        range = 7,
        model = gunsContainer.Winchester,
    },
}

local createdGuns: {[string]: Gun} = {}

local function _setPlayerAttributes(player: Player, gun: Gun)
    PlayerStats:setRange(player, gun.range)
end

local _calculateRange = require(game.ReplicatedStorage.Shared.CalculateRange)
--[=[
    Gives to all players Rusty Revolver, must be called on game start
]=]
function Armory:prepareGuns()
    local allPlayers = Players:GetPlayers()

    for _, player in ipairs(allPlayers) do
        local newGun = Guns["Rusty revolver"]
        createdGuns[player.Name] = newGun

        _setPlayerAttributes(player, newGun)
        Remotes.UI.UpdateWeaponIcon:FireClient(player, newGun)
    end
end
--[=[
    Takes away all players guns, must be called on game end
]=]
function Armory:disableGuns()
    table.clear(createdGuns)
end
--[=[
    Calculates range between two players, by their sit places
]=]
function Armory:calculateRange(playerA: Player, playerB: Player)
    local playerASitPlace = PlayerStats:getPlayerSitPlace(playerA)
    local playerBSitPlace = PlayerStats:getPlayerSitPlace(playerB)
    
    return _calculateRange(playerASitPlace, playerBSitPlace) + PlayerStats:getAdditionalRemoteness(playerB)
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
    Remotes.UI.UpdateWeaponIcon:FireClient(player, newGun)
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