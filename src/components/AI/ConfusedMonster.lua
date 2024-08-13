local Message = require "messages/Message"

local ConfusedMonster = { owner }

function ConfusedMonster:new(previousAI, numberOfTurns)
    local obj = setmetatable({}, {__index = self})
    self.previousAI = previousAI
    self.numberOfTurns = numberOfTurns or 10
    self.owner = nil
    return obj
end

function ConfusedMonster:takeTurn(_, _, gameMap, entities)
    local results = {}

    if self.numberOfTurns > 0 then
        local randomX = self.owner.x + math.random(-1, 1)
        local randomY = self.owner.y + math.random(-1, 1)

        if randomX ~= self.owner.x or randomY ~= self.owner.y then
            self.owner:moveTowards({ x = randomX, y = randomY }, gameMap, entities)
        end

        self.numberOfTurns = self.numberOfTurns - 1
    else
        self.owner.ai = self.previousAI
        table.insert(results, { message = Message:new(string.format("The %s is no longer confused!", self.owner.name), "red") })
    end

    return results
end

return ConfusedMonster