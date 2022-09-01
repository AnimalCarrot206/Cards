--!strict
local Roact = require(game.ReplicatedStorage.Shared.Roact)
local RoactSpring = require(game.ReplicatedStorage.Shared["Roact-spring"])

local CardManager = require(game.ReplicatedStorage.Client.CardManager)

local Card = Roact.Component:extend("Card")

local styles, api = RoactSpring.useSpring()

function Card:init()
    self.styles, self.api = RoactSpring.Controller.new({
        size = UDim2.fromScale(0.15, 0.35)
    })
end

function Card:render()
    return Roact.createElement("ImageButton", {
        image = self.props.image,
        name = self.props.name,
        size = self.styles.size,


        [Roact.Event.MouseEnter] = function()
            self.api:start({
                size = UDim2.fromScale(0.175, 0.375)
            })
        end,
        [Roact.Event.MouseLeave] = function()
            self.api:start({
                size = UDim2.fromScale(0.15, 0.35)
            })
        end
    }, {
        uicorner = Roact.createElement("UICorner"),
        [self.props.name] = Roact.createElement("TextLabel", {
            Text = self.props.name
        })
    })
end

return Card