local Node = require "maps/Node"
local NodeList = require "maps/NodeList"
local NodeMap = require "maps/NodeMap"

local CollisionMap = { width, height, map }

function CollisionMap:new(width, height)
    local obj = setmetatable({}, {__index = self})
    obj.width = width
    obj.height = height
    obj.map = NodeMap:new()
    for y = 1, height do
        for x = 1, width do
            obj:setProps(x, y, false, false)
        end
    end
    return obj
end

function CollisionMap:setProps(x, y, blockSight, blocked)
    local node = Node:new(x, y)
    self.map:set(node, { blockSight = blockSight, blocked = blocked })
end

function CollisionMap:getNeighbors(node)
    local neighbors = {}
    for _, candidate in node:createNeighbors() do
        local tile = self.map:get(candidate)
        if tile and not tile.blocked then
            table.insert(neighbors, candidate)
        end
    end
    return neighbors
end

function CollisionMap:findPath(source, target, maxCost)
    local initialCost = source:gridDistanceTo(target)
    if initialCost > maxCost then
        return nil
    end

    local inf = math.huge
    
    local openSet = NodeList:new { source }
    
    local cameFrom = NodeMap:new()
    
    local gScore = NodeMap:new(inf)
    gScore:set(source, 0)

    local fScore = NodeMap:new(inf)
    fScore:set(source, initialCost)

    while not openSet:isEmpty() do
        local current = openSet:popLowestScore(fScore)
        if current:is(target) then
            return cameFrom:pathTo(current)
        end

        local currentScore = gScore:get(current)
        for _, neighbor in ipairs(self:getNeigbors(current)) do
            local neighborScore = currentScore + current:gridDistanceTo(neighbor)
            local neighborToGoal = neighborScore + neighbor:gridDistanceTo(target)
            if neighborScore < gScore:get(neighbor) and neighborToGoal <= maxCost then
                cameFrom:setNode(neighbor, current)
                gScore:set(neighbor, neighborScore)
                fScore:set(neighbor, neighborToGoal)
                openSet:add(neighbor)
            end
        end
    end

    return nil
end

return CollisionMap