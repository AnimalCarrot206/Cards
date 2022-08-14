--!strict
local Balance = require(script.Parent)

local createdBalance = Balance()
assert(createdBalance:get() == 0)
----------------------------------------
createdBalance:add(100)
----------------------------------------
assert(createdBalance:get() == 100)
createdBalance:add(-10)
assert(createdBalance:get() == 90)
----------------------------------------
createdBalance:destroy()
print(createdBalance)
----------------------------------------
createdBalance = nil