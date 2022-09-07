--!strict
local HttpService = game:GetService("HttpService")

local Class = require(game.ReplicatedStorage.Shared.Class)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

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
function Card:new(cardName: string, idStringStart: string)
    self._name = cardName
    self._id = idStringStart..HttpService:GenerateGUID(false)
end

function Card:destroy()
    table.clear(self)
    self = nil
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
function OnPlayerUseCard:new(cardName: string, isAlternates: boolean, alternate: any?)
    local idStringStart = CustomEnum.CardIdLiteral.OnPlayerUseCard
    self.super:new(cardName, idStringStart)
    self._isAlternates = isAlternates
    
    if isAlternates then
        assert(alternate)
    end

    self._alternate = alternate
end

function OnPlayerUseCard:isAlternates()
    return self._isAlternates
end

function OnPlayerUseCard:getAlternate()
    return self._alternate :: string
end

function OnPlayerUseCard:use(info: OnPlayerUseInfo)
    error("Not implemented method!")
end
--[=[
    Класс карты при использовании которой будет задействован только её владелец
]=]
local SelfUseCard = Card:extend()
function SelfUseCard:new(cardName: string)
    local idStringStart = CustomEnum.CardIdLiteral.SelfUseCard
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
    local idStringStart = CustomEnum.CardIdLiteral.CouplePlayersUseCard
    self.super:new(cardName, idStringStart)
end
function CouplePlayersUseCard:use(info: CouplePlayersUseInfo)
    error("Not implemented method!")
end
--[=[
    
]=]
return {
    OnPlayerUseCard = OnPlayerUseCard,
    SelfUseCard = SelfUseCard,
    WeaponCard = WeaponCard,
    BonusCard = BonusCard,
    AllPlayersUseCard = CouplePlayersUseCard
}