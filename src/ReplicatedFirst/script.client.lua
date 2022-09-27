if not game:IsLoaded() then
    game.Loaded:Wait()
end
game:WaitForChild("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Remotes")
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)

local screenGui = Instance.new("ScreenGui")

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.Parent = PlayerGui

Remotes.UI.ShowText.OnClientEvent:Connect(function(text: string)
    local textLabel = Instance.new("TextLabel")
    textLabel.TextScaled = true
    textLabel.Text = text or ""

    textLabel.Parent = screenGui
end)

Remotes.UI.ClearText.OnClientEvent:Connect(function()
    local textLabel = screenGui:FindFirstAncestorOfClass("TextLabel")
    if not textLabel then
        return
    end
    textLabel:Destroy()
end)