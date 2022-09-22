--!strict
local Remotes = {}

local Folder = game.ReplicatedStorage.Remotes

Remotes.UI = {}

Remotes.CardAdded = Folder:WaitForChild("CardAdded")
Remotes.CardRemoved = Folder:WaitForChild("CardRemoved")

Remotes.CardActivateOnClient = Folder:WaitForChild("CardActivateOnClient")
Remotes.CardActivationFailed = Folder:WaitForChild("CardActivationFailed")
Remotes.CardActivatedSuccess = Folder:WaitForChild("CardActivatedSuccess")

Remotes.TurnStarted = Folder:WaitForChild("TurnStarted")
Remotes.TurnSkipped = Folder:WaitForChild("TurnSkipped")
Remotes.TurnEnded = Folder:WaitForChild("TurnEnded")
Remotes.TurnTimeout = Folder:WaitForChild("TurnTimeout")
Remotes.TurnDisabled = Folder:WaitForChild("TurnDisabled")

Remotes.UI.ShowText = Folder.ShowText
Remotes.UI.ClearText = Folder.ClearText
Remotes.UI.UpdateWeaponIcon = Folder.UpdateWeaponIcon --(player, gun: {name, range, model})
Remotes.UI.PutOnScope = Folder.PutOnScope

return Remotes