local Node = { id, x, y }

function Node:new(x, y)
    local obj = setmetatable({}, {__index = self})
    obj.id = string.format("%d,%d", x, y)
    obj.x = x
    obj.y = y
    return obj
end

function Node:fromId(id)
    local obj = setmetatable({}, {__index = self})
    local parts = string.gmatch(id, ".")
    obj.id = id
    obj.x = tonumber(parts[0])
    obj.y = tonumber(parts[1])
    return obj
end

function Node:is(node)
    return self.id == node.id
end

function Node:gridDistanceTo(node)
    local dx = math.abs(self.x - node.x)
    local dy = math.abs(self.y - node.y)
    local diagonalLength = math.min(dx, dy)
    local cardinalLength = math.max(dx, dy) - diagonalLength
    return cardinalLength + diagonalLength * 1.41
end

function Node:createNeighbors(node)
    return {
        Node:new(node.x - 1, node.y - 1),
        Node:new(node.x, node.y - 1),
        Node:new(node.x + 1, node.y - 1),
        Node:new(node.x - 1, node.y),
        Node:new(node.x + 1, node.y),
        Node:new(node.x - 1, node.y + 1),
        Node:new(node.x, node.y + 1),
        Node:new(node.x + 1, node.y + 1),
    }
end

function Node:nextTowards(node)
    if self:is(node) then
        return nil
    end

    local dx, dy = 0, 0
    if self.x < node.x then
        dx = 1
    elseif self.x > node.x then
        dx = -1
    end

    if self.y < node.y then
        dy = 1
    elseif self.y > node.y then
        dy = -1
    end

    return Node:new(node.x + dx, node.y + dy)
end

function Node:pathTo(node)
    local current = Node:new(self.x, self.y)
    local totalPath = { current }
    while not current:is(node) do
        current = self:nextTowards(node)
        table.insert(totalPath, current)
    end
    return totalPath
end

return Node