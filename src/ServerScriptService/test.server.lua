
local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)

game.Players.PlayerAdded:Connect(function(player)
    CardDeckManager:prepareDecks({player})
    CardDeckManager:dealCards()
    
    local deck = CardDeckManager:getPlayerDeck(player)
    
    for index, card in ipairs(deck:_getCards()) do
        print(card)
    end
end)