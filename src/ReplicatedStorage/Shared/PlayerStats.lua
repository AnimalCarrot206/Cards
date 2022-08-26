--!stric
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local PlayerStats = Class:extend()

PlayerStats.HealthChanged = GoodSignal.new()
PlayerStats.RangeChanged = GoodSignal.new()
PlayerStats.DeffaultRangeChanged = GoodSignal.new()

--PlayerStats._health
--PlayerStats._range
--PlayerStats._deffaultRange

local HEALTH_ATTRIBUTE_NAME = "Health"
local RANGE_ATTRIBUTE_NAME = "Range"
local DEFFAULT_RANGE_ATTRIBUTE_NAME = "Deffault range"

function PlayerStats:getHealth(player: Player)
    return player:GetAttribute(HEALTH_ATTRIBUTE_NAME)
end

function PlayerStats:setHealth(player: Player, number: number)
    local previousHealth = self:getHealth(player) or 0
    player:SetAttribute(HEALTH_ATTRIBUTE_NAME, number)

    self.HealthChanged:Fire(previousHealth, self:getHealth())
end

function PlayerStats:getRange(player: Player)
    return player:GetAttribute(RANGE_ATTRIBUTE_NAME)
end

--[=[
    Changes Range adding DeffaultRange
]=]

function PlayerStats:setRange(player: Player, number: number)
    local previousRange = self:getRange(player) or 0
    player:SetAttribute(RANGE_ATTRIBUTE_NAME, number + self:getDeffaultRange(player))

    self.RangeChanged:Fire(previousRange, self:getRange(player))
end

function PlayerStats:getDeffaultRange(player: Player)
    return player:GetAttribute(DEFFAULT_RANGE_ATTRIBUTE_NAME)
end

function PlayerStats:setDeffaultRange(player: Player, number: number)
    local previousValue = self:getDeffaultRange(player)
    player:SetAttribute(DEFFAULT_RANGE_ATTRIBUTE_NAME, number)

    self.DeffaultRangeChanged:Fire(previousValue, self:getDeffaultRange(player))
end

return PlayerStats