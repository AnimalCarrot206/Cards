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
    TYPE: GameCards
]=]
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
function Cage:new()
    local CARD_NAME = CustomEnum.GameCard["Cage"].Name
    local alternate = CustomEnum.GameCard["Mayor's pardon"]
    self.super:new(CARD_NAME, alternate)
end
function Cage:use(cardUseInfo: OnPlayerUseInfo)
    
end
--[[
    Класс карты Blackmail
]]
local Blackmail = BaseClasses.OnPlayerUseCard:extend()
function Blackmail:new()
    local CARD_NAME = CustomEnum.GameCard["Blackmail"].Name
    local alternate = nil
    self.super:new(CARD_NAME, alternate)
end
function Blackmail:use(cardUseInfo: OnPlayerUseInfo)
    
end
--[[
    Класс карты Thief
]]
--[[
    Класс карты Duel
]]
--[[
    Класс карты Move
]]
local Move = BaseClasses.OnPlayerUseCard:extend()
function Move:new()
    local CARD_NAME = CustomEnum.Cards["Move"].Name
    local alternate = nil
    self.super:new(CARD_NAME, alternate)
end
function Move:use(cardUseInfo: OnPlayerUseInfo)
    local attackerSitPlace = Sandbox.PlayerStats:getPlayerSitPlace(cardUseInfo.cardOwner)
    local defenderSitPlace = Sandbox.PlayerStats:getPlayerSitPlace(cardUseInfo.defender)

    Sandbox.PlayerStats:setPlayerSitPlace(cardUseInfo.cardOwner, defenderSitPlace)
    Sandbox.PlayerStats:setPlayerSitPlace(cardUseInfo.defender, attackerSitPlace)
end

return {
    ["Bang!!"] = Bang,
    ["Miss"] = Miss,
}