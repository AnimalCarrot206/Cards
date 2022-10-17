--!strict
local PlayerStatistic = require(game.ReplicatedStorage.Shared.PlayerStats.PlayerStatistic)
local PlayerStats = {}

local characteristicsNames = {
    {attributeName = "sitPlace", defaultValue = -1},
}

local baseCharacteristicsNames = {
    {attributeName = "defaultHealth", defaultValue = 6},
    {attributeName = "deffaultRange", defaultValue = 0},
    {attributeName = "health", defaultValue = 0},
    {attributeName = "range", defaultValue = 0},
    {attributeName = "deckCapacity", defaultValue = 0},
    {attributeName = "startDeckCapacity", defaultValue = 6},
    {attributeName = "additionalRemoteness", defaultValue = 0},
}

local changeableBehaviorCharacteristicsNames = {
    {attributeName = "isCanUseDobuleShoot", defaultValue = false},
    {attributeName = "isTurnDisabled", defaultValue = false},
}

function _initCommonStats()
    for _, value in ipairs(characteristicsNames) do
        local stat = PlayerStatistic.PlayerStatistic(
            value.attributeName, value.defaultValue
        )
        PlayerStats[value.attributeName] = stat
    end
end
function _initBaseStats()
    for _, value in ipairs(baseCharacteristicsNames) do
        local stat = PlayerStatistic.BaseCharacteristics(
            value.attributeName, value.defaultValue
        )
        PlayerStats[value.attributeName] = stat
    end
end
function _initChangableBehaviorStats()
    for _, value in ipairs(changeableBehaviorCharacteristicsNames) do
        local stat = PlayerStatistic.ChangeableBehaviorCharacteristics(
            value.attributeName, value.defaultValue
        )
        PlayerStats[value.attributeName] = stat
    end
end
_initCommonStats()
_initBaseStats()
_initChangableBehaviorStats()

return PlayerStats