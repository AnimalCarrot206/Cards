--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local CardAction = Class:extend()

function CardAction:new(card)
    self._executableCard = card
    self._isActivated = false
    self._isCancelled = false

    self.Activated = GoodSignal.new()
    self.Cancelled = GoodSignal.new()
end
--[=[
    Destroys CardAction and Disconnec all listeners from it's events
]=]
function CardAction:destroy()
    self._executableCard = nil
    table.clear(self)
    self = nil

    self.Activated:Destroy()
    self.Cancelled:Destroy()
    self.Activated = nil
    self.Cancelled = nil
end
--[=[
    Activates action and fires Activated event
]=]
function CardAction:activate()
    if self._isCancelled == true then
        return
    end

    self._isActivated = true
    self.Activated:Fire()
end
--[=[
    Cancels action and fires Cancel event
]=]
function CardAction:cancel()
    if self._isActivated == true then
        return
    end

    self._isCancelled = true
    self.Cancelled:Fire()
end
--[=[
    Returns executableCard
]=]
function CardAction:getExecutableCard()
    return self._executableCard
end

return CardAction