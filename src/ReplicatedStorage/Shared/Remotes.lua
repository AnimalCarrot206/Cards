--!strict
local Remotes = {}

local Folder = Instance.new("Folder")

Remotes.CardAdded = Instance.new("RemoteEvent", Folder)
Remotes.CardRemoved = Instance.new("RemoteEvent", Folder)

Remotes.CardActivateOnClient = Instance.new("RemoteEvent", Folder)
Remotes.CardActivationFailed = Instance.new("RemoteEvent")
Remotes.CardActivatedSuccess = Instance.new("RemoteEvent")

Remotes.GetCardUseInfo = Instance.new("RemoteEvent")
Remotes.InvalidCardUseInfo = Instance.new("RemoteEvent")



Remotes.TurnStarted = Instance.new("RemoteEvent", Folder)
Remotes.TurnSkipped = Instance.new("RemoteEvent", Folder)
Remotes.TurnEnded = Instance.new("RemoteEvent", Folder)
Remotes.TurnTimeout = Instance.new("RemoteEvent", Folder)
Remotes.TurnDisabled = Instance.new("RemoteEvent", Folder)

Folder.Name = "Remotes"
Folder.Parent = game.ReplicatedStorage

return Remotes