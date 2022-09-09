
local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)

game.Players.PlayerAdded:Connect(function(player)
    local startTime = os.time()
    for i = 1, 1000, 1 do
        CardDeckManager:prepareDecks({player})
        CardDeckManager:dealCards()
    
        local deck = CardDeckManager:getPlayerDeck(player)
        local message = ""
        table.foreachi(deck:_getCards(), function(i, v)
            message = string.format("%s | %s", message, v)
        end)
        warn(message)
        CardDeckManager:disableDecks()
    end
    local elapsedTime = os.time() - startTime
    error("Time elapsed: "..tostring(elapsedTime))
end)