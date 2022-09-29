--!strict
local Remotes = {}

local Folder = game.ReplicatedStorage.Remotes

Remotes.UI = {}
Remotes.Cards = {}
Remotes.Turn = {}
--[=[
    Server sends to client (name: string, id: string)
]=]
Remotes.Cards.CardAdded = Folder:WaitForChild("CardAdded") :: RemoteEvent
--[=[
    Server sends to client (name: string, id: string)
]=]
Remotes.Cards.CardRemoved = Folder:WaitForChild("CardRemoved") :: RemoteEvent
--[=[
    Client sends to server (cardId: string, useInfo)
]=]
Remotes.Cards.CardActivateOnClient = Folder:WaitForChild("CardActivateOnClient") :: RemoteEvent
--[=[
    Server sends to client (message: string)
]=]
Remotes.Cards.CardActivationFailed = Folder:WaitForChild("CardActivationFailed") :: RemoteEvent
--[=[
    Server sends to client (neededCard: string, causer: Player)
]=]
Remotes.Cards.CardAlternates = Folder:WaitForChild("CardAlternates") :: RemoteEvent
--[=[
    Server sends to client ()
]=]
Remotes.Cards.CardActivatedSuccess = Folder:WaitForChild("CardActivatedSuccess") :: RemoteEvent

Remotes.Turn.TurnStarted = Folder:WaitForChild("TurnStarted") :: RemoteEvent
Remotes.Turn.TurnSkipped = Folder:WaitForChild("TurnSkipped") :: RemoteEvent
Remotes.Turn.TurnEnded = Folder:WaitForChild("TurnEnded") :: RemoteEvent
Remotes.Turn.TurnTimeout = Folder:WaitForChild("TurnTimeout") :: RemoteEvent
Remotes.Turn.TurnDisabled = Folder:WaitForChild("TurnDisabled") :: RemoteEvent
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