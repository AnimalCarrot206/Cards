--!strict
local Remotes = {}

local Folder = Instance.new("Folder")

Remotes.CardAdded = Instance.new("RemoteEvent", Folder)
Remotes.CardRemoved = Instance.new("RemoteEvent", Folder)

Remotes.CardUsed = Instance.new("RemoteEvent", Folder)
Remotes.IsCardCanBeUsed = Instance.new("RemoteFunction", Folder)

Remotes.TurnStarted = Instance.new("RemoteEvent", Folder)
Remotes.TurnSkipped = Instance.new("RemoteEvent", Folder)
Remotes.TurnEnded = Instance.new("RemoteEvent", Folder)

Folder.Name = "Remotes"
Folder.Parent = game.ReplicatedStorage

return Remotes