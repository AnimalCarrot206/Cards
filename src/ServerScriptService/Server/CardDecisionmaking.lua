--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)

local CardsAction = require(game.ServerScriptService.Server.CardsAction)
local CardDecksManager = require(game.ServerScriptService.Server.CardDecksManager)

local CardDecisionmaking = Class:extend()

local cards: {{owner: Player, card: any, enemy: Player?}} = {}

local function _findOverlap(card, playerThatShouldOvelrap)
    for index, info in ipairs(cards) do
        local overlap = card:getOverlap()
        if info.card:getName() == overlap then
            return info.card
        end
    end
end

local function _removeCard(player: Player, card)
    local id = card:getId()
    local commonDeck = CardDecksManager:getPlayerCommonDeck(player)
    local bonusDeck = CardDecksManager:getPlayerBonusDeck(player)

    if commonDeck:findCard(id) then
        commonDeck:removeCard(id)
    elseif bonusDeck:findCard(id) then
        bonusDeck:removeCard(id)
    end
end


local function _excludeOverlappingCards()
    for index, info in pairs(cards) do
        if not info.enemy then
            continue
        end

        local overlap = _findOverlap(info.card, info.enemy)
        if overlap then
            _removeCard(info.owner, info.card)
            info.owner = nil
            info.card = nil
            info.enemy = nil
            cards[index] = nil
        end
    end
end

local function _()
    
end

function CardDecisionmaking:setPlayerActivatedCard(player: Player, activatedCard, enemy: Player?)
    local info = {
        owner = player,
        card = activatedCard,
        enemy = enemy
    }

    table.insert(cards, info)
end

function CardDecisionmaking:useCards()
    _excludeOverlappingCards()

    for index, info in pairs(cards) do
        local action = CardsAction:createAction(info.card)

        action.Activated:Connect(function()
            info.card:use(info.owner, info.enemy)
            _removeCard(info.owner, info.card)
            info.owner = nil
            info.card = nil
            info.enemy = nil
            action:destroy()
        end)
        action.Cancelled:Connect(function()
            _removeCard(info.owner, info.card)
            info.owner = nil
            info.card = nil
            info.enemy = nil
            action:destroy()
        end)
    end
end

return CardDecisionmaking