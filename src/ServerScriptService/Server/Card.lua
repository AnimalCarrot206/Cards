--!strict

local Class = require(game.ReplicatedStorage.Shared.Class)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local ModuleContainer = require(game.ReplicatedStorage.Shared.ModuleContainer)

local Armory = require(game.ServerScriptService.Server.Armory)

local cardsEnum = CustomEnum.new("Cards", {
    ["Crack!"] = 0,
    ["Miss"] = 1,
    ["Ambush!"] = 2,
    ["Lemonade"] = 3,
    ["Drinks on me"] = 4,
    ["Present"] = 5,
    ["Cage"] = 6,
    ["Blackmail"] = 7,
    ["Thief"] = 8,
    ["Reverse"] = 9,
    ["Exchange"] = 10,
    ["Duel"] = 11,
    ["Move"] = 12,
    ["Mayor's pardon"] = 13,
})
local cardTypeEnum = CustomEnum.new("CardType", {
    OnePlayerUse = 0,
    TwoPlayerUse = 1
})


local Card = Class:extend()

Card.Container = game.ReplicatedStorage.Models.Cards

function Card:new(cardName, type, overlap: any?)
    self._name = cardName
    self._type = type
    self._overlap = overlap
end

function Card:destroy()
    table.clear(self)
    self = nil
end

function Card:getType()
    return self._type
end

function Card:getName(): string
    return self._name :: string
end

function Card:getOvelrap(): any?
    return self._overlap
end

function Card:use()
    error("Not implemented method!")
end

--[[
    _____________________________________
]]

local Crack = Card:extend()

function Crack:new()
    self.super:new(CustomEnum.Cards["Crack!"].Name, CustomEnum.Cards["Crack!"].Value)
end

function Crack:use(player: Player, enemy: Player?)
    
end