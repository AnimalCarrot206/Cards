--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local NO_OWNER_VALUE = ""

local chairsModels = game.Workspace.Chairs
local sits: {Model} = chairsModels:GetChildren()
local defaultSitsCFrames: {CFrame} = {}

for index, chair in ipairs(sits) do
    defaultSitsCFrames[index] = chair.PrimaryPart.CFrame
end

local Chairs = Class:extend()

local function _onPlayerLeave(player: Player)
    for index, chair in ipairs(sits) do
        if chair:GetAttribute("Owner") == player.Name then
            chair:SetAttribute("Owner", NO_OWNER_VALUE)
        end
    end
end

local function _onAdditionalRemoteChange(player: Player, currentValue: number)
    local tweenInfo = 
        TweenInfo.new(1.5, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

    local sitPlace = Chairs:getSitPlace(player)
    local chair = sits[sitPlace]
    
    local cframe = chair:GetPivot() + chair:GetPivot().LookVector * currentValue
    local tween = TweenService:Create(chair.PrimaryPart, tweenInfo, {
        CFrame = cframe
    })
    
    tween.Completed:Connect(function(playbackState)
        tween:Destroy()
    end)
    tween:Play()
end

local function _onSitChange(player: Player, currentValue)
    for index, chair in ipairs(sits) do
        if chair:GetAttribute("Owner") == player.Name then
            chair:SetAttribute("Owner", NO_OWNER_VALUE)
            chair:PivotTo(defaultSitsCFrames[index])
        end
        if index == currentValue then
            chair:SetAttribute("Owner", player.Name)
            local seat = chair.Seat :: Seat
            seat:Sit(player.Character:WaitForChild("Humanoid"))
            _onAdditionalRemoteChange(player, PlayerStats:getAdditionalRemoteness(player))
        end
    end
end
--[=[
    Assign all players on a random sit, must be called on game start
]=]
function Chairs:assignPlayers(players: {})
    table.sort(players, function(plr1, plr2)
        local one = Random.new():NextInteger(0, 100)
        local two = Random.new():NextInteger(0, 100)

        return one > two
    end)

    for index, player in ipairs(players) do
        local sit = sits[index]

        PlayerStats:setPlayerSitPlace(player, index)
        sit:SetAttribute("Owner", player.Name)
    end
end
--[=[
    Unassign all players sit, must be called on game end
]=]
function Chairs:unassignAllPlayers()
    for index, chair in ipairs(sits) do
        chair:PivotTo(defaultSitsCFrames[index])
        chair:SetAttribute("Owner", NO_OWNER_VALUE)
    end
end
--[=[
    Finds and returns player sit
]=]
function Chairs:getSitPlace(player: Player)
    for index, chair in ipairs(sits) do
        if chair:GetAttribute("Owner") == player.Name then
            return index
        end
    end
end
--[=[
    Whenever player leave frees its sit
]=]
Players.PlayerRemoving:Connect(_onPlayerLeave)
PlayerStats.SitPlaceChanged:Connect(_onSitChange)
PlayerStats.AdditionalRemotenessChanged:Connect(_onAdditionalRemoteChange)

return Chairs