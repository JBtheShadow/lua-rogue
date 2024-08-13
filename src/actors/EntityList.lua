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

function EntityList:append(entity)
    table.insert(self.entities, entity)
    if entity.fighter then
        table.insert(self.queue, { entity = entity, points = 0 })
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
        for _, item in self.queue do
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

return EntityList