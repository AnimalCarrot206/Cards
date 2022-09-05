
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local CardDeckManager = require(game.ServerScriptService.Server.CardDecksManager)

local CardUsedEvent = Remotes.CardUsed

local function _getCard(player, cardId)
    local commonDeck = CardDeckManager:getPlayerCommonDeck(player)
    local bonusDeck = CardDeckManager:getPlayerBonusDeck(player)

    local foundCard = commonDeck:findCard(cardId) or bonusDeck:findCard(cardId)
    return foundCard
end


    local _getCardUsed = 
    Promise.fromEvent(CardUsedEvent.OnServerEvent, function(player: Player, cardId)
        if turnOwner ~= player then
            return false
        end
        local card = _getCard(player, cardId)
        if not card then
            return false
        end
        cardName = cardName or card:getName()
        if card:getName() ~= cardName then
            return false
        end
        return true
    end)
    :timeout(30)
    :andThen(function(player, cardId)
        
    end,
    function(e)
        if Promise.Error.isKind(e, Promise.Error.Kind.TimedOut) then
            Remotes.TurnTimeout:FireClient(turnOwner)
        end
    end)


type onPlayerUseCard = {
    attacker: Player,
    defender: Player,
    attackerCardDeck: any,
    defenderCardDeck: any,
}

local Bang = {}
Bang.isAlternates = true
Bang.Alternate = "Miss"

function Bang:use(info: onPlayerUseCard)
    return Promise.new(function(resolve, reject, onCancel)
        
    end)
end