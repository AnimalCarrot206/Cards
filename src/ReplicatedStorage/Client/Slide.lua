local Roact = require(game.ReplicatedStorage.Shared.Roact)
local RoactSpring = require(game.ReplicatedStorage.Shared["Roact-spring"])

local slide = Roact.Component:extend("SlideMenu")

function slide:init()
	self.styles, self.api = RoactSpring.Controller.new({
		position = UDim2.new()
	})
end

function slide:render()
return Roact.createElement("ScreenGui", {
	IgnoreGuiInset = true,
}, {
	slideButton = Roact.createElement("ImageButton", {
		Image = "http://www.roblox.com/asset/?id=4726772330",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		Active = false,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		ClipsDescendants = true,
		Position = UDim2.fromScale(0, 0.3),
		Selectable = false,
		Size = UDim2.fromScale(0.015, 0.175),
		ZIndex = 3,
	}, {
		uICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 20),
		}),
	}),

	slideFrame = Roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.9,
		Position = UDim2.fromScale(-0.3, 0.3),
		Size = UDim2.fromScale(0.25, 0.175),
	}, {
		uIListLayout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0.025, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),

		frame = Roact.createElement("TextButton", {
			Font = Enum.Font.ArialBold,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextScaled = true,
			TextWrapped = true,
			Active = false,
			BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			Selectable = false,
			Size = UDim2.fromScale(0.35, 1),
		}, {
			uIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint"),

			uICorner1 = Roact.createElement("UICorner"),

			uIPadding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.075, 0),
				PaddingLeft = UDim.new(0.075, 0),
				PaddingRight = UDim.new(0.075, 0),
				PaddingTop = UDim.new(0.075, 0),
			}),
		}),

		frame1 = Roact.createElement("TextButton", {
			Font = Enum.Font.ArialBold,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextScaled = true,
			TextWrapped = true,
			Active = false,
			BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			Selectable = false,
			Size = UDim2.fromScale(0.35, 1),
		}, {
			uIAspectRatioConstraint1 = Roact.createElement("UIAspectRatioConstraint"),

			uICorner2 = Roact.createElement("UICorner"),

			uIPadding1 = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.075, 0),
				PaddingLeft = UDim.new(0.075, 0),
				PaddingRight = UDim.new(0.075, 0),
				PaddingTop = UDim.new(0.075, 0),
			}),
		}),

		frame2 = Roact.createElement("TextButton", {
			Font = Enum.Font.ArialBold,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextScaled = true,
			TextWrapped = true,
			Active = false,
			BackgroundColor3 = Color3.fromRGB(70, 70, 70),
			Selectable = false,
			Size = UDim2.fromScale(0.35, 1),
		}, {
			uIAspectRatioConstraint2 = Roact.createElement("UIAspectRatioConstraint"),

			uICorner3 = Roact.createElement("UICorner"),

			uIPadding2 = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(0.075, 0),
				PaddingLeft = UDim.new(0.075, 0),
				PaddingRight = UDim.new(0.075, 0),
				PaddingTop = UDim.new(0.075, 0),
			}),
		}),
	}),
})
end