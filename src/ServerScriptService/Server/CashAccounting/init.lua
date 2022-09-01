--!nonstrict
local DataStoreService = game:GetService("DataStoreService")
local MoneyDataStore = DataStoreService:GetDataStore("PlayerStats", "MoneyValue")

local Class = require(game.ReplicatedStorage.Shared.Class)
local Balance = require(script.Parent.Balance)

-- Можно сказать обертка баланса, но более прокаченная
-- Напоминает паттерн фабрика
local CashAccouting = Class:extend()

local playersBalances = {}
-- Создаем баланс, возвращаем его и запихиваем в список 
-- балансов игроков, для дальнейшего использования
function CashAccouting:StartAccounting(player: Player, valueToAdd: number | nil)
	local createdBalance = Balance()
	createdBalance:add(valueToAdd or 0)
	playersBalances[player.Name] = createdBalance
	-- Аттрибут используется для связи с клиентом, экономим интернет 0_0
	-- т.к вызовы удаленного эвента более дорогая операция
	createdBalance.Changed:Connect(function(value)
		player:SetAttribute("Money", value)
	end)

	return createdBalance
end
-- Удаляем баланс из списка и уничтожаем его
function CashAccouting:StopAccouting(player: Player)
	local foundBalance = playersBalances[player.Name]
	if foundBalance then
		foundBalance:Destroy()
	end
	playersBalances[player.Name] = nil
end
-- Получаем баланс по имени игрока и возвращаем его
-- Если его нет в списке будет возвращен nil
function CashAccouting:GetPlayerBalance(player: Player): any
	return playersBalances[player.Name]
end
-- Метод для DataStore, загружает баланс
function CashAccouting:LoadCurrency(player: Player)
	local success, currentMoneyValue = pcall(function()
		return MoneyDataStore:GetAsync(player.UserId)
	end)
	
	if success and currentMoneyValue ~= nil then
		return CashAccouting:StartAccounting(player, currentMoneyValue)
	end
end
-- Метод для DataStore, сохраняет баланс
function CashAccouting:SaveCurrency(player: Player)
	local balance = CashAccouting:GetPlayerBalance(player)
	assert(balance, string.format("Player: %s doesn't have balance!", player.Name))
	
	local moneyCount = balance:GetCapital()
	local success, errorMessage = pcall(function()
		MoneyDataStore:SetAsync(player.UserId, moneyCount)
	end)
	
	CashAccouting:StopAccouting(player)
	--if success then
	--	print("Success saved!")
	--else
	--	warn("Whoops! Didn't saved!")
	--end
end

return CashAccouting