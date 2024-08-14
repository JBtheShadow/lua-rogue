local LevelTable = { table }

function LevelTable:new(chancePairs)
    local obj = setmetatable({}, {__index = self})
    obj.table = {}
    for _, pair in ipairs(chancePairs) do
        obj.table[pair[1]] = pair[2]
    end
    return obj
end

function LevelTable:getChanceByLevel(level)
    for i=level,1,-1 do
        local chance = self.table[i]
        if chance ~= nil then
            return chance
        end
    end
    return 0
end

return LevelTable