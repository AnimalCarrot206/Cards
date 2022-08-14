--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local GoodSignal = require(game.ReplicatedStorage.Shared.GoodSignal)

local Balance = Class:extend()

function Balance:new()
	self._capital = 0
	self.Changed = GoodSignal.new()
end

function Balance:destroy()
	self.Changed:Destroy()
	self.Changed = nil
	-- Просто удаляем все из таблички,
	-- не думаю что это необходимо,
	-- но подстраховаться стоит
	table.clear(self)
	self = nil
end

function Balance:get(): number
	return self._capital :: number
end

--Складывает _capital с numberToAdd
-- увеличивая _capital, если numberToAdd > 0,
-- уменьшая _capital если numberToAdd < 0
function Balance:add(numberToAdd: number)
	self._capital += numberToAdd
	self.Changed:Fire(self._capital)
end

return Balance