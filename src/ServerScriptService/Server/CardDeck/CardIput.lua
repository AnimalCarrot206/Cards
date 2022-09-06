
local Class = require(game.ReplicatedStorage.Shared.Class)
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local CardUsedEvent = game.ReplicatedStorage.CardUsed :: RemoteEvent

type CardUseBaseInfo = {
    id: string,
    name: string,
}
type SelfUseInfo = CardUseBaseInfo
type OnPlayerUseInfo = CardUseBaseInfo & {
    defender: Player,
}
type CouplePlayersUseInfo = CardUseBaseInfo & {}

local CardInput = Class:extend()

function CardInput:listen(turnOwner, cardName: string?)
    while true do
        local player, 
            info: SelfUseInfo | OnPlayerUseInfo | CouplePlayersUseInfo = CardUsedEvent.OnServerEvent:Wait()
        local name = info.name
        local id = info.id

        local idLiteral = string.sub(id, 1,2)
        if idLiteral == CustomEnum.CardIdLiteral.OnPlayerUseCard then
            if info.defender == nil then
                continue
            end
        end

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
        return info
    end
end

return CardInput