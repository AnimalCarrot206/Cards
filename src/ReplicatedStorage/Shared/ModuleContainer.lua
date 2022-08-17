
local RunService = game:GetService("RunService")

local Class = require(game.ReplicatedStorage.Shared.Class)

local ModuleContainer = Class:extend()

local ERROR_NOT_FOUND = "There's no class: %s"
local ERROR_WRONG_TYPE = "Class: %s has wrong script type"
local ERROR_NO_RETURN_MODULE = "Module %s doen't return anything"

local SERVER_SEARCH_CONTAINER = game.ServerScriptService.Server
local CLIENT_SEARCH_CONTAINER = game.ReplicatedStorage.Client

function ModuleContainer:getModule(className: string)
    local searchContainer

    if RunService:IsServer() then
        searchContainer = SERVER_SEARCH_CONTAINER
    elseif RunService:IsClient() then
        searchContainer = CLIENT_SEARCH_CONTAINER
    end
    
    local module = game.ServerScriptService.Server:FindFirstChild(className) :: ModuleScript

    assert(module ~= nil, ERROR_NOT_FOUND)
    assert(module:IsA("ModuleScript"), ERROR_WRONG_TYPE)

    local class = require(module)

    assert(class ~= nil, ERROR_NO_RETURN_MODULE)

    return class
end

return ModuleContainer