--!strict
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local Animations = require(game.ReplicatedStorage.Shared.Animations)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local Armory = require(game.ServerScriptService.Server.Armory)
local CardDecksManager = require(game.ServerScriptService.Server.CardDecksManager)
local AbilityManager = require(game)
--local TurnsManager = require(game.ServerScriptService.Server.TurnsManager)

local cardsEnum = CustomEnum:Find("Cards")

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

function Card:new()
    self._id = HttpService:GenerateGUID(false)
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

function Card:getId()
    return self._id
end

function Card:use()
    error("Not implemented method!")
end

--[[
    _____________________________________
]]
local Bang = Card:extend()
Bang._name = CustomEnum.Cards["Bang!!"].Name
Bang._suit = CustomEnum.CardSuit.Common
Bang._useType = CustomEnum.CardUseType.TwoPlayerUse
Bang._overlap = CustomEnum.Cards["Miss"].Name

function Bang:use(player: Player, enemy: Player)
    local gun = _getPlayerGun(player)
    gun:shoot(enemy, CustomEnum.ShootType.Hit)
end
--[[
    _____________________________________
]]
local Miss = Card:extend()
Miss._name = CustomEnum.Cards["Miss"].Name
Miss._suit = CustomEnum.CardSuit.Common
Miss._useType = CustomEnum.CardUseType.TwoPlayerUse
Miss._overlap = nil

function Miss:use(player: Player, enemy: Player)
    local gun = _getPlayerGun(player)
    gun:shoot(enemy, CustomEnum.ShootType.Miss)
end
--[[
    _____________________________________
]]
local Ambush = Card:extend()
Ambush._name = CustomEnum.Cards["Ambush!"].Name
Ambush._suit = CustomEnum.CardSuit.Common
Ambush._useType = CustomEnum.CardUseType.TwoPlayerUse
Ambush._overlap = CustomEnum.Cards["Miss"].Name

function Ambush:use(player: Player, enemy: Player)
    local gun = _getPlayerGun(player)
    gun:ambush(enemy)
end
--[[
    _____________________________________
]]
local Lemonade = Card:extend()
Lemonade._name = CustomEnum.Cards["Lemonade"].Name
Lemonade._suit = CustomEnum.CardSuit.Common
Lemonade._useType = CustomEnum.CardUseType.OnePlayerUse
Lemonade._overlap = nil

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
DrinksOnMe._name = CustomEnum.Cards["Drinks on me"].Name
DrinksOnMe._suit = CustomEnum.CardSuit.Common
DrinksOnMe._useType = CustomEnum.CardUseType.OnePlayerUse
DrinksOnMe._overlap = nil

function DrinksOnMe:use(player: Player)
    local allPlayers = Players:GetPlayers()

    for index, player in ipairs(allPlayers) do
        local commonDeck = CardDecksManager:getPlayerCommonDeck(player)
        local bonusDeck = CardDecksManager:getPlayerBonusDeck(player)

        if not commonDeck or not bonusDeck then continue end

        local cardName = CustomEnum.Cards["Lemonade"].Name

        if commonDeck:getDeckFreeSpace() > 0 then
            commonDeck:addCard(cardName)
        else
            bonusDeck:addCard(cardName)
        end
    end
end
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
Thief._name = CustomEnum.Cards["Thief"].Name
Thief._suit = CustomEnum.CardSuit.Common
Thief._useType = CustomEnum.CardUseType.TwoPlayerUse
Thief._overlap = nil

function Thief:use(player: Player, enemy: Player)
    local playerCommonDeck = CardDecksManager:getPlayerCommonDeck(player)

    local enemyCommonDeck = CardDecksManager:getPlayerCommonDeck(enemy)
    local enemyBonusDeck = CardDecksManager:getPlayerBonusDeck(enemy)

    local randomChoosenCard

    
end
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
return {
    ["Bang!!"] = Bang,
    ["Miss"] = Miss,
    ["Ambush!"] = Ambush,
    ["Lemonade"] = Lemonade,
    ["Drinks on me"] = DrinksOnMe,
    ["Present"] = Present,
    ["Cage"] = Cage,
    ["Blackmail"] = Blackmail,
    ["Thief"] = Thief,
    ["Reverse"] = Reverse,
    ["Exchange"] = Exchange,
    ["Duel"] = Duel,
    ["Move"] = Move,
    ["Mayor's pardon"] = MayorsPardon,

    ["Shawed off"] = ShawedOff,
    ["Judi"] = Judi,
    ["Navy revolver"] = NavyRevolver,
    ["Winchester"] = Winchester,
}
