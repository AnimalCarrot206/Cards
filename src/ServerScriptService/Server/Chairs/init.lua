--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local NO_SIT_PLACE_VALUE = -1
local NO_OWNER_VALUE = ""

local chairsModels = game.Workspace.Chairs
local sits = chairsModels:GetChildren()

local Chairs = Class:extend()

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
        local one = math.round(math.random() * 100)
        local two = math.round(math.random() * 100)

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
        local ownerName = chair:GetAttribute("Owner")
        if ownerName == NO_OWNER_VALUE then
            continue
        end

        local owner = Players:FindFirstChild(ownerName) :: Player
        PlayerStats:setPlayerSitPlace(owner, NO_SIT_PLACE_VALUE)
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

return Chairs