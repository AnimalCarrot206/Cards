local RBX_ENUM = Enum

local newEnum = require(script.Enum).new

--[=[
    @class Enums
    Entry-point for the Enum library.
]=]
local Enums = {}
local meta = {}

local methods = {}
local enums = {}

--[=[
    @within Enums
    @return Enum
    Creates a new Enum. Overwrites existing Enums including Roblox Enums.
]=]
function methods.new(enumName, enumItemsList)
    -- If an enum with the same name is used it is overwritten
    local enum = newEnum(enumName, enumItemsList)
    enums[enumName] = enum
    return enum
end

--[=[
    @within Enums
    @return Enum
    Returns the standard Roblox Enum table defined globally. This is useful for
    when this library is imported under the name `Enum`.
]=]
function methods:GetStandardEnums()
    return RBX_ENUM
end

--[=[
    @within Enums
    @param enumName string -- The name of the Enum.
    @param enumValue any -- The value of the EnumItem.
    @return EnumItem
    Given an Enum's name and the EnumItem's value, returns the EnumItem.
]=]
function methods:FromValue(enumName, enumValue)
    for _,enumItem in ipairs(self[enumName]:GetEnumItems()) do
        if enumItem.Value == enumValue then
            return enumItem
        end
    end
end

--[=[
    @within Enums
    @param enumName string -- The name of the Enum.
    @return Enum
    Safe way of checking if an Enum exists and returns it if it does.
]=]
function methods:Find(enumName)
    local success, enum = pcall(function()
        return enums[enumName] or RBX_ENUM[enumName]
    end)

    if success then
        return enum
    end

    return nil
end

meta.__metatable = "The metatable is locked"
meta.__tostring = function()
    return "Enums"
end

function meta.__index(_, enumName)
    return methods[enumName] or enums[enumName] or RBX_ENUM[enumName]
end

function meta.__newindex(_, i)
    error(i.. " cannot be assigned to", 2)
end

setmetatable(Enums, meta)

Enums.new("Ability", {
    ["Stained"] = 0,
    ["Compensation"] = 1,
    ["Sharp"] = 2,
    ["Dealer"] = 3,
    ["Capacious"] = 4,
    ["Necromancer"] = 5,
    ["Bounty hunter"] = 6,
    ["Barman"] = 7,
    ["Getting along"] = 8,
    ["Trickster"] = 9,
    ["Black mark"] = 10,
    ["Wait what"] = 11,
    ["Medium"] = 12,
    ["Hermit"] = 13,
    ["Die hard"] = 14,
})

Enums.new("Cards", {
    ["Bang!!"] = 0,
    ["Miss"] = 1,
    ["Ambush!"] = 2,
    ["Lemonade"] = 3,
    ["Drinks on me"] = 4,
    ["Present"] = 5,
    ["Cage"] = 6,
    ["Blackmail"] = 7,
    ["Thief"] = 8,
    ["Reverse"] = 9,
    ["Exchange"] = 10,
    ["Duel"] = 11,
    ["Move"] = 12,
    ["Mayor's pardon"] = 13,

    ["Shawed off"] = 14,
    ["Judi"] = 15,
    ["Navy revolver"] = 16,
    ["Winchester"] = 17,

    ["Scope"] = 18,
    ["Brand stool"] = 19,
    ["Apple juice"] = 20,
})

Enums.new("Roles", {
    ["Sheriff"] = 0,
    ["Plague doctor"] = 1,
    ["Cowboy"] = 2,
    ["Bandit"] = 3,
    ["Psycho"] = 4
})

Enums.new("Guns", {
    ["Rusty revolver"] = 0,
    ["Shawed off"] = 1,
    ["Judi"] = 2,
    ["Navy revolver"] = 3,
    ["Winchester"] = 4,
})

Enums.new("ShootType", {
    Hit = 0,
    Miss = 1,
    Ambush = 2,
    Duel = 3,
})

Enums.new("TurnStatus", {
    Created = 0,
    Begin = 1,
    End = 2,
})

Enums.new("CardIdLiteral", {
    OnPlayerUseCard = 10,
    SelfUseCard = 20,
    CouplePlayersUseCard = 30,
})

return Enums