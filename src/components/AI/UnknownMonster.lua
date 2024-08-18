local BasicMonster = require "components.ai.BasicMonster"
local ConfusedMonster = require "components.ai.ConfusedMonster"

local UnknownMonster = {}

function UnknownMonster:fromSaveData(data)
    if data.type == "basicMonster" then
        return BasicMonster:fromSaveData(data)
    elseif data.type == "confusedMonster" then
        data.previousAI = UnknownMonster:fromSaveData(data.previousAI)
        return ConfusedMonster:fromSaveData(data)
    end
    return nil
end

return UnknownMonster