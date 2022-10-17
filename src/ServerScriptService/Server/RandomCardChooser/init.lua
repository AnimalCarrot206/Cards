local CustomEnum = require(game.ReplicatedStorage.Shared.CustomEnum)



local _getRandomCard do
    local isReverseCreated = false
    local MAX_CHANCE_NUMBER = 100

    local chancesForType = {
        [1] = {name = "BonusCard", percent = 10},
        [2] = {name = "WeaponCard", percent = 15},
        [3] = {name = "GameCard", percent = 75},
    }

    local chancesForCards = {
        ["BonusCard"] = {
            [1] = {name = "Other", percent = 100}
        },
        ["WeaponCard"] = {
            [1] = {name = "Other", percent = 100}
        },
        ["GameCard"] = {
            [1] = {name = "Reverse", percent = 1},
            [2] = {name = "Mixed", percent = 99, mixins = {
                "Bang!!", "Miss", "Other"
            }}
        }
    }

    local function _getRandomOther(type: string): string
        local enumArray = CustomEnum[type]:GetEnumItems()
		local randomNumber = Random.new():NextInteger(1, #enumArray)
		
		if enumArray[randomNumber].Name == "Reverse" then
			return enumArray[randomNumber + 1].Name
		end

        return enumArray[randomNumber].Name :: string
    end

    local function _getRandomMixin(type: string, mixins: {string})
		local randomNumber = Random.new():NextInteger(1, #mixins)
        local mixin = mixins[randomNumber] :: string
        if mixin == "Other" then
            return _getRandomOther(type)
        end
        return mixin
    end

    local function _getRandomType()
		local randomNumber = Random.new():NextInteger(1, MAX_CHANCE_NUMBER)
        for index, chanceTable in ipairs(chancesForType) do
            if randomNumber <= chanceTable.percent then
                return chanceTable.name :: string
            end
            randomNumber -= chanceTable.percent
        end
    end

    _getRandomCard = function()
        local type = _getRandomType()
        local foundTable = chancesForCards[type]
		local randomNumber = Random.new():NextInteger(1, MAX_CHANCE_NUMBER)
		
        for index, chanceInfo in ipairs(foundTable) do
            if chanceInfo.name == "Other" and chanceInfo.percent == MAX_CHANCE_NUMBER then
                return _getRandomOther(type)
            end
            if chanceInfo.name == "Mixed" and randomNumber <= chanceInfo.percent then
                return _getRandomMixin(type, chanceInfo.mixins)
            end
			if randomNumber <= chanceInfo.percent then
				local card = CustomEnum[type][chanceInfo.name].Name
				
                if chanceInfo.name == "Reverse" then
					table.remove(foundTable, index)
					foundTable[1].percent = 100
				end
                return card
            end
            randomNumber -= chanceInfo.percent
        end
    end
end

return _getRandomCard