--!strict
local Remotes = {}

local Folder = game.ReplicatedStorage.Remotes

Remotes.UI = {}
--[=[
    Server sends to client (name: string, id: string)
]=]
Remotes.CardAdded = Folder:WaitForChild("CardAdded") :: RemoteEvent
--[=[
    Server sends to client (name: string, id: string)
]=]
Remotes.CardRemoved = Folder:WaitForChild("CardRemoved") :: RemoteEvent
--[=[
    Client sends to server (cardId: string, useInfo)
]=]
Remotes.CardActivateOnClient = Folder:WaitForChild("CardActivateOnClient") :: RemoteEvent
--[=[
    Server sends to client (message: string)
]=]
Remotes.CardActivationFailed = Folder:WaitForChild("CardActivationFailed") :: RemoteEvent
--[=[
    Server sends to client ()
]=]
Remotes.CardActivatedSuccess = Folder:WaitForChild("CardActivatedSuccess") :: RemoteEvent

Remotes.TurnStarted = Folder:WaitForChild("TurnStarted") :: RemoteEvent
Remotes.TurnSkipped = Folder:WaitForChild("TurnSkipped") :: RemoteEvent
Remotes.TurnEnded = Folder:WaitForChild("TurnEnded") :: RemoteEvent
Remotes.TurnTimeout = Folder:WaitForChild("TurnTimeout") :: RemoteEvent
Remotes.TurnDisabled = Folder:WaitForChild("TurnDisabled") :: RemoteEvent
--[=[
    Servers sends client/clients (message: string)
]=]
Remotes.UI.ShowText = Folder.ShowText  :: RemoteEvent
--[=[
    Servers sends to client/clients ()
]=]
Remotes.UI.ClearText = Folder.ClearText  :: RemoteEvent
--[=[
    Servers sends to client (gun: {name: string, range: number})
]=]
Remotes.UI.UpdateWeaponIcon = Folder.UpdateWeaponIcon  :: RemoteEvent
--[=[
    Servers sends to client ()
]=]
Remotes.UI.PutOnScope = Folder.PutOnScope  :: RemoteEvent
--[=[
    Servers sends to client ()
]=]
Remotes.UI.CardUIDIsabled = Folder:WaitForChild("CardUIDIsabled") :: RemoteEvent

return Remotes