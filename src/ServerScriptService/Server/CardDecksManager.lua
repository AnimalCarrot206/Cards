--!strict
local Players = game:GetService("Players")

local Class = require(game.ReplicatedStorage.Shared.Class)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local CardDeck = require(game.ServerScriptService.Server.CardDeck)

local DEFAULT_BONUS_DECK_CAPACITY = 900

local CardDecksManager = Class:extend()

local PlayersCommonDecks = {}
local PlayersBonusDecks = {}
--[=[
    Fires when players start leaving, deletes their decks from the Dictionaries
]=]
local function _onPlayerLeave(player: Player)
    local playerName = player.Name

    local commonDeck = PlayersCommonDecks[playerName]
    local bonusDeck = PlayersBonusDecks[playerName]

    if commonDeck and bonusDeck then
        commonDeck:destroy()
        bonusDeck:destroy()
    end
    PlayersCommonDecks[playerName] = nil
    PlayersBonusDecks[playerName] =  nil
end
--[=[
    Creates all players decks. Must be called on game start
]=]
function CardDecksManager:prepareDecks()
    local allPlayers = Players:GetPlayers()

    for index, player in ipairs(allPlayers) do
        local commonDeck = CardDeck(player, PlayerStats:getStartDeckCapacity(player))
        local bonusDeck = CardDeck(player, DEFAULT_BONUS_DECK_CAPACITY)

        local playerName = player.Name
        PlayersCommonDecks[playerName] = commonDeck
        PlayersBonusDecks[playerName] = bonusDeck
    end
end
--[=[
    Removes all players decks. Must be called on game end
]=]
function CardDecksManager:disableDecks()
    for playerName, cardDeck in pairs(PlayersCommonDecks) do
        cardDeck:destroy()
        PlayersCommonDecks[playerName] = nil
    end

    for playerName, bonusCardDeck in pairs(PlayersBonusDecks) do
        bonusCardDeck:destroy()
        PlayersBonusDecks[playerName] = nil
    end
end
--[=[
    Gives random card to a player
]=]
function CardDecksManager:giveRandomCard(player: Player)
    
end
--[=[
    Finds player common deck and returns it
]=]
function CardDecksManager:getPlayerCommonDeck(player: Player)
    return PlayersCommonDecks[player.Name]
end
--[=[
    Finds player bonus deck and returns it
]=]
function CardDecksManager:getPlayerBonusDeck(player: Player)
    return PlayersBonusDecks[player.Name]
end
-- When players leaving we need to delete their decsk
Players.PlayerRemoving:Connect(_onPlayerLeave)

return CardDecksManager