
local Class = require(game.ReplicatedStorage.Shared.Class)

local List = Class:extend()

function List:new()
    self.first = 0
    self.last = -1

    self.container = {}
end

function List:pushleft(value)
    local first = self.first - 1
    self.first = first
    self.container[first] = value
end
  
function List:pushright(value)
    local last = self.last + 1
    self.last = last
    self.container[last] = value
end
  
function List:popleft()
    local first = self.first

    if first > self.last then 
        error("list is empty") 
    end

    local value = self.container[first]
    self.container[first] = nil        -- to allow garbage collection
    self.first = first + 1
    return value
end
  
function List:popright()
    local last = self.last

    if self.first > last then 
        error("list is empty") 
    end

    local value = self.container[last]
    self.container[last] = nil         -- to allow garbage collection
    self.last = last - 1
    return value
end

return List