local sits: {{next: number,  previous: number, value: number}} = {
    [1] = {next = 2, previous = 3, value = 1},
    [2] = {next = 4, previous = 1, value = 2},
    [3] = {next = 1, previous = 5, value = 3},
    [4] = {next = 6, previous = 2, value = 4},
    [5] = {next = 3, previous = 7, value = 5},
    [6] = {next = 8, previous = 4, value = 6},
    [7] = {next = 5, previous = 8, value = 7},
    [8] = {next = 7, previous = 6, value = 8},
}
--[=[
            1
        2       3
    4               5
        6       7
            8
]=]
local calculateRange = function(playerASitPlace: number, playerBSitPlace: number)
    if playerASitPlace + playerBSitPlace == 9  then
        return 4
    end

    local current = sits[playerASitPlace]
    local i = 0
    
    local isLeftSideCycle = true
    if playerBSitPlace % 2 ~= 0 then
        isLeftSideCycle = false
    end

    while true do
        if isLeftSideCycle == true then
            current = sits[current.next]
        elseif isLeftSideCycle == false then
            current = sits[current.previous]
        end
        
        i = i + 1
        
        if current.value == playerBSitPlace then
            return i
        end
    end
end

return calculateRange