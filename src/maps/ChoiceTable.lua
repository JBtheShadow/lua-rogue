local ChoiceTable = { table }

function ChoiceTable:new(choiceList)
    local obj = setmetatable({}, {__index = self})
    obj.table = {}

    local val = 0
    for choice, chance in pairs(choiceList) do
        if chance > 0 then
            table.insert(obj.table, { choice = choice, min = val + 1, max = val + chance })
            val = val + chance
        end
    end
    return obj
end

function ChoiceTable:getChoice()
    if not #self.table then
        return nil
    end
    local val = math.random(1, self.table[#self.table].max)
    for _, chance in pairs(self.table) do
        if chance.min <= val and val <= chance.max then
            return chance.choice
        end
    end
    return nil
end

return ChoiceTable