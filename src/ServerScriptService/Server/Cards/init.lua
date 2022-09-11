--!strict
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local Animations = require(game.ReplicatedStorage.Shared.Animations)

local BaseClasses = require(game.ServerScriptService.Server.Cards.BaseClasses)
local Sandbox = BaseClasses.Sandbox
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
    On player use cards
]=]
--[[
    Класс карты Bang!!
]]
local Bang = BaseClasses.OnPlayerUseCard:extend()
function Bang:new()
    local CARD_NAME = CustomEnum.GameCard["Bang!!"].Name
    local alternate = CustomEnum.GameCard["Miss"].Name

    self.super:new(CARD_NAME, alternate)
end
function Bang:use(cardUseInfo: OnPlayerUseInfo)
    local attackerAnim = Animations.ATTACKER_SHOOT_ANIMATION_HIT
    local defenderAnim = Animations.DEFENDER_SHOOT_ANIMATION_HIT
    local attackerAnimTrack = Animations:animatePlayer(cardUseInfo.cardOwner, attackerAnim)
    local defenderAnimTrack = Animations:animatePlayer(cardUseInfo.defender, defenderAnim)

    attackerAnimTrack.Stopped:Connect(function()
        attackerAnimTrack:Destroy()
        defenderAnimTrack:Destroy()

        local defenderHealth = Sandbox.PlayerStats:getHealth(cardUseInfo.defender)
        Sandbox.PlayerStats:setHealth(cardUseInfo.defender, defenderHealth - 1)
    end)
    defenderAnimTrack:Play()
    attackerAnimTrack:Play()
end
--[[
    Класс карты Miss
]]
local Miss = BaseClasses.OnPlayerUseCard:extend()
function Miss:new()
    local CARD_NAME = CustomEnum.GameCard["Miss"].Name
    local alternate = nil
    self.super:new(CARD_NAME, alternate)
end
function Miss:use(cardUseInfo: OnPlayerUseInfo)
    local attacker = cardUseInfo.defender
    local defender = cardUseInfo.cardOwner

    local attackerAnim = Animations.ATTACKER_SHOOT_ANIMATION_HIT
    local defenderAnim = Animations.DEFENDER_SHOOT_ANIMATION_HIT
    local attackerAnimTrack = Animations:animatePlayer(attacker, attackerAnim)
    local defenderAnimTrack = Animations:animatePlayer(defender, defenderAnim)

    attackerAnimTrack.Stopped:Connect(function()
        defenderAnimTrack:Destroy()
        attackerAnimTrack:Destroy()
    end)
    defenderAnimTrack:Play()
    attackerAnimTrack:Play()
end
--[[
    Класс карты Cage
]]
local Cage = BaseClasses.OnPlayerUseCard:extend()
Cage.Alternate = CustomEnum.GameCard["Mayor's pardon"].Name
function Cage:new()
    local CARD_NAME = CustomEnum.GameCard["Cage"].Name
    self.super:new(CARD_NAME)
end
function Cage:use(cardUseInfo: OnPlayerUseInfo)
    
end
--[[
    Класс карты Blackmail
]]
local Blackmail = BaseClasses.OnPlayerUseCard:extend()
Blackmail.Alternate = nil
function Blackmail:new()
    local CARD_NAME = CustomEnum.GameCard["Blackmail"].Name
    self.super:new(CARD_NAME)
end
function Blackmail:use(cardUseInfo: OnPlayerUseInfo)
    
end
--[[
    Класс карты Thief
]]
local Thief = BaseClasses.OnPlayerUseCard:extend()
Thief.Alternate = nil
function Thief:new()
    local CARD_NAME = CustomEnum.GameCard["Thief"].Name
    self.super:new(CARD_NAME)
end
function Thief:use(cardUseInfo: OnPlayerUseInfo)
    
end
--[[
    Класс карты Duel
]]
local Duel = BaseClasses.OnPlayerUseCard:extend()
Duel.Alternate = nil
function Duel:new()
    local CARD_NAME = CustomEnum.GameCard["Duel"].Name
    self.super:new(CARD_NAME)
end
function Duel:use()
    
end
--[[
    Класс карты Move
]]
local Move = BaseClasses.OnPlayerUseCard:extend()
Move.Alternate = nil
function Move:new()
    local CARD_NAME = CustomEnum.GameCard["Move"].Name
    self.super:new(CARD_NAME)
end
function Move:use(cardUseInfo: OnPlayerUseInfo)
    local attackerSitPlace = Sandbox.PlayerStats:getPlayerSitPlace(cardUseInfo.cardOwner)
    local defenderSitPlace = Sandbox.PlayerStats:getPlayerSitPlace(cardUseInfo.defender)

    Sandbox.PlayerStats:setPlayerSitPlace(cardUseInfo.cardOwner, defenderSitPlace)
    Sandbox.PlayerStats:setPlayerSitPlace(cardUseInfo.defender, attackerSitPlace)
end
--[=[
    MIXINS
]=]
--[[
    Класс карты Mayor's pardon
]]
local MayorsPardon = BaseClasses.OnPlayerUseCard:extend()
function MayorsPardon:new()
    local CARD_NAME = CustomEnum.GameCard["Mayor's pardon"].Name
    self.super:new(CARD_NAME)
end
function MayorsPardon:use()
    
end
--[=[
    Self use cards
]=]
--[[
    Класс карты Lemonade
]]
local Lemonade = BaseClasses.SelfUseCard:extend()
function Lemonade:new()
    local CARD_NAME = CustomEnum.GameCard["Lemonade"].Name
    self.super:new(CARD_NAME)
end
function Lemonade:use(cardUseInfo: SelfUseInfo)
    local animationTrack = Animations:animatePlayer(cardUseInfo.cardOwner)

    animationTrack.Stopped:Connect(function()
        animationTrack:Destroy()
        local previousHealth = Sandbox.PlayerStats:getHealth(cardUseInfo.cardOwner)
        Sandbox.PlayerStats:setHealth(cardUseInfo.cardOwner, previousHealth + 1)
    end)

    animationTrack:Play()
end
--[[
    Класс карты Present
]]
local Present = BaseClasses.SelfUseCard:extend()
function Present:new()
    local CARD_NAME = CustomEnum.GameCard["Present"].Name
    self.super:new(CARD_NAME)
end
function Present:use()
    
end
--[[
    Класс карты Exchange
]]
local Exchange = BaseClasses.SelfUseCard:extend()
function Exchange:new()
    local CARD_NAME = CustomEnum.GameCard["Exchange"].Name
    self.super:new(CARD_NAME)
end
function Exchange:use()
    
end
--[=[
    Weapon cards
]=]
--[[
    Класс карты Shawed off
]]
local ShawedOff = BaseClasses.WeaponCard:extend()
function ShawedOff:new()
    local CARD_NAME = CustomEnum.WeaponCard["Shawed off"].Name
    local GUN_NAME = CustomEnum.Guns[CARD_NAME].Name
    self.super:new(CARD_NAME, GUN_NAME)
end
--[[
    Класс карты Judi
]]
local Judi = BaseClasses.WeaponCard:extend()
function Judi:new()
    local CARD_NAME = CustomEnum.WeaponCard["Judi"].Name
    local GUN_NAME = CustomEnum.Guns[CARD_NAME].Name
    self.super:new(CARD_NAME, GUN_NAME)
end
--[[
    Класс карты Navy revolver
]]
local NavyRevolver = BaseClasses.WeaponCard:extend()
function NavyRevolver:new()
    local CARD_NAME = CustomEnum.WeaponCard["Navy revolver"].Name
    local GUN_NAME = CustomEnum.Guns[CARD_NAME].Name
    self.super:new(CARD_NAME, GUN_NAME)
end
--[[
    Класс карты Winchester
]]
local Winchester = BaseClasses.WeaponCard:extend()
function Winchester:new()
    local CARD_NAME = CustomEnum.WeaponCard["Winchester"].Name
    local GUN_NAME = CustomEnum.Guns[CARD_NAME].Name
    self.super:new(CARD_NAME, GUN_NAME)
end
--[=[
    Bonus cards
]=]
--[[
    Класс карты Apple juice
]]
local AppleJuice = BaseClasses.BonusCard:extend()
function AppleJuice:new()
    local CARD_NAME = CustomEnum.BonusCard["Apple juice"].Name
    self.super:new(CARD_NAME)
end
function AppleJuice:use()
    
end
--[[
    Класс карты Scope
]]
local Scope = BaseClasses.BonusCard:extend()
function Scope:new()
    local CARD_NAME = CustomEnum.BonusCard["Scope"].Name
    self.super:new(CARD_NAME)
end
function Scope:use()
    
end
--[[
    Класс карты Brand stool
]]
local BrandStool = BaseClasses.BonusCard:extend()
function BrandStool:new()
    local CARD_NAME = CustomEnum.BonusCard["Brand stool"].Name
    self.super:new(CARD_NAME)
end
function BrandStool:use()
    
end
--[=[
    Couple players use card
]=]
--[[
    Класс карты Ambush
]]
local Ambush = BaseClasses.CouplePlayersUseCard:extend()
function Ambush:new()
    local CARD_NAME = CustomEnum.GameCard["Ambush!"].Name
    self.super:new(CARD_NAME)
end
function Ambush:use()
    
end
--[[
    Класс карты Reverse
]]
local Reverse = BaseClasses.CouplePlayersUseCard:extend()
function Reverse:new()
    local CARD_NAME = CustomEnum.GameCard["Reverse"].Name
    self.super:new(CARD_NAME)
end
function Reverse:use()
    
end
--[[
    Класс карты Drinks on me
]]
local DrinksOnMe = BaseClasses.CouplePlayersUseCard:extend()
function DrinksOnMe:new()
    local CARD_NAME = CustomEnum.GameCard["Drinks on me"].Name
    self.super:new(CARD_NAME)
end
function DrinksOnMe:use()
    
end

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

    ["Scope"] = Scope,
    ["Brand stool"] = BrandStool,
    ["Apple juice"] = AppleJuice,
}