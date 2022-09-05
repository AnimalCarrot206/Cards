
local Class = require(game.ReplicatedStorage.Shared.Class)
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)

local CardUsedEvent = game.ReplicatedStorage.CardUsed :: RemoteEvent

local CardInput = Class:extend()

function CardInput:listen(turnOwner, cardName: string?)
    while true do
        local player, name, id = CardUsedEvent.OnServerEvent:Wait()
        if player ~= turnOwner then
            continue
        end
        if type(id) ~= "string" or type(name) ~= "string" then

            continue
        end
        
        cardName = cardName or name
        if cardName ~= name then
            continue
        end

        return id
    end
end

return CardInput