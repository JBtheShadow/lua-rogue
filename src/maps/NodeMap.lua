require "utils.stringUtils"

local Node = require "maps.Node"
local Tile = require "maps.Tile"

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

function NodeMap:toSaveData()
    local data = {
        map = {},
        defaultValue = self.defaultValue
    }
    for key, value in pairs(self.map) do
        data.map[key] = value:toSaveData()
    end
    return data
end

function NodeMap:fromSaveData(data)
    local map = NodeMap:new(data.defaultValue)
    for key, value in pairs(data.map) do
        local node = Node:fromId(key)
        map:set(node, Tile:fromSaveData(value))
    end
end

return NodeMap