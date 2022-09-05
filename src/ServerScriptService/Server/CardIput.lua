
local Class = require(game.ReplicatedStorage.Shared.Class)
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)

local CardUsedEvent = game.ReplicatedStorage.CardUsed :: RemoteEvent

local CardInput = Class:extend()

function CardInput:listen(turnOwner, cardName: string?)
    return Promise.fromEvent(CardUsedEvent.OnServerEvent, function(player, name, id)
        if player ~= turnOwner then
            return false
        end
        if type(id) ~= "string" or type(name) ~= "string" then
            return false
        end
        
        cardName = cardName or name
        if cardName ~= name then
            return false
        end

        return true
    end)
end

return CardInput