local EntityList = { entities, queue }

function EntityList:new()
    local obj = setmetatable({}, {__index = self})
    obj.entities = {}
    obj.queue = {}
    return obj
end

function EntityList:indexOf(entity)
    for i, item in ipairs(self.entities) do
        if entity == item then
            return i
        end
    end
    return nil
end

function EntityList:atIndex(index)
    return self.entities[index]
end

function EntityList:append(entity, points)
    table.insert(self.entities, entity)
    if entity.fighter then
        table.insert(self.queue, { entity = entity, points = points or 0 })
    end
end

function EntityList:dequeue(entity)
    local i = 1
    while i <= #self.queue do
        if self.queue[i].entity == entity then
            table.remove(self.queue, i)
        else
            i = i + 1
        end
    end
end

function EntityList:remove(entity)
    if self:indexOf(entity) then
        self:dequeue(entity)
        local i = 1
        while i <= #self.entities do
            if self.entities[i] == entity then
                table.remove(self.entities, i)
            else
                i = i + 1
            end
        end
    end
end

function EntityList:getReady()
    local entities = {}
    local ready = false

    while not ready do
        for _, item in ipairs(self.queue) do
            if item.points >= 100 then
                ready = true
                item.points = 0
                table.insert(entities, item.entity)
            elseif item.entity and item.entity.fighter and item.entity.fighter:speed() then
                item.points = item.points + item.entity.fighter:speed()
            end
        end
    end

    return entities
end

function EntityList:getPoints(entity)
    if not entity.fighter then
        return nil
    end
    for _, e in ipairs(self.queue) do
        if e.entity == entity then
            return e.points
        end
    end
    return nil
end

function EntityList:toSaveData()
    local data = {}
    for _, entity in ipairs(self.entities) do
        local saveEntity = entity:toSaveData()
        local points = self:getPoints(entity)
        if points ~= nil then
            saveEntity.queuePoints = points
        end
        table.insert(data, saveEntity)
    end
    return data
end

function EntityList:fromSaveData(data)
    local list = EntityList:new()
    for _, value in ipairs(data) do
        list:append(Entity:fromSaveData(value), value.queuePoints)
    end
    return list
end

return EntityList