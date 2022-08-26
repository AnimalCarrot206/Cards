--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local ModuleContainer = require(game.ReplicatedStorage.Shared.ModuleContainer)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local RolesManager = require(game.ServerScriptService.Server.RolesManager)
local Guns = require(game.ServerScriptService.Server.Guns)

local Armory = Class:extend()

local createdGuns = {}

local function _setPlayerAttributes(player: Player, gun)
    PlayerStats:setRange(player, gun:getRange())
end

function Armory:prepareGuns()
    local allPlayers = Players:GetPlayers()

    for _, player in ipairs(allPlayers) do
        local newGun = Guns.rustyRevolver(player)
        table.insert(createdGuns, newGun)

        _setPlayerAttributes(player, newGun)
    end
end

function Armory:disableGuns()
    for _, gun in ipairs(createdGuns) do
        gun:destroy()
    end
end

function Armory:calculateRange(numA, numB, player: Player, enemy: Player)
    local playerSitPlace = numA or player:GetAttribute("SitPlace") :: number
    local enemySitPlace = numB or enemy:GetAttribute("SitPlace") :: number

    local range

    if range < 0 then
        range = -range
    end
    return range
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