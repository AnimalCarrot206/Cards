--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)

local CardOverrides = Class:extend()

local overrides = {}

type Card = {}
type UseInfo = {}
function CardOverrides:createOverride(player, cardName, override: (Card, UseInfo) -> {})
    overrides[player][cardName] = override
end

function CardOverrides:removeOverride(player, cardName)
    local playerTable = overrides[player]
    if not playerTable then
        return
    end
    playerTable[cardName] = nil
end

function CardOverrides:getOverride(player, cardName)
    local playerTable = overrides[player]
    if not playerTable then
        return
    end
    return playerTable[cardName] :: (Card, UseInfo) -> {}
end

return CardOverrides