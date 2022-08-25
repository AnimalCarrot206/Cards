--!strict

local Class = require(game.ReplicatedStorage.Shared.Class)
local CustonEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local ModuleContainer = require(game.ReplicatedStorage.Shared.ModuleContainer)

local Armory = require(game.ServerScriptService.Server.Armory)

local cardsEnum = CustonEnum.new("Cards", {})
local cardTypeEnum = CustonEnum.new("CardType", {})


local Card = Class:extend()

Card.Container = game.ReplicatedStorage.Models.Cards

function Card:new(cardName, type)
    self.Name = cardName
    self.Type = type
end

function Card:destroy()
    table.clear(self)
    self = nil
end

function Card:getName(): string
    return self.Name :: string
end

function Card:use()
    error("Not implemented method!")
end

--[[
    _____________________________________
]]

local Crack = Card:extend()

function Crack:new()
    self.super:new("Crack")
end

function Crack:use(player: Player, enemy: Player?)
    
end