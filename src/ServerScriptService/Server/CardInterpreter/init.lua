--!strict
local Class = require(game.ReplicatedStorage.Shared.Class)
local Promise = require(game.ReplicatedStorage.Shared.Promise)
local Remotes = require(game.ReplicatedStorage.Shared.Remotes)
local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)

local CardInput = require(game.ServerScriptService.Server.CardInput)
local TurnManager = require(game.ServerScriptService.Server.TurnManager)
local CardDeckManager = require(game.ServerScriptService.Server.CardDeckManager)

local DEFAULT_TIMEOUT = 20

local CardInterpreter = Class:extend()

local isPassSanityChecks do
    
    isPassSanityChecks = function(player: Player, cardInfo)
        
    end
end

local function _getPlayerCard(player: Player, cardId: string)
    local cardDeck = CardDeckManager:getPlayerDeck(player)
    local card = cardDeck:getCard(cardId)
    return card
end

local function _getUseInfo(player: Player, cardInfo, card)
    local cardUseType = card:getUseType()
    local info = {}
    
    info.cardOwner = player
    info.cardOwnerDeck = CardDeckManager:getPlayerDeck(player)

    if cardUseType == CustomEnum.CardIdLiteral.OnPlayerUseCard.Name then
        info.defender = cardInfo.defender
        info.defenderDeck = CardDeckManager:getPlayerDeck(info.defender)

    elseif cardUseType == CustomEnum.CardIdLiteral.CouplePlayersUseCard.Name then
        local allPlayers = game.Players:GetPlayers()
        local foundPlayerIndex = table.find(allPlayers, player)
        table.remove(allPlayers, foundPlayerIndex)
        info.players = allPlayers
    end
    return info
end

local function _getUsedCard(player: Player)
    return Promise.new(function(resolve, reject, onCancel)
        --Ждем до использования карты пользователем,
        --а уже затем запрашиваем информацию.
        --Позволяет делать проверки на нескольких этапах
        CardInput:createRequest(player):Wait()
        --Ждет до таймаута пока игрок предоставит cardInfo
        -- что позволяет защититься от некорректных данных
        -- и злоумышленников без остановки* процесса игры
        --*!останока будет до того момента пока не кончится таймер!
        while true do
            local cardInfo = CardInput:createUseInfoRequest(player):Wait()
            local isFair = isPassSanityChecks(player, cardInfo)
            if isFair == false then
                Remotes.CardActivationFailed:FireClient(player)
                continue
            end
            resolve(_getPlayerCard(player, cardInfo.id))
        end
    end)
end

function CardInterpreter:startInterpreting(player: Player)
    _getUsedCard(player)
    :timeout(DEFAULT_TIMEOUT)
    :andThen(function(card)
        local cardUseType = card:getUseType()
        local useInfo = _getUseInfo(player, card)


        if cardUseType == CustomEnum.CardIdLiteral.OnPlayerUseCard.Name then
            local alternate = card:getAlternate()
            if alternate ~= nil then
                local defenderUsedCard = 
                _getUsedCard(useInfo.defender)
                :timeout(DEFAULT_TIMEOUT)
                :andThen(function(card)
                    if card:getName() == alternate then
                        alternate:use()
                    end
                    card:use(useInfo)
                end)
                :catch(function()
                        
                end)
                :cancel()
            else
                card:use(useInfo)
            end
            
            return
        end
        
    end)
    :catch(function()
        
    end)
    :cancel()
end

function CardInterpreter:stopInterpreting()
    
end

return CardInterpreter