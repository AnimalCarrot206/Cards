
local Roact = require(game.ReplicatedStorage.Shared.Roact)
local RoactSpring = require(game.ReplicatedStorage.Shared["Roact-spring"])
local Hooks = require(game.ReplicatedStorage.Shared["Roact-hooks"])

local HUGE_ZINDEX_NUMBER = 1000

function OnePlayerUseCard(props, hooks)
    local isDedicated, toggleDedicate = hooks.useState(false)
    local zIndex, setZIndex = hooks.useState(props.zIndex)

    local styles, api = RoactSpring.useSpring(hooks, function()
        return {scale = 1}
    end)

    return Roact.createElement("TextLabel", {
        ZIndex = zIndex,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),

        [Roact.Event.MouseEnter] = function()
            toggleDedicate(true)
            setZIndex(HUGE_ZINDEX_NUMBER)
            api.start({scale = 1.5})
        end,
        [Roact.Event.MouseLeave] = function()
            toggleDedicate(false)
            setZIndex(props.zIndex)
            api.start({scale = 1})
        end,

        [Roact.Event.DragBegin] = function()
            
        end,
        [Roact.Event.DragStopped] = function()
            
        end
    }, {
        uistroke = Roact.createElement("UIStroke", {
            LineJoinMode = Enum.LineJoinMode.Bevel,
            Color = Color3.fromRGB(189, 228, 219),
            Thickness = 4,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Enabled = isDedicated,
        }),
        uiscale = Roact.createElement("UIScale", {
            Scale = styles.scale
        })
    })
end

OnePlayerUseCard = Hooks.new(Roact)(OnePlayerUseCard)

return OnePlayerUseCard