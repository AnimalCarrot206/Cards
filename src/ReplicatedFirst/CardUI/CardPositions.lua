--!strict
local Animate = require(game.ReplicatedStorage.Shared.Animate)

local CENTER_POSITION = UDim2.fromScale(0.5, 0.5)

local START_POSITION = UDim2.fromScale(0, 0.6)
local END_POSITION = UDim2.fromScale(1, 0.5)

local MIN_ROTATION = -10
local MAX_ROTATION = 10

function _getOrderPositions(cards: {GuiObject}): {UDim2}
    local length = #cards
    local stepX = (END_POSITION.X.Scale - START_POSITION.X.Scale) / (length + 1)
    local stepY = (END_POSITION.Y.Scale - START_POSITION.Y.Scale) / (length + 1)

    local positions = {}
    local currentStep = 1
    for _, card in ipairs(cards) do
        if card:GetAttribute("IsRaised") == true then continue end

        local position = UDim2.fromScale(
            START_POSITION.X.Scale + stepX * currentStep,
            START_POSITION.Y.Scale + stepY * currentStep
        )
        positions[currentStep] = position
        currentStep += 1
    end
    return positions
end

function _getCardOrderPosition(cards: {GuiObject}, card: GuiObject): UDim2
    if card:GetAttribute("IsRaised") == true then
        local message = debug.traceback(
            string.format("Card %s mustn't be raised before positioning", card:GetAttribute("CardName"))
        )
        warn(message)
        return UDim2.new()
    end
    local positions = _getOrderPositions(cards)
    local foundIndex = table.find(cards, card)
    if not foundIndex then
        local message = debug.traceback(
            string.format("Card %s isn't in deck", card:GetAttribute("CardName"))
        )
        warn(message)
        return UDim2.new()
    end
    return positions[foundIndex]
end

function _getOrderRotations(cards: {GuiObject}): {number}
    local length = #cards
    local rotationStep = (math.abs(MIN_ROTATION) + MAX_ROTATION) / (length + 1)

    local rotations = {}
    local currentStep = 1
    for _, card in ipairs(cards) do
        if card:GetAttribute("IsRaised") == true then continue end
        local rotation = rotationStep * currentStep
        rotations[currentStep] = rotation
        currentStep += 1
    end
    return rotations
end

function _getCardOrderRotation(cards: {GuiObject}, card: GuiObject): number
    if card:GetAttribute("IsRaised") == true then
        local message = debug.traceback(
            string.format("Card %s mustn't be raised before rotating", card:GetAttribute("CardName"))
        )
        warn(message)
        return UDim2.new()
    end
    local rotations = _getOrderRotations(cards)
    local foundIndex = table.find(cards, card)
    if not foundIndex then
        local message = debug.traceback(
            string.format("Card %s isn't in deck", card:GetAttribute("CardName"))
        )
        warn(message)
        return UDim2.new()
    end
    return rotations[foundIndex]
end

local tweenInfo =
    TweenInfo.new(0.15, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

function _putCardsInOrder(cards: {GuiObject})
    local positions = _getOrderPositions(cards)
    local rotations = _getOrderRotations(cards)

    local currentStep = 1
    for _, card in ipairs(cards) do
        if card:GetAttribute("IsRaised") == true then continue end

        Animate:animate(card,{
            Position = positions[currentStep],
            Rotation = rotations[currentStep]
        }, tweenInfo)

        currentStep += 1
    end
end

return {
    getOrderPositions = _getOrderPositions,
    getCardOrderPosition = _getCardOrderPosition,

    getOrderRotations =  _getOrderRotations,
    getCardOrderRotation =  _getCardOrderRotation,

    setPositionsInOrder = _putCardsInOrder,
}