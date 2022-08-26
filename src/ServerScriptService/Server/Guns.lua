--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local Animations = require(game.ReplicatedStorage.Shared.Animations)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local shootTypeEnum = CustomEnum.new("ShootType", {
    Hit = 0,
    Miss = 1,
})

local Gun = Class:extend()

Gun.Container = game.ReplicatedStorage.Models.Guns :: Folder

local function _ambush(player: Player)
    
end

local function _makeDamage(player: Player)
    local takeDamageAnimation = Animations.PLAYER_TAKES_DAMAGE
    local animationTrack = Animations:animatePlayer(player, takeDamageAnimation)

    animationTrack.Stopped:Once(function()
        local currentHp = PlayerStats:getHealth(player)
        PlayerStats:setHealth(currentHp - 1)
    end)
end

function Gun:new(player: Player, gunName: string)
    local gunConfig = self.Container.RustyRevolver :: Configuration

    local name = gunConfig:GetAttribute("Name") :: string
    local range = gunConfig:GetAttribute("Range") :: number
    local model = gunConfig.ModelValue.Value :: Model


    self._name = name
    self._range = range
    self._model = model
    self._owner = player
end

function Gun:destroy()
    self._model:Destroy()
    table.clear(self)
    self = nil
end

function Gun:shoot(enemy: Player, shootTypeEnum)
    local playerAnimation
    local enemyAnimation 

    if shootTypeEnum == CustomEnum.ShootType.Hit then
        playerAnimation = Animations.PLAYER_SHOOT_ANIMATION_HIT
        enemyAnimation = Animations.ENEMY_SHOOT_ANIMATION_HIT
    elseif shootTypeEnum == CustomEnum.ShootType.Miss then
        playerAnimation = Animations.PLAYER_SHOOT_ANIMATION_MISS
        enemyAnimation = Animations.ENEMY_SHOOT_ANIMATION_MISS
    end

    local playerAnimationTrack = Animations:animatePlayer(self._owner, playerAnimation)
    local enemyAnimationTrack = Animations:animatePlayer(enemy, enemyAnimation)

    playerAnimationTrack:Play()
    enemyAnimationTrack:Play()

    local connection
    connection = enemyAnimationTrack.Stopped:Connect(function()
        if shootTypeEnum == CustomEnum.ShootType.Hit then
            _makeDamage(enemy)
        end

        connection:Disconnect()
    end)
end

function Gun:ambush(player: Player)
    _ambush(player)
    _makeDamage(player)
end

function Gun:getName(): string
    return self._name :: string
end

function Gun:getRange(): number
    return self._range :: number
end

function Gun:getOwner(): Player
    return self._owner :: Player
end

--[[
    END
]]

local RustyRevolver = Gun:extend()

function RustyRevolver:new(player: Player)
    self.super:new(player, "Rusty Revolver")
end

local ShawedOff = Gun:extend()

function ShawedOff:new(player: Player)
    self.super:new(player, "Shawed Off")
end

local Judi = Gun:extend()

function Judi:new(player: Player)
    self.super:new(player, "Judi")
end

local NavyRevolver = Gun:extend()

function NavyRevolver:new(player: Player, shootTypeEnum)
    self.super:new(player, "Navy Revolver")
end

function NavyRevolver:shoot(enemy: Player)
    local chance = 30

    local x = math.random()
    x = x * 100
    x = math.round(x)

    if x >= chance then
        self.super:shoot(enemy, shootTypeEnum)
    end
end

local Winchecter = Gun:extend()

function Winchecter:new(player: Player)
    self.super:new(player, "Winchecter")
end

return {["Rusty revolver"] = RustyRevolver, ["Shawed off"] = ShawedOff,
["Judi"] = Judi, ["Navy revolver"] = NavyRevolver, ["Winchester"] = Winchecter}
