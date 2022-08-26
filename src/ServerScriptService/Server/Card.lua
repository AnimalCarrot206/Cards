--!strict

local Class = require(game.ReplicatedStorage.Shared.Class)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local ModuleContainer = require(game.ReplicatedStorage.Shared.ModuleContainer)
local Animations = require(game.ReplicatedStorage.Shared.Animations)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

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

    ["Shawed off"] = 14,
    ["Judi"] = 15,
    ["Navy revolver"] = 16,
    ["Winchester"] = 17
})

local cardTypeEnum = CustomEnum.new("CardUseType", {
    OnePlayerUse = 0,
    TwoPlayerUse = 1,
})

local cardSuitEnum = CustomEnum.new("CardSuit", {
    Common = 0,
    Bonus = 1,
    Weapon = 2
})

local Card = Class:extend()

local function _getPlayerGun(player: Player)
    return Armory:getPlayerGun(player)
end

function Card:new(cardName, cardSuit, useType, overlap: any?)
    self._name = cardName
    self._suit = cardSuit
    self._useType = useType
    self._overlap = overlap
end

function Card:destroy()
    table.clear(self)
    self = nil
end

function Card:getSuit()
    return self._suit
end

function Card:getUseType()
    return self._useType
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
    local name = CustomEnum.Cards["Crack!"].Name
    local suit = CustomEnum.CardSuit.Common
    local useType = CustomEnum.CardUseType.TwoPlayerUse
    local overlap = CustomEnum.Cards["Miss"]

    self.super:new(name, suit, useType, overlap)
end

function Crack:use(player: Player, enemy: Player)
    local gun = _getPlayerGun(player)
    gun:shoot(enemy, CustomEnum.ShootType.Hit)
end
--[[
    _____________________________________
]]
local Miss = Card:extend()

function Miss:new()
    local name = CustomEnum.Cards["Miss"].Name
    local suit = CustomEnum.CardSuit.Common
    local useType = CustomEnum.CardUseType.TwoPlayerUse
    local overlap = nil

    self.super:new(name, suit, useType, overlap)
end

function Miss:use(player: Player, enemy: Player)
    local gun = _getPlayerGun(player)
    gun:shoot(enemy, CustomEnum.ShootType.Miss)
end
--[[
    _____________________________________
]]
local Ambush = Card:extend()

function Ambush:new()
    local name = CustomEnum.Cards["Ambush!"].Name
    local suit = CustomEnum.CardSuit.Common
    local useType = CustomEnum.CardUseType.TwoPlayerUse
    local overlap = CustomEnum.Cards["Miss"].Name

    self.super:new(name, suit, useType, overlap)
end

function Ambush:use(player: Player, enemy: Player)
    local gun = _getPlayerGun(player)
    gun:ambush(enemy)
end
--[[
    _____________________________________
]]
local Lemonade = Card:extend()

function Lemonade:new()
    local name = CustomEnum.Cards["Lemonade"].Name
    local suit = CustomEnum.CardSuit.Common
    local useType = CustomEnum.CardUseType.OnePlayerUse
    local overlap = nil

    self.super:new(name, suit, useType, overlap)
end

function Lemonade:use(player: Player)
    local lemonadeAnimation = Animations.PLAYER_USE_LEMONADE
    local animationTrack = Animations:animatePlayer(player, lemonadeAnimation)
    
    animationTrack.Stopped:Once(function()
        local previousHealth = player:GetAttribute("Health")
        player:SetAttribute("Health", previousHealth + 1)
    end)

end
--[[
    _____________________________________
]]
local DrinksOnMe =  Card:extend()
--[[
    _____________________________________
]]
local Present = Card:extend()
--[[
    _____________________________________
]]
local Cage = Card:extend()
--[[
    _____________________________________
]]
local Blackmail = Card:extend()
--[[
    _____________________________________
]]
local Thief = Card:extend()
--[[
    _____________________________________
]]
local Reverse = Card:extend()
--[[
    _____________________________________
]]
local Exchange = Card:extend()
--[[
    _____________________________________
]]
local Duel = Card:extend()
--[[
    _____________________________________
]]
local Move = Card:extend()
--[[
    _____________________________________
]]
local MayorsPardon = Card:extend()
--[[
    _____________________________________
]]
--[[
    _____________________________________
]]
local GunCard = Card:extend()

function GunCard:new(gunName)
    local name = gunName
    local suit = CustomEnum.CardSuit.Weapon
    local useType = CustomEnum.CardUseType.OnePlayerUse
    local overlap = nil

    self.super:new(name, suit, useType, overlap)
end

function GunCard:use(player: Player)
    Armory:giveGun(player, self._name)
end
--[[
    _____________________________________
]]
local ShawedOff = GunCard:extend()
function ShawedOff:new()
    self.super:new(cardsEnum["Shawed off"].Name)
end
--[[
    _____________________________________
]]
local Judi = GunCard:extend()
function Judi:new()
    self.super:new(cardsEnum["Judi"].Name)
end
--[[
    _____________________________________
]]
local NavyRevolver = GunCard:extend()
function NavyRevolver:new()
    self.super:new(cardsEnum["Navy revolver"].Name)
end
--[[
    _____________________________________
]]
local Winchester = GunCard:extend()
function Winchester:new()
    self.super:new(cardsEnum["Winchester"].Name)
end
--[[
    _____________________________________
]]