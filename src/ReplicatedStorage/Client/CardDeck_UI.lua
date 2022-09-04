--!strict
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local Roact = require(game.ReplicatedStorage.Shared.Roact)
local RoactSpring = require(game.ReplicatedStorage.Shared["Roact-spring"])

local CardUI = require(game.ReplicatedStorage.Client.Card_UI)
local CardDeckManager

local CardDeck = Roact.Component:extend("CardDeck")

function CardDeck:init()
    
end
