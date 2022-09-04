--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local CardDeckManager = require(game.ServerScriptService.Server.CardDecksManager)
local Armory = require(game.ServerScriptService.Server.Armory)
local CardsAction = require(game.ServerScriptService.Server.CardsAction)
--[[
    _____________________________________
]]
local abilityEnum = CustomEnum:Find("Ability")
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

function ActiveAbility:getName()
    return self._name :: string
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
local Barman = ActiveAbility:extend()
Barman._name = CustomEnum.Ability["Barman"].Name
function Barman:activate()
    
end
--[[
    _____________________________________
]]
local Stained = PassiveAbility:extend()
Stained._name = CustomEnum.Ability["Stained"].Name
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
Compensation._name = CustomEnum.Ability["Compensation"].Name
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
local Sharp = PassiveAbility:extend()
Sharp._name = CustomEnum.Ability["Sharp"].Name
function Sharp:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()

    PlayerStats:setHealth(self._owner, 7)
    PlayerStats:setDefaultRange(self._owner, 2)
    CardsAction.Action:Connect(function(cardAction)
        local disabledCardName = CustomEnum.Cards["Scope"].Name
        local card = cardAction:getExecutableCard()

        if disabledCardName == card:getName() then
            cardAction:cancel()
        end
    end)
end
--[[
    _____________________________________
]]
local Dealer = PassiveAbility:extend()
Dealer._name = CustomEnum.Ability["Dealer"].Name
function Dealer:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()
end
--[[
    _____________________________________
]]
local Capacious = PassiveAbility:extend()
Capacious._name = CustomEnum.Ability["Capacious"].Name
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
Necromancer._name = CustomEnum.Ability["Necromancer"].Name
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
local BountyHunter = PassiveAbility:extend()
BountyHunter._name = CustomEnum.Ability["Bounty hunter"].Name
function BountyHunter:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()
end
--[[
    _____________________________________
]]
local GettingAlong = PassiveAbility:extend()
GettingAlong._name = CustomEnum.Ability["Getting along"].Name
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
local Trickster = PassiveAbility:extend()
Trickster._name = CustomEnum.Ability["Trickster"].Name
function Trickster:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()
end
--[[
    _____________________________________
]]
local BlackMark = PassiveAbility:extend()
BlackMark._name = CustomEnum.Ability["Black mark"].Name
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
local WaitWhat = PassiveAbility:extend()
WaitWhat._name = CustomEnum.Ability["Wait what"].Name
function WaitWhat:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()
end
--[[
    _____________________________________
]]
local Medium = PassiveAbility:extend()
Medium._name = CustomEnum.Ability["Medium"].Name
function Medium:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()
end
--[[
    _____________________________________
]]
local Hermit = PassiveAbility:extend()
Hermit._name = CustomEnum.Ability["Hermit"].Name
function Hermit:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()

    PlayerStats:setHealth(self._owner, 6)
    PlayerStats:setAdditionalRemoteness(self._owner, 2)
end
--[[
    _____________________________________
]]
local DieHard = PassiveAbility:extend()
DieHard._name = CustomEnum.Ability["Die hard"].Name
function DieHard:activate()
    if self:isActivated() then
        return
    end
    self.super:actvate()

    PlayerStats:setHealth(self._owner, 6)
end
--[[
    _____________________________________
]]
return {
    ["Stained"] = Stained,
    ["Compensation"] = Compensation,
    ["Sharp"] = Sharp,
    ["Dealer"] = Dealer,
    ["Capacious"] = Capacious,
    ["Necromancer"] = Necromancer,
    ["Bounty hunter"] = BountyHunter,
    ["Barman"] = Barman,
    ["Getting along"] = GettingAlong,
    ["Trickster"] = Trickster,
    ["Black mark"] = BlackMark,
    ["Wait what"] = WaitWhat,
    ["Medium"] = Medium,
    ["Hermit"] = Hermit,
    ["Die hard"] = DieHard,
}