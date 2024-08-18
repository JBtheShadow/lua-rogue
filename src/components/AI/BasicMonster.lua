local Message = require "messages.Message"

local BasicMonster = { owner }

function BasicMonster:new()
    local obj = setmetatable({}, {__index = self})
    self.owner = nil
    return obj
end

function BasicMonster:takeTurn(target, fovMap, gameMap, entities)
    local results = {}

    local monster = self.owner
    if fovMap:isInFieldOfView(monster.x, monster.y) then
        if monster:distanceTo(target) >= 2 then
            monster:moveAround(target, entities, gameMap)
        elseif target.fighter.hp > 0 then
            for _, result in monster.fighter.attack(target) do
                table.insert(results, result)
            end
        end
    end

    return results
end

function BasicMonster:toSaveData()
    return { type = "basicMonster" }
end

function BasicMonster:fromSaveData(data)
    return BasicMonster:new()
end

return BasicMonster