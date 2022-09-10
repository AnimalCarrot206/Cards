
local Class = require(game.ReplicatedStorage.Shared.Class)
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local CardUsedEvent = Remotes :: RemoteEvent

-- type CardUseBaseInfo = {
--     id: string,
--     name: string,
-- }
-- type SelfUseInfo = CardUseBaseInfo
-- type OnPlayerUseInfo = CardUseBaseInfo & {
--     defender: string,
-- }
-- type CouplePlayersUseInfo = CardUseBaseInfo & {}

local CardInput = Class:extend()

function CardInput:createRequest(player: Player)
    local request = GoodSignal.new()
    local connection
    connection = 
        Remotes.CardActivateOnClient.OnServerEvent:Connect(function(sender: Player)
            if player ~= sender then
                return
            end
            request:Fire()
            connection:Disconnect()
        end)
    return request
end

function CardInput:createUseInfoRequest(player: Player)
    local request = GoodSignal.new()
    local connection
    connection =
        Remotes.GetCardUseInfo.OnServerEvent:Connect(function(sender, info)
            if sender ~= player then
                return
            end   
            assert(info ~= nil and type(info) == "table")
            assert(info.id ~= nil and type(info.id) == "string")
            assert(info.name ~= nil and type(info.name) == "string")

            local idLiteral = string.sub(info.id, 1, 2)
            if idLiteral == CustomEnum.CardIdLiteral.OnPlayerUseCard then
                assert(info.defender ~= nil and type(info.defender) == "string")
            end

            request:Fire(info)
            connection:Disconnect()
        end)
    return request
end

return CardInput