--!strict
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local Animations = require(game.ReplicatedStorage.Shared.Animations)
local Animations = require(game.ReplicatedStorage.Shared.Animations)

local BaseClasses = require(game.ServerScriptService.Server.Cards.BaseClasses)
--[=[
    On player use cards
]=]
--[[
    Класс карты Bang!!
]]
local Bang = BaseClasses.OnPlayerUseCard:extend()
function Bang:new()
    local CARD_NAME = CustomEnum.Cards["Bang!!"].Name
    local isAlternates = true
    local alternate = CustomEnum.Cards["Miss"].Name

    self.super:new(CARD_NAME, isAlternates, alternate)
end
function Bang:use(cardUseInfo)
    local attackerAnim = Animations.ATTACKER_SHOOT_ANIMATION_HIT
    local defenderAnim = Animations.DEFENDER_SHOOT_ANIMATION_HIT
    local attackerAnimTrack = Animations:animatePlayer(cardUseInfo.cardOwner, attackerAnim)
    local defenderAnimTrack = Animations:animatePlayer(cardUseInfo.defender, defenderAnim)

    attackerAnimTrack.Stopped:Connect(function()
        attackerAnimTrack:Destroy()
        defenderAnimTrack:Destroy()

        local defenderHealth = PlayerStats:getHealth(cardUseInfo.defender)
        PlayerStats:setHealth(cardUseInfo.defender, defenderHealth - 1)
    end)
    defenderAnimTrack:Play()
    attackerAnimTrack:Play()
end
--[[
    Класс карты Miss
]]
local Miss = BaseClasses.OnPlayerUseCard:extend()
function Miss:new()
    local CARD_NAME = CustomEnum.Cards["Miss"].Name
    local isAlternates = false
    local alternate = nil
    self.super:new(CARD_NAME, isAlternates, alternate)
end
function Miss:use(cardUseInfo)
    local attacker = cardUseInfo.defender
    local defender = cardUseInfo.cardOwner

    local attackerAnim = Animations.ATTACKER_SHOOT_ANIMATION_HIT
    local defenderAnim = Animations.DEFENDER_SHOOT_ANIMATION_HIT
    local attackerAnimTrack = Animations:animatePlayer(attacker, attackerAnim)
    local defenderAnimTrack = Animations:animatePlayer(defender, defenderAnim)

    attackerAnimTrack.Stopped:Connect(function()
        attackerAnimTrack:Destroy()
        defenderAnimTrack:Destroy()
    end)
    defenderAnimTrack:Play()
    attackerAnimTrack:Play()
end
--[[
    Класс карты Cage
]]
local Cage = BaseClasses.OnPlayerUseCard:extend()
function Cage:new()
    local CARD_NAME = CustomEnum.Cards["Cage"].Name
    local isAlternates = true
    local alternate = CustomEnum.Cards["Mayor's pardon"]
    self.super:new(CARD_NAME, isAlternates, alternate)
end
function Cage:use()
    
end
--[[
    Класс карты Blackmail
]]
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
    local isAlternates = false
    local alternate = nil
    self.super:new(CARD_NAME, isAlternates, alternate)
end
function Move:use(attacker: Player, defender: Player)
    local attackerSitPlace = PlayerStats:getPlayerSitPlace(attacker)
    local defenderSitPlace = PlayerStats:getPlayerSitPlace(defender)

    PlayerStats:setPlayerSitPlace(attacker, defenderSitPlace)
    PlayerStats:setPlayerSitPlace(defender, attackerSitPlace)
end

return {
    ["Bang!!"] = Bang,
    ["Miss"] = Miss,
}