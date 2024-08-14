local ChoiceTable = { table }

function ChoiceTable:new(choiceList)
    local obj = setmetatable({}, {__index = self})
    obj.table = {}

    local val = 0
    for choice, chance in pairs(choiceList) do
        if chance > 0 then
            obj.table[choice] = { min = val + 1, max = val + chance }
            val = val + chance
        end
    end
    return obj
end

function ChoiceTable:getChoice()
    local val = math.random(1, self.table[#self.table].max)
    for choice, chance in pairs(self.table) do
        if chance.min <= val and val <= chance.max then
            return choice
        end
    end
    return nil
end

return ChoiceTable