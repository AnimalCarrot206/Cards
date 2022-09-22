--!stric
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local PlayerStats = Class:extend()

PlayerStats.Events = {}

PlayerStats.Events.DefaultHealthChanged = GoodSignal.new()
PlayerStats.Events.DefaultRangeChanged = GoodSignal.new()
PlayerStats.Events.StartDeckCapacityChanged = GoodSignal.new()

PlayerStats.Events.HealthChanged = GoodSignal.new()
PlayerStats.Events.RangeChanged = GoodSignal.new()
PlayerStats.Events.DeckCapacityChanged = GoodSignal.new()
PlayerStats.Events.SitPlaceChanged = GoodSignal.new()
PlayerStats.Events.AdditionalRemotenessChanged = GoodSignal.new()

local names = {
    DEFAULT_HEALTH_ATTRIBUTE_NAME = "DefaultHealth",
    DEFAULT_RANGE_ATTRIBUTE_NAME = "DeffaultRange",
    START_DECK_CAPACITY_ATTRIBUTE_NAME = "StartDeckCapacity",

    HEALTH_ATTRIBUTE_NAME = "Health",
    RANGE_ATTRIBUTE_NAME = "Range",
    DECK_CAPACITY_ATTRIBUTE_NAME = "DeckCapacity",

    SIT_PLACE_ATTRIBUTE_NAME = "SitPlace",
    ADDITIONAL_REMOTENESS_ATTRIBUTE_NAME = "AdditionalRemoteness",
}
--[=[
    Returns Player's default health
]=]
function PlayerStats:getDefaultHealth(player: Player)
    return player:GetAttribute(names.DEFAULT_HEALTH_ATTRIBUTE_NAME) or 0
end
--[=[
    Sets player default health and fires DeffaultRangeChanged event
]=]
function PlayerStats:setDefaultHealth(player: Player, number: number)
    player:SetAttribute(names.DEFAULT_HEALTH_ATTRIBUTE_NAME, number)
end
--[=[
    Returns Player's default range
]=]
function PlayerStats:getDefaultRange(player: Player)
    return player:GetAttribute(names.DEFAULT_RANGE_ATTRIBUTE_NAME)
end
--[=[
    Sets player default range and fires DeffaultRangeChanged event
]=]
function PlayerStats:setDefaultRange(player: Player, number: number)
    player:SetAttribute(names.DEFAULT_RANGE_ATTRIBUTE_NAME, number)
end
--[=[
    Returns Player's start deck capacity
]=]
function PlayerStats:getStartDeckCapacity(player: Player)
    return player:GetAttribute(names.START_DECK_CAPACITY_ATTRIBUTE_NAME)
end
--[=[
    Sets player's start deck capacity
]=]
function PlayerStats:setStartDeckCapacity(player: Player, number: number)
    player:SetAttribute(names.START_DECK_CAPACITY_ATTRIBUTE_NAME, number)
end
--[=[
    Returns Player's health
]=]
function PlayerStats:getHealth(player: Player)
    return player:GetAttribute(names.HEALTH_ATTRIBUTE_NAME)
end
--[=[
    Sets player health and fires HealthChanged event
]=]
function PlayerStats:setHealth(player: Player, number: number)
    player:SetAttribute(names.HEALTH_ATTRIBUTE_NAME, number)
end
--[=[
    Returns Player's range
]=]
function PlayerStats:getRange(player: Player)
    return player:GetAttribute(names.RANGE_ATTRIBUTE_NAME)
end
--[=[
    Sets player range and adds deffault range, fires RangeChanged event
]=]
function PlayerStats:setRange(player: Player, number: number)
    player:SetAttribute(names.RANGE_ATTRIBUTE_NAME, number + self:getDefaultRange(player))
end

function PlayerStats:getDeckCapacity(player: Player)
    return player:GetAttribute(names.DECK_CAPACITY_ATTRIBUTE_NAME) or 0
end

function PlayerStats:setDeckCapacity(player: Player, number: number)
    player:SetAttribute(names.DECK_CAPACITY_ATTRIBUTE_NAME, number)
end

function PlayerStats:getPlayerSitPlace(player: Player)
    return player:GetAttribute(names.SIT_PLACE_ATTRIBUTE_NAME) :: number
end

function PlayerStats:setPlayerSitPlace(player: Player, number: number)
    assert(number <= 8, "Player sit cannot be greater than 8")
    player:SetAttribute(names.SIT_PLACE_ATTRIBUTE_NAME, number)
end

function PlayerStats:getAdditionalRemoteness(player: Player)
    return player:GetAttribute(names.ADDITIONAL_REMOTENESS_ATTRIBUTE_NAME)
end

function PlayerStats:setAdditionalRemoteness(player: Player, number: number)
    player:SetAttribute(names.ADDITIONAL_REMOTENESS_ATTRIBUTE_NAME, number)
end

do
    local Players = game:GetService("Players")

    for index, player in ipairs(Players:GetPlayers()) do
        player.AttributeChanged:Connect(function(attribute)
            for _, eventName in pairs(names) do
                if eventName ~= attribute then
                    continue
                end
                local event = PlayerStats.Events[eventName.."Changed"]
                if event then
                    event:Fire(player, player:GetAttribute(attribute))
                end
            end
        end)
    end
end

return PlayerStats