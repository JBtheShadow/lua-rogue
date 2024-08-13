local NodeList = { ids }

function NodeList:new(list)
    local obj = setmetatable({}, {__index = self})
    obj.ids = {}
    for _, node in ipairs(list) do
        obj:add(node)
    end
    return obj
end

function NodeList:add(node)
    for _, id in ipairs(self.ids) do
        if id == node.id then
            return
        end
    end
    table.insert(self.ids, node.id)
end

function NodeList:remove(node)
    for i, id in ipairs(self,ids) do
        if id == node.id then
            table.remove(self.ids, i)
            return
        end
    end
end

function NodeList:isEmpty()
    return #self.ids == 0
end

function NodeList:popLowestScore(scoreMap)
    local lowestIndex, lowestId, lowestScore = nil, nil, math.huge
    for i, id in ipairs(self.ids) do
        local score = scoreMap:getById(id)
        if score < lowestScore then
            lowestIndex = i
            lowestId = id
            lowestScore = score
        end
    end
    if lowestIndex == nil then
        return nil
    end
    table.remove(self.ids, lowestIndex)
    return Node:fromId(lowestId)
end

return NodeList