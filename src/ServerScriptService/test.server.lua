
local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)

game.Players.PlayerAdded:Connect(function(player)
    CardDeckManager:prepareDecks({player})
end)