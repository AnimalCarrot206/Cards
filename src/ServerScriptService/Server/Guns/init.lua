--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)
local Animations = require(game.ReplicatedStorage.Shared.Animations)
local PlayerStats = require(game.ReplicatedStorage.Shared.PlayerStats)

local Chairs = require(game.ServerScriptService.Server.Chairs)
local Shoots = require(script.Shoots)

local Container = Instance.new("Folder")
--[=[
    Базовый класс пушек
]=]
local Gun = Class:extend()
function Gun:new(owner: Player, name: string, range: number, model: Model)
    self._owner = owner
    self._name = name
    self._range = range
    self._model = model

    PlayerStats:setRange(owner, range)
end

function Gun:destroy()
    self._model:Destroy()
    table.clear(self)
    self = nil
end

function Gun:getRange(): number
    return self._range
end

function Gun:getName(): string
    return self._name
end

function Gun:getOwner(): Player
    return self._owner
end

function Gun:getModel(): Model
    return self._model
end

do
    local function _checkArgs(shootType, args)
        local result = true
        if 
            shootType == CustomEnum.ShootType.Hit 
            or
            shootType == CustomEnum.ShootType.Miss
            or
            shootType == CustomEnum.ShootType.Duel
        then
            local enemy = args[1]
            if not enemy then
                result = false
            end
        end
        if shootType == CustomEnum.ShootType.Ambush then
            local n = 0
            table.foreachi(args, function(i, player)
                n = i
            end)
            if n < 1 then
                result = false
            end
        end
        return result
    end
    --[=[
        Start shooting based on shootType
    ]=]
    function Gun:shoot(shootType, ...)
        local args = {...}
        assert(_checkArgs(shootType, args))

        if shootType.Hit then
            Shoots:shootWithHit(table.unpack(args))
        elseif shootType.Miss then
            Shoots:shootWithMiss(table.unpack(args))
        elseif shootType.Ambush then
            Shoots:ambush(table.unpack(args))
        elseif shootType.Duel then
            Shoots:duel(table.unpack(args))
        end
    end
end
--[=[
    Класс ржавого револьвера
]=]
local RustyRevolver = Gun:extend()
function RustyRevolver:new(owner: Player)
    local GUN_NAME = CustomEnum.Guns["Rusty revolver"].Name
    local GUN_RANGE = 1
    local GUN_MODEL = Container.RustyRevolver :: Model
    
    self.super:new(owner, GUN_NAME, GUN_RANGE, GUN_MODEL)
end
--[=[
    Класс обреза (дробовика)
]=]
local ShawedOff = Gun:extend()
function ShawedOff:new(owner: Player)
    local GUN_NAME = CustomEnum.Guns["Shawed off"].Name
    local GUN_RANGE = 2
    local GUN_MODEL = Container.ShawedOff :: Model
    
    self.super:new(owner, GUN_NAME, GUN_RANGE, GUN_MODEL)
end
--[=[
    Класс Джуди (Револьвер)
]=]
local Judi = Gun:extend()
function Judi:new(owner: Player)
    local GUN_NAME = CustomEnum.Guns["Judi"].Name
    local GUN_RANGE = 3
    local GUN_MODEL = Container.Judi :: Model
    
    self.super:new(owner, GUN_NAME, GUN_RANGE, GUN_MODEL)
end
--[=[
    Класс морского револьвера
]=]
local NavyRevolver = Gun:extend()
function NavyRevolver:new(owner: Player)
    local GUN_NAME = CustomEnum.Guns["Navy revolver"].Name
    local GUN_RANGE = 4
    local GUN_MODEL = Container.NavyRevolver :: Model
    
    self.super:new(owner, GUN_NAME, GUN_RANGE, GUN_MODEL)
end
function NavyRevolver:shoot(shootType, ...)
    local MISS_CHANCE = 30
    local randomNumber = math.round(math.random() * 100)

    if randomNumber <= MISS_CHANCE then
        self.super:shoot(CustomEnum.ShootType.Miss, ...)
        return
    end
    self.super:shoot(shootType, ...)
end
--[=[
    Класс винчестера
]=]
local Winchester = Gun:extend()
function Winchester:new(owner: Player)
    local GUN_NAME = CustomEnum.Guns["Winchester"].Name
    local GUN_RANGE = 7
    local GUN_MODEL = Container.Winchester :: Model
    
    self.super:new(owner, GUN_NAME, GUN_RANGE, GUN_MODEL)
end

return {
    ["Rusty revolver"] = RustyRevolver,
    ["Shawed off"] = ShawedOff,
    ["Judi"] = Judi,
    ["Navy revolver"] = NavyRevolver,
    ["Winchester"] = Winchester,
}