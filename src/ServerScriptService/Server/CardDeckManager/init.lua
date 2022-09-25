--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local CardDeck = require(game.ServerScriptService.Server.CardDeck)
local _getRandomCard = require(game.ServerScriptService.Server.RandomCardChooser)

local CardDeckManager = Class:extend()

local Decks = {}

function CardDeckManager:prepareDecks(inGamePlayers: {Player})
    for index, player in ipairs(inGamePlayers) do
        local createdDeck = CardDeck(player, PlayerStats:getStartDeckCapacity(player))
        table.insert(Decks, createdDeck)
        self:dealCardsToAllPlayers()
    end
end

function CardDeckManager:disableDecks()
    for index, deck in ipairs(Decks) do
        deck:destroy()
        deck = nil
    end
    table.clear(Decks)
end

function CardDeckManager:getPlayerDeck(player: Player)
    for index, deck in ipairs(Decks) do
        if deck:getOwner() == player then
            return deck
        end
    end
end

function CardDeckManager:dealCardsToAllPlayers()
    for index, deck in ipairs(Decks) do
        local deckFreeSpace = deck:getFreeSpace() :: number
        for i = 1, deckFreeSpace, 1 do
			local cardName = _getRandomCard()
			warn(cardName)
            --TESTING
            deck:addCard(cardName)
            --TESTING
        end
    end
end

function CardDeckManager:dealCardsToPlayer(player: Player, cardsNumber: number)
    local playerDeck = self:getPlayerDeck(player)
    for i = cardsNumber, 1, -1 do
        local cardName = _getRandomCard()
        playerDeck:addCard(cardName, false)
    end
end

return CardDeckManager