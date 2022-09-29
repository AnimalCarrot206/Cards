--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local PlayerStatistic = Class:extend()

function PlayerStatistic:new(attributeName: string, startValue: any?)
    self.Changed = GoodSignal.new()
    self.attributeName = attributeName
    self.startValue = startValue
end

function PlayerStatistic:get(player: Player)
    return player:GetAttribute(self.attributeName) or self.startValue
end

function PlayerStatistic:set(player: Player, valueToSet: any)
    local previousValue = self:get(player)
    player:SetAttribute(self.attributeName, valueToSet)
    self.Changed:Fire(previousValue, valueToSet)
end
--Базовые хар-ки это: оз, дальность, вместимость колоды, доп. удаленность,
--также дефолт-варианты этих хар-к(если есть)
local BaseCharacteristics = PlayerStatistic:extend()
function BaseCharacteristics:set(player: Player, valueToSet: number)
    if type(valueToSet) ~= "number" then
        debug.traceback(
            string.format(
                "Trying to change '%s' with non valid type value: %s \n",
                self.attributeName,
                type(valueToSet)
            )
        )
        return
    end
    self.super:set(player, valueToSet)
end
--Изменяемые характеристики поведения - это хар-ки влияющие на разные части игры,
--Были выделены сюда вследствие ошибок архитектуры
--Представляют собой флаги(булевы значения)
local ChangeableBehaviorCharacteristics = PlayerStatistic:extend()
function ChangeableBehaviorCharacteristics:set(player: Player, valueToSet: boolean)
    if type(valueToSet) ~= "boolean" then
        debug.traceback(
            string.format(
                "Trying to change '%s' with non valid type value: %s \n",
                self.attributeName,
                type(valueToSet)
            )
        )
        return
        self.super:set(player, valueToSet)
    end
end

return {
    PlayerStatistic = PlayerStatistic,
    BaseCharacteristics = BaseCharacteristics,
    ChangeableBehaviorCharacteristics = ChangeableBehaviorCharacteristics
}