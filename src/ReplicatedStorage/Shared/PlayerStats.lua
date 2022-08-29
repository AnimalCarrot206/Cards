--!stric
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local PlayerStats = Class:extend()

PlayerStats.HealthChanged = GoodSignal.new()
PlayerStats.RangeChanged = GoodSignal.new()
PlayerStats.DeffaultRangeChanged = GoodSignal.new()

local HEALTH_ATTRIBUTE_NAME = "Health"
local RANGE_ATTRIBUTE_NAME = "Range"
local DEFFAULT_RANGE_ATTRIBUTE_NAME = "Deffault range"
local DECK_CAPACITY_ATTRIBUTE_NAME = "Deck capacity"
local SIT_PLACE_ATTRIBUTE_NAME = "Sit place"
--[=[
    Returns Player's health
]=]
function PlayerStats:getHealth(player: Player)
    return player:GetAttribute(HEALTH_ATTRIBUTE_NAME)
end
--[=[
    Sets player health and fires HealthChanged event
]=]
function PlayerStats:setHealth(player: Player, number: number)
    local previousHealth = self:getHealth(player) or 0
    player:SetAttribute(HEALTH_ATTRIBUTE_NAME, number)

    self.HealthChanged:Fire(previousHealth, self:getHealth())
end
--[=[
    Returns Player's range
]=]
function PlayerStats:getRange(player: Player)
    return player:GetAttribute(RANGE_ATTRIBUTE_NAME)
end
--[=[
    Sets player range and fires RangeChanged event
]=]
function PlayerStats:setRange(player: Player, number: number)
    local previousRange = self:getRange(player) or 0
    player:SetAttribute(RANGE_ATTRIBUTE_NAME, number + self:getDefaultRange(player))

    self.RangeChanged:Fire(previousRange, self:getRange(player))
end
--[=[
    Returns Player's default range
]=]
function PlayerStats:getDefaultRange(player: Player)
    return player:GetAttribute(DEFFAULT_RANGE_ATTRIBUTE_NAME)
end
--[=[
    Sets player default range and fires DeffaultRangeChanged event
]=]
function PlayerStats:setDefaultRange(player: Player, number: number)
    local previousValue = self:getDefaultRange(player)
    player:SetAttribute(DEFFAULT_RANGE_ATTRIBUTE_NAME, number)

    self.DeffaultRangeChanged:Fire(previousValue, self:getDefaultRange(player))
end
--[=[
    Returns Player's start deck capacity
]=]
function PlayerStats:getStartDeckCapacity(player: Player)
    return  player:GetAttribute(DECK_CAPACITY_ATTRIBUTE_NAME)
end
--[=[
    Sets player's start deck capacity
]=]
function PlayerStats:setStartDeckCapacity(player: Player, number: number)
    player:SetAttribute(DECK_CAPACITY_ATTRIBUTE_NAME, number)
end

function PlayerStats:getPlayerSitPlace(player: Player)
    return player:GetAttribute(SIT_PLACE_ATTRIBUTE_NAME) :: number
end

function PlayerStats:setPlayerSitPlace(player: Player, number: number)
    player:SetAttribute(SIT_PLACE_ATTRIBUTE_NAME, number)
end

return PlayerStats