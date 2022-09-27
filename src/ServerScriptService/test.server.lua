
local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)
local Chairs = require(game.ServerScriptService.Server.Chairs)
local Armory = require(game.ServerScriptService.Server.Armory)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()
    local players = game.Players:GetPlayers()
    local playerCount = #players
    if playerCount >= 2  then
        task.wait(10)
        warn("Dealing cards...")
        Chairs:assignPlayers(players)
        Armory:prepareGuns(players)
        CardDeckManager:prepareDecks(players)

        Remotes.CardActivateOnClient.OnServerEvent:Connect(function(player, cardId, ...)
            local args = {...}
            local cardDeck = CardDeckManager:getPlayerDeck(player)
            local card = cardDeck:getCard(cardId)

            local cardType = card:getUseType()
            if cardType == "SelfUseCard" then
                card:use({cardOwner = player, cardOwnerDeck = cardDeck})
            end
            if cardType == "CouplePlayersUseCard" then
                local decks = {}
                for index, player in ipairs(players) do
                    table.insert(decks, CardDeckManager:getPlayerDeck(player))
                end
                card:use({players = players, decks = decks})
            end
            if cardType == "OnPlayerUseType" then
                local defender = unpack(args) :: Player
                local defenderDeck = CardDeckManager:getPlayerDeck(defender)
                card:use({
                    cardOwner = player,
                    cardOwnerDeck = cardDeck,
                    defender = defender,
                    defenderDeck = defenderDeck,
                })
            end
            cardDeck:removeCard(cardId)
        end)
    end
end)