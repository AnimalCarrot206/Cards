--!strict
local HttpService = game:GetService("HttpService")

local Class = require(game.ReplicatedStorage.Shared.Class)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local TurnManager = require(game.ServerScriptService.Server.TurnManager)
local Armory = require(game.ServerScriptService.Server.Armory)
--[=[
    Типы аргументов Info для классов карт
]=]
export type CardUseBaseInfo = {
    cardOwner: Player,
    cardOwnerDeck: any,
}
export type SelfUseInfo = CardUseBaseInfo
export type OnPlayerUseInfo = CardUseBaseInfo & {
    defender: Player,
    defenderDeck: any,
}
export type CouplePlayersUseInfo = CardUseBaseInfo & {
    players: {Player}
}
--[=[
    Базовый класс карт
]=]
local Card = Class:extend()
Card.Armory = Armory
Card.TurnManager = TurnManager
Card.PlayerStats = PlayerStats
function Card:new(cardName: string, idStringStart: string)
    self._name = cardName
    self._id = tostring(idStringStart)..HttpService:GenerateGUID(false)
end
function Card:destroy()
    table.clear(self)
    self = nil
end
function Card:getName()
    return self._name
end
function Card:getId()
    return self._id
end
function Card:getUseType()
    local idLiteral = string.sub(self._id, 1, 2)
    for index, enum in ipairs(CustomEnum.CardIdLiteral:GetEnumItems()) do
        if enum.Value == idLiteral then
            return enum.Name
        end
    end
end
--[=[
    Метод использования карты, по умолчанию не реализован
]=]
function Card:use(info: CardUseBaseInfo)
    error("Not implemented method!")
end
--[=[
    Класс карты при использовании которой будут задействованы 
    2 игрока: владелец, и игрок, которого выбрал владелец карты
]=]
local OnPlayerUseCard = Card:extend()
OnPlayerUseCard.Alternate = nil
function OnPlayerUseCard:new(cardName: string)
    local idStringStart = CustomEnum.CardIdLiteral.OnPlayerUseCard.Value
    self.super:new(cardName, idStringStart)
end

function OnPlayerUseCard:getAlternate()
    return self.Alternate :: string
end

function OnPlayerUseCard:use(info: OnPlayerUseInfo)
    error("Not implemented method!")
end
--[=[
    Класс карты при использовании которой будет задействован только её владелец
]=]
local SelfUseCard = Card:extend()
function SelfUseCard:new(cardName: string)
    local idStringStart = CustomEnum.CardIdLiteral.SelfUseCard.Value
    self.super:new(cardName, idStringStart)
end
function SelfUseCard:use(info: SelfUseInfo)
    error("Not implemented method!")
end
--[=[___________]=]--
--[[
    Класс карты при использовании которой игроку будет выдаваться оружие
]]
local WeaponCard = SelfUseCard:extend()
function WeaponCard:new(cardName: string, gunName: string)
    self.super:new(cardName)
    self._gunName = gunName
end
function WeaponCard:use(info: SelfUseInfo)
    Armory:giveGun(info.cardOwner, self._gunName)
end
--[[
    Спорный класс карт, карты этого класса должны хранится в бонусной колоде
]]
local BonusCard = SelfUseCard:extend()
--[=[___________]=]--
--[=[
    Класс карты при использовании которой будут задействованы несколько игроков
]=]
local CouplePlayersUseCard = Card:extend()
function CouplePlayersUseCard:new(cardName: string)
    local idStringStart = CustomEnum.CardIdLiteral.CouplePlayersUseCard.Value
    self.super:new(cardName, idStringStart)
end
function CouplePlayersUseCard:use(info: CouplePlayersUseInfo)
    error("Not implemented method!")
end
--[=[
    
]=]
return {
    Sandbox = Card,
    OnPlayerUseCard = OnPlayerUseCard,
    SelfUseCard = SelfUseCard,
    WeaponCard = WeaponCard,
    BonusCard = BonusCard,
    CouplePlayersUseCard = CouplePlayersUseCard
}