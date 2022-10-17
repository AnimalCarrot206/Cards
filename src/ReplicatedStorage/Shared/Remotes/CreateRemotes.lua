local Folder = Instance.new("Folder")
Folder.Name = "Remotes"
Folder.Parent = game.ReplicatedStorage

local Remotes = {
    Cards = {
        "CardAdded",
        "CardRemoved",
        "CardActivateOnClient",
        "CardActivationFailed",
        "CardAlternates",
        "CardActivatedSuccess",
    },
    Turns = {
        "TurnStarted",
        "TurnSkipped",
        "TurnEnded",
        "TurnTimeout",
        "TurnDisabled",
    },
    UI = {
        "ShowText",
        "ClearText",
        "UpdateWeaponIcon",
        "PutOnScope",
        "CardUIDisabled",
    }
}

return function ()
    for _, array in pairs(Remotes) do
        for _, remoteName in ipairs(array) do
            local remoteEvent = Instance.new("RemoteEvent")
            remoteEvent.Name = remoteName
            remoteEvent.Parent = Folder
            warn(string.format("%s created!", remoteName))
        end
    end
end