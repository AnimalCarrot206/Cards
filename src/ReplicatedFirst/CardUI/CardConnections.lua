
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)
local DraggableObject = require(game.ReplicatedStorage.Client.DraggableObject)
local Animate = require(game.ReplicatedStorage.Shared.Animate)

local CardPositions = require(script.Parent.CardPositions)

local CardRaised = GoodSignal.new()
local CardReleased = GoodSignal.new()

local _releaseCard
local _raiseCard

do
    local tweenInfo = TweenInfo.new()

    _releaseCard = function(cards: {CanvasGroup}, card: CanvasGroup)
        card:SetAttribute("IsRaised", false)
        CardPositions.setPositionsInOrder(cards)
    end
    
    _raiseCard = function(card: CanvasGroup)
        card:SetAttribute("IsRaised", true)
        local position = UDim2.fromScale(card.Position.X.Scale, -0.5)
        local rotation = 0
        Animate:animate(card, {
            Position = position,
            Rotation = rotation
        }, tweenInfo)
    end
end

local function _connectRaise(cards: {CanvasGroup}, card: CanvasGroup)
    local count = 0
	local threshHold = 2
	local clickTime = 0.3

    local cardButton = card.CardButton :: TextButton
    cardButton.MouseButton1Click:Connect(function()
        count += 1
		local isRaised = card:GetAttribute("IsRaised")

		if count % threshHold == 0 and isRaised == false then
            _raiseCard(card)
            CardRaised:Fire(card)
		elseif isRaised == true then
            _releaseCard(card)
            CardReleased:Fire(card)
		end
		task.wait(clickTime)
		count -= 1
    end)

end

function prepareConnections(cards: {CanvasGroup}, card: CanvasGroup)
    _connectRaise(cards, card)
end
_connectRaise()