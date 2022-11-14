
local TweenService = game:GetService("TweenService")

local Animate = {}

local DEFAULT_TWEEN_INFO = {
    Default = TweenInfo.new(0.1),
}
--Creates common tween
function Animate:createTween(object, props: {[string] : any}, tweenInfo: TweenInfo?)
    assert(object ~= nil and typeof(object) == "Instance", "Object to animate must be instance got: " .. tostring(object))

    local tween = 
        TweenService:Create(object, tweenInfo or DEFAULT_TWEEN_INFO.Default, props)

    return tween
end
--Creates tween that which will destroyed when completed
function Animate:createSinglePlayTween(object, props: {[string] : any}, tweenInfo: TweenInfo?)
    local tween = self:createTween(object, props, tweenInfo)

    tween.Completed:Connect(function()
        tween:Destroy()
    end)
    return tween
end
--Creates tween and plays it, destroys it when completed
function Animate:animate(object, props: {[string] : any}, tweenInfo: TweenInfo?)
    local tween = self:createSinglePlayTween(object, props, tweenInfo)

    tween:Play()
end
--Creates tween and plays it, yields until tween completed then destroys it
function Animate:animateWithYielding(object, props: {[string] : any}, tweenInfo: TweenInfo?)
    local tween = self:createSinglePlayTween(object, props, tweenInfo)

    tween:Play()
    tween.Completed:Wait()
end

return Animate