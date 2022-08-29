--!strict

local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local CardAction = require(game.ServerScriptService.Server.CardAction)

local CardsAction = Class:extend()
--[=[
    Fires when CardAction created
]=]
CardsAction.Action = GoodSignal.new()
--[=[
    Encapsulates CardAction creating 
]=]
function CardsAction:createAction(card)
    local cardAction = CardAction(card)
    self.Action:Fire(cardAction)
end
--[=[
    Encapsulates CardAction removing 
]=]
function CardsAction:destroyAction(cardAction)
    cardAction:destroy()
end

return CardsAction