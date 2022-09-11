--!strict
local Remotes = {}

local Folder = game.ReplicatedStorage.Remotes

Remotes.CardAdded = Folder:WaitForChild("CardAdded")
Remotes.CardRemoved = Folder:WaitForChild("CardRemoved")

Remotes.CardActivateOnClient = Folder:WaitForChild("CardActivateOnClient")
Remotes.CardActivationFailed = Folder:WaitForChild("CardActivationFailed")
Remotes.CardActivatedSuccess = Folder:WaitForChild("CardActivatedSuccess")

Remotes.GetCardUseInfo = Folder:WaitForChild("GetCardUseInfo")
Remotes.InvalidCardUseInfo = Folder:WaitForChild("InvalidCardUseInfo")

Remotes.TurnStarted = Folder:WaitForChild("TurnStarted")
Remotes.TurnSkipped = Folder:WaitForChild("TurnSkipped")
Remotes.TurnEnded = Folder:WaitForChild("TurnEnded")
Remotes.TurnTimeout = Folder:WaitForChild("TurnTimeout")
Remotes.TurnDisabled = Folder:WaitForChild("TurnDisabled")

return Remotes