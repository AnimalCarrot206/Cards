--!strict
local HttpService = game:GetService("HttpService")

local Class = require(game.ReplicatedStorage.Shared.Class)

local Armory = require(game.ServerScriptService.Server.Armory)
local Chairs = require(game.ServerScriptService.Server.Chairs)
local CardDeckManager = require(game.ServerScriptService.Server.CardDecksManager)
--[[
    ______CARDS_BASE_CLASS______
]]
local Card = Class:extend()
Card.Armory = Armory
Card.Chairs = Chairs
Card.CardDeckManager = CardDeckManager
--[=[
    Базовый класс карт
]=]
function Card:new(cardName: string)
    self._name = cardName
    self._id = HttpService:GenerateGUID(false)
end

function Card:destroy()
    table.clear(self)
    self = nil
end
--[=[
    Метод использования карты, по умолчанию не реализован
]=]
function Card:use()
    error("Not implemented method!")
end
--[=[
    Класс карты при использовании которой будут задействованы 
    2 игрока: владелец, и игрок, которого выбрал владелец карты
]=]
local OnPlayerUseCard = Card:extend()
function OnPlayerUseCard:new(cardName: string, isAlternates: boolean, alternate: any?)
    self.super:new(cardName)
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

function OnPlayerUseCard:use(attacker: Player, defender: Player)
    error("Not implemented method!")
end
--[=[
    Класс карты при использовании которой будет задействован только её владелец
]=]
local SelfUseCard = Card:extend()
function SelfUseCard:use(player: Player)
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
    Класс карты при использовании которой будут задействованы все игроки
]=]
local AllPlayersUseCard = Card:extend()
function AllPlayersUseCard:use(player: Player)
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
    AllPlayersUseCard = AllPlayersUseCard
}