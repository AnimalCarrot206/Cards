--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)

local Gun = Class:extend()

Gun.Container = game.ReplicatedStorage.Models.Guns :: Folder

Gun.PLAYER_SHOOT_ANIMATION_HIT = Instance.new("Animation")
Gun.ENEMY_SHOOT_ANIMATION_HIT = Instance.new("Animation")

Gun.PLAYER_SHOOT_ANIMATION_MISS = Instance.new("Animation")
Gun.ENEMY_SHOOT_ANIMATION_MISS = Instance.new("Animation")

local function _animate(player: Player, animation: Animation): AnimationTrack
    local character = player.Character
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local animator = humanoid:FindFirstChildOfClass("Animator")

    local animationTrack = animator:LoadAnimation(animation)

    return animationTrack
end

function Gun:new(player: Player, gunName: string)
    local gunConfig = self.Container.RustyRevolver :: Configuration

    local name = gunConfig:GetAttribute("Name") :: string
    local range = gunConfig:GetAttribute("Range") :: number
    local model = gunConfig.ModelValue.Value :: Model


    self.name = name
    self.range = range
    self.model = model
    self.owner = player
end

function Gun:destroy()
    self.model:Destroy()
    table.clear(self)
    self = nil
end

function Gun:shoot(enemy: Player, miss: boolean)
    local playerAnimation = _animate(self.owner, 
    miss and self.PLAYER_SHOOT_ANIMATION_MISS or self.PLAYER_SHOOT_ANIMATION_HIT)

    local enemyAnimation = _animate(enemy, 
    miss and self.ENEMY_SHOOT_ANIMATION_MISS or self.ENEMY_SHOOT_ANIMATION_HIT)

    playerAnimation:Play()
    enemyAnimation:Play()

    enemyAnimation.Stopped:Connect(function()
        if miss ~= true then
            local previousHp = enemy:GetAttribute("Hp")
            enemy:SetAttribute("Hp", previousHp - 1)
        end

        enemyAnimation:Destroy()
        playerAnimation:Destroy()
    end)
end

function Gun:getName(): string
    return self.name :: string
end

function Gun:getRange(): number
    return self.range :: number
end

function Gun:getOwner(): Player
    return self.owner :: Player
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

function NavyRevolver:new(player: Player)
    self.super:new(player, "Navy Revolver")
end

function NavyRevolver:shoot(enemy: Player)
    local chance = 30

    local x = math.random()
    x = x * 100
    x = math.round(x)

    if x >= chance then
        self.super:shoot(enemy)
    end
end

local Winchecter = Gun:extend()

function Winchecter:new(player: Player)
    self.super:new(player, "Winchecter")
end

return {rustyRevolver = RustyRevolver, shawedOff = ShawedOff, 
judi = Judi,navyRevolver = NavyRevolver,winchecter = Winchecter}
