if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Roact = require(game.ReplicatedStorage.Shared.Roact)
local RoactSpring = require(game.ReplicatedStorage.Shared["Roact-spring"])
local Hooks = require(game.ReplicatedStorage.Shared["Roact-hooks"])

local Card = Roact.Component:extend("Card")

local DEFAULT_SIZE = UDim2.fromScale(0.15, 0.9)
local MOUSE_ENTER_SIZE = UDim2.fromScale(0.175, 1.05)

function Card:init(initialProps)
	self.styles, self.api = RoactSpring.Controller.new({
		rotation = initialProps.rotation,
		position = initialProps.position,
		size = UDim2.fromScale(0.075, 0.3)
	})

	self.state = {
		isOpened = false
	}
end

function Card:render(props, hooks)
	return Roact.createElement("TextButton", {
		Text = "",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		LayoutOrder = 1,
		Size = self.styles.size,
		Position = self.styles.position,
		Rotation = self.styles.rotation,
		AnchorPoint = Vector2.new(0.5, 0.5),

		[Roact.Event.MouseEnter] = function()
			self.api:start({
				size = UDim2.fromScale(0.1, 0.4),
				config = RoactSpring.config.stiff
			})
		end,
		[Roact.Event.MouseLeave] = function()
			self.api:start({
				size = UDim2.fromScale(0.075, 0.3),
				config = RoactSpring.config.stiff
			})
		end,

		[Roact.Event.MouseButton1Click] = function()
			if self.state.isOpened == true then
				self.api:start({
					config = RoactSpring.config.stiff,
					position = self.props.position,
					rotation = self.props.rotation,
				})
			end
			if self.state.isOpened == false then
				self.api:start({
					config = RoactSpring.config.stiff,
					position = UDim2.fromScale(self.props.position.X.Scale, 0),
					rotation = 0
				})
			end
			self.state.isOpened = not self.state.isOpened
		end

	}, {
		uICorner = Roact.createElement("UICorner"),

		uIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 0.75,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Height,
		}),

		label = Roact.createElement("TextLabel", {
			Text = self.props.cardName,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextScaled = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.1),
			Size = UDim2.fromScale(1, 0.2),
		}, {
			uIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0.15, 0),
				PaddingRight = UDim.new(0.15, 0),
			}),

			uICorner1 = Roact.createElement("UICorner"),
		}),

		image = Roact.createElement("ImageLabel", {
			ImageColor3 = Color3.fromRGB(255, 239, 158),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 0.9,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.2),
			Size = UDim2.fromScale(1, 0.8),
			Image = self.props.imageId,
		}),
	})
end

local screenGui = Instance.new("ScreenGui", Player.PlayerGui)

local c = Roact.createElement(Card, {
	cardName = "Bang!!",
	position = UDim2.fromScale(0.5, 0.7),
	image = "",
	rotation = -10
})

Roact.mount(c, screenGui)