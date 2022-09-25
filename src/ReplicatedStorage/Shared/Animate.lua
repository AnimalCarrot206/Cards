
local TweenService = game:GetService("TweenService")

local Animate = {}

local DEFAULT_TWEEN_INFO = {
    Default = TweenInfo.new(0.1),
}

function Animate:createTween(object, props: {[string] : any}, tweenInfo: TweenInfo?)
    assert(object ~= nil and typeof(object) == "Instance", "")

    local tween = 
        TweenService:Create(object, tweenInfo or DEFAULT_TWEEN_INFO.Default, props)

    return tween
end

function Animate:createSinglePlayTween(object, props: {[string] : any}, tweenInfo: TweenInfo?)
    local tween = self:createTween(object, props, tweenInfo)

    tween.Completed:Connect(function(playbackState)
        tween:Destroy()
    end)
    return tween
end

function Animate:animate(object, props: {[string] : any}, tweenInfo: TweenInfo?)
    local tween = self:createSinglePlayTween(object, props, tweenInfo)

    tween:Play()
end

function Animate:animateWithYielding(object, props: {[string] : any}, tweenInfo: TweenInfo?)
    local tween = self:createSinglePlayTween(object, props, tweenInfo)

    tween:Play()
    tween.Completed:Wait()
end

return Animate