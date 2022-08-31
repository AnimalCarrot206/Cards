--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)

local Animations = Class:extend()

Animations.PLAYER_SHOOT_ANIMATION_HIT = Instance.new("Animation")
Animations.ENEMY_SHOOT_ANIMATION_HIT = Instance.new("Animation")

Animations.PLAYER_SHOOT_ANIMATION_MISS = Instance.new("Animation")
Animations.ENEMY_SHOOT_ANIMATION_MISS = Instance.new("Animation")

Animations.PLAYER_TAKES_DAMAGE = Instance.new("Animation")

Animations.PLAYER_USE_LEMONADE = Instance.new("Animation")

function Animations:animatePlayer(player: Player, animation: Animation): AnimationTrack
    local character = player.Character :: Model
    local humanoid = character:FindFirstChildOfClass("Humanoid") :: Humanoid
    local animator = humanoid:FindFirstChildOfClass("Animator") :: Animator

    local animationTrack = animator:LoadAnimation(animation)

    return animationTrack
end

return Animations