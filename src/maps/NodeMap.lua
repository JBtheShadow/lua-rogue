local Node = require "maps/Node"

local NodeMap = { map, defaultValue }

function NodeMap:new(defaultValue)
    local obj = setmetatable({}, {__index = self})
    obj.map = {}
    obj.defaultValue = defaultValue
    return obj
end

function NodeMap:set(node, value)
    self.map[node.id] = value
end

function NodeMap:get(node)
    return self.map[node.id] or defaultValue
end

function NodeMap:getById(id)
    return self.map[id] or defaultValue
end

function NodeMap:setNode(sourceNode, targetNode)
    self.map[sourceNode.id] = targetNode.id
end

function NodeMap:getNode(sourceNode)
    local id = self.map[sourceNode.id]
    if id == nil then
        return nil
    end
    return Node:fromId(id)
end

function NodeMap:pathTo(current)
    local totalPath = { current }
    while self:getNode(current) ~= nil do
        current = self:getNode(current)
        table.insert(totalPath, 1, current)
    end
    return totalPath
end

return NodeMap