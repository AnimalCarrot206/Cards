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
        GameCard = 75,
        WeaponCard = 15,
        BonusCard = 9,
        rarestCard = 1,
    }

    _getRandomCard = function()
        local randomNumber = math.round(math.random() * 100)
        local enumList

        for key, precent in pairs(chances) do
            if randomNumber <= chances.rarestCard and isReverseCreated == false then
                isReverseCreated = true
                return CustomEnum.GameCards["Reverse"].Name
            end

        end

        if randomNumber <= chances.bonusCard then
            enumList = CustomEnum.BonusCard:GetEnumItems()
        end
        if randomNumber <= chances.weaponCard then
            enumList = CustomEnum.WeaponCard:GetEnumItems()
        end
        if randomNumber <= chances.gameCard then
            enumList = CustomEnum.GameCards:GetEnumItems()
        end
        local randomIndex = math.random(1, #enumList)
            
        return enumList[randomIndex].Name
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
            --TESTING
            deck:_addCard(card)
            --TESTING
        end
    end
end

return CardDeckManager