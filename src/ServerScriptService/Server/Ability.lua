--!strict

local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local CardDeckManager = require(game.ServerScriptService.Server.CardDecksManager)
local Armory = require(game.ServerScriptService.Server.Armory)

--[[
    _____________________________________
]]
local ActiveAbility = Class:extend()
function ActiveAbility:new(player: Player)
    self._owner = player
end

function ActiveAbility:actvate()
    error("Not implemented method!")
end
--[[
    _____________________________________
]]
local PassiveAbility = ActiveAbility:extend()

function PassiveAbility:activate()
    self._activated = true
end

function PassiveAbility:isActivated()
    return self._activated :: boolean
end
--[[
    _____________________________________
]]

--[[
    _____________________________________
]]
local Stained = PassiveAbility:extend()
function Stained:activate()
    if self:isActivated() then
        return
    end
    self.super:activate()

    PlayerStats:setHealth(self._owner, 8)
end
--[[
    _____________________________________
]]
local Compensation = PassiveAbility:extend()
function Compensation:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()

    PlayerStats:setHealth(self._owner, 6)
    PlayerStats.HealthChanged:Connect(function(previous, current)
        if previous > current then
            CardDeckManager:giveRandomCard(self._owner)
        end
    end)
end
--[[
    _____________________________________
]]
local Capacious = PassiveAbility:extend()
function Capacious:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()

    PlayerStats:setHealth(self._owner, 5)
    PlayerStats:setDeckCapacity(self._owner, 10)
end
--[[
    _____________________________________
]]
local Necromancer = PassiveAbility:extend()
function Necromancer:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()

    PlayerStats:setHealth(self._owner, 5)
    PlayerStats.HealthChanged:Connect(function(previous, current)
        if current == 0 then
            PlayerStats:setHealth(self._owner, 1)
        end
    end)
end
--[[
    _____________________________________
]]
local GettingAlong = PassiveAbility:extend()
function GettingAlong:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()

    PlayerStats:setHealth(self._owner, 7)
    Armory:giveGun(self._owner, "Shawed off")
end
--[[
    _____________________________________
]]
local BlackMark = PassiveAbility:extend()
function BlackMark:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()

    PlayerStats:setHealth(self._owner, 7)
    Armory:giveGun(self._owner, "Navy revolver")
end
--[[
    _____________________________________
]]