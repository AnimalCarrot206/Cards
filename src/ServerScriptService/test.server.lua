
local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()
    task.wait(10)
    warn("Dealing cards...")
    CardDeckManager:prepareDecks({player})
end)