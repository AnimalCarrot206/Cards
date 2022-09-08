--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local CardDeck = require(game.ServerScriptService.Server.CardDeck)

local CardDeckManager = Class:extend()

local Decks = {}

local _getRandomCard do
    local isReverseCreated = false
    local MAX_CHANCE_NUMBER = 100

    local chancesForType = {
        [1] = {name = "BonusCard", percent = 10},
        [2] = {name = "WeaponCard", percent = 15},
        [3] = {name = "GameCard", percent = 75},
    }

    local chancesForCards = {
        ["BonusCard"] = {
            [1] = {name = "Other", percent = 100}
        },
        ["WeaponCard"] = {
            [1] = {name = "Other", percent = 100}
        },
        ["GameCard"] = {
            [1] = {name = "Reverse", percent = 1},
            [2] = {name = "Mixed", percent = 99, mixins = {
                "Bang!!", "Miss", "Other"
            }}
        }
    }

    local function _getRandomOther(type: string)
        local enumArray = CustomEnum[type]:GetEnumItems()
        local randomNumber = math.random(1, #enumArray)

        return enumArray[randomNumber]
    end

    local function _getRandomMixin(type: string, mixins: {string})
        local randomNumber = math.random(1, #mixins)
        local mixin = mixins[randomNumber]
        if mixin == "Other" then
            return _getRandomOther(type)
        end
        return mixin
    end

    local function _getRandomType()
        local randomNumber = math.random(1, MAX_CHANCE_NUMBER)
        for index, chanceTable in ipairs(chancesForType) do
            if randomNumber <= chanceTable.percent then
                return chanceTable.name :: string
            end
        end
    end

    _getRandomCard = function()
        local type = _getRandomType()
        local foundTable = chancesForCards[type]
        
        for index, chanceInfo in ipairs(foundTable) do
            if chanceInfo.name == "Other" and chanceInfo.percent == MAX_CHANCE_NUMBER then
                return _getRandomOther(type)
            end
            local randomNumber = math.random(1, MAX_CHANCE_NUMBER)
            if chanceInfo.name == "Mixed" and chanceInfo.percent == randomNumber then
                return _getRandomMixin(type, chanceInfo.mixins)
            end
            if randomNumber <= chanceInfo.percent then
                return CustomEnum[type][chanceInfo.name].Name
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
            --TESTING
            deck:_addCard(card)
            --TESTING
        end
    end
end

return CardDeckManager