--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local NO_OWNER_VALUE = ""

local chairsModels = game.Workspace.Chairs
local sits = chairsModels:GetChildren()

local Chairs = Class:extend()

local function _onSitChange(previousValue, currentValue)
    if previousValue == currentValue then
        return
    end

    local ownerName = ""
    for index, chair in ipairs(sits) do
        if index == previousValue then
            ownerName = chair:GetAttribute("Owner")
            chair:SetAttribute("Owner", NO_OWNER_VALUE)
        end
    end
    for index, chair in ipairs(sits) do
        if index == currentValue then
            chair:SetAttribute("Owner", ownerName)
        end
    end
end

local function _onPlayerLeave(player: Player)
    for index, chair in ipairs(sits) do
        if chair:GetAttribute("Owner") == player.Name then
            chair:SetAttribute("Owner", NO_OWNER_VALUE)
        end
    end
end
--[=[
    Assign all players on a random sit, must be called on game start
]=]
function Chairs:assignAllPlayers()
    local allPlayers = Players:GetPlayers()

    table.sort(allPlayers, function(plr1, plr2)
        local one = Random.new():NextInteger(0, 100)
        local two = Random.new():NextInteger(0, 100)

        return one > two
    end)

    for index, player in ipairs(allPlayers) do
        local sit = sits[index]

        PlayerStats:setPlayerSitPlace(player, index)
        sit:SetAttribute("Owner", player.Name)
    end
end
--[=[
    Unassign all players sit, must be called on game end
]=]
function Chairs:unassignAllPlayers()
    for _, chair in ipairs(sits) do
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

return Chairs