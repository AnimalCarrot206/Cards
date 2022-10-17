--!strict
local Remotes = {}

local Folder = game.ReplicatedStorage.Remotes

Remotes.UI = {}
Remotes.Cards = {}
Remotes.Turn = {}
--[=[
    Server sends to client (name: string, id: string)
]=]
Remotes.Cards.CardAdded = Folder.CardAdded :: RemoteEvent
--[=[
    Server sends to client (name: string, id: string)
]=]
Remotes.Cards.CardRemoved = Folder.CardRemoved :: RemoteEvent
--[=[
    Client sends to server (cardId: string, useInfo)
]=]
Remotes.Cards.CardActivateOnClient = Folder.CardActivateOnClient :: RemoteEvent
--[=[
    Server sends to client (message: string)
]=]
Remotes.Cards.CardActivationFailed = Folder.CardActivationFailed :: RemoteEvent
--[=[
    Server sends to client (neededCard: string, causer: Player)
]=]
Remotes.Cards.CardAlternates = Folder.CardAlternates :: RemoteEvent
--[=[
    Server sends to client ()
]=]
Remotes.Cards.CardActivatedSuccess = Folder.CardActivatedSuccess :: RemoteEvent

Remotes.Turn.TurnStarted = Folder.TurnStarted :: RemoteEvent
Remotes.Turn.TurnSkipped = Folder.TurnSkipped :: RemoteEvent
Remotes.Turn.TurnEnded = Folder.TurnEnded :: RemoteEvent
Remotes.Turn.TurnTimeout = Folder.TurnTimeout :: RemoteEvent
Remotes.Turn.TurnDisabled = Folder.TurnDisabled :: RemoteEvent
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
Remotes.UI.CardUIDisabled = Folder.CardUIDisabled :: RemoteEvent

return Remotes