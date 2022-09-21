--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)

local PlayerCardUI_Server = Class:extend()

function PlayerCardUI_Server:showText(player: Player, text: string)
    assert(text and type(text) == "string")
    Remotes.UI.ShowText:FireClient(player, text)
end

function PlayerCardUI_Server:clearText(player: Player)
    Remotes.UI.ClearText:FireClient(player)
end

function PlayerCardUI_Server:showGlobalText(text: string)
    assert(text and type(text) == "string")
    Remotes.UI.ShowText:FireAllClients(text)
end

function PlayerCardUI_Server:clearGlobalText()
    Remotes.UI.ClearText:FireAllClients()
end

function PlayerCardUI_Server:setWeaponIcon(player: Player, weaponName: string)
    assert(weaponName and type(weaponName) == "string")
    Remotes.UI.UpdateWeaponIcon:FireClient(player, weaponName)
end

function PlayerCardUI_Server:putOnScope(player: Player)
    Remotes.UI.PutOnScope:FireClient(player)
end


return PlayerCardUI_Server
