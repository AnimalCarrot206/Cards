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

function _initStats(statTable: {attribute: string, defaultValue: any})
    for _, value in ipairs(characteristicsNames) do
        local stat = PlayerStatistic.PlayerStatistic(
            value.attributeName, value.defaultValue
        )
        table.insert(PlayerStats, stat)
    end
end
_initStats(characteristicsNames)
_initStats(baseCharacteristicsNames)
_initStats(changeableBehaviorCharacteristicsNames)

return PlayerStats