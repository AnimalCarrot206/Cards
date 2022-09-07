--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local CardDeck = require(game.ServerScriptService.Server.CardDeck)

local CardDeckManager = Class:extend()

local Decks = {}

local _getRandomCard do
    local isReverseCreated = false

    local chances = {
        gameCard = 75,
        weaponCard = 15,
        bonusCard = 9,
        rarestCard = 1,
    }

    _getRandomCard = function()
        local randomNumber = math.round(math.random()) * 100
        if randomNumber <= chances.rarestCard and isReverseCreated == false then
            isReverseCreated = true
            return CustomEnum.Cards.GameCards["Reverse"].Name
        end
        local enumList
        if randomNumber <= chances.bonusCard then
            enumList = CustomEnum.Cards.BonusCard:GetEnumItems()
        end
        if randomNumber <= chances.weaponCard then
            enumList = CustomEnum.Cards.WeaponCard:GetEnumItems()
        end
        if randomNumber <= chances.gameCard then
            enumList = CustomEnum.Cards.GameCards:GetEnumItems()
        end
        local randomIndex = math.random(1, #enumList)
            
        for index, cardEnum in ipairs(enumList) do
            if index == randomIndex then
                return cardEnum.Name
            end
        end
    end
end

function CardDeckManager:prepareDecks(inGamePlayers: {Player})
    for index, player in ipairs(inGamePlayers) do
        local createdDeck = CardDeck(player, PlayerStats:getStartDeckCapacity(player))
        table.insert(Decks, createdDeck)
        self:dealCards()
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

function CardDeckManager:dealCards()
    for index, deck in ipairs(Decks) do
        local deckFreeSpace = deck:getFreeSpace() :: number
        for i = 1, deckFreeSpace, 1 do
            local card = _getRandomCard()
            deck:addCard(card)
        end
    end
end

return CardDeckManager