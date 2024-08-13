local RenderOrder = require "enums/RenderOrder"
local Item = require "components/Item"

local Entity = { x, y, char, color, name, blocks, renderOrder, fighter, ai, item, inventory, stairs, level, equipment, equippable }

function Entity:new(args)
    if type(args.x) ~= "number" then
        error("no x")
    elseif type(args.y) ~= "number" then
        error("no y")
    elseif type(args.char) ~= "string" then
        error("no char")
    elseif type(args.color) == "nil" then
        error("no color")
    elseif type(args.name) ~= "string" then
        error("no name")
    end
    
    local obj = setmetatable({}, {__index = self})
    obj.x = args.x
    obj.y = args.y
    obj.char = args.char
    obj.color = args.color
    obj.name = args.name
    obj.blocks = args.blocks or false
    obj.renderOrder = args.renderOrder or RenderOrder.CORPSE
    obj.fighter = args.fighter
    if obj.fighter then
        obj.fighter.owner = obj
    end
    obj.ai = args.ai
    if obj.ai then
        obj.ai.owner = obj
    end
    obj.item = args.item
    if obj.item then
        obj.item.owner = obj
    end
    obj.inventory = args.inventory
    if obj.inventory then
        obj.inventory.owner = obj
    end
    obj.stairs = args.stairs
    if obj.stairs then
        obj.stairs.owner = obj
    end
    obj.level = args.level
    if obj.level then
        obj.level.owner = obj
    end
    obj.equipment = args.equipment
    if obj.equipment then
        obj.equipment.owner = obj
    end
    obj.equippable = args.equippable
    if obj.equippable then
        obj.equippable.owner = obj

        if not obj.item then
            local item = Item:new()
            obj.item = item
            obj.item.owner = obj
        end
    end
    return obj
end

function Entity:move(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Entity:moveTowards(targetX, targetY, gameMap, entities)
    local dx = targetX - self.x
    local dy = targetY - self.y
    local distance = (dx^2 + dy^2)^0.5

    dx = math.floor(dx / distance + 0.5)
    dy = math.floor(dy / distance + 0.5)

    if not gameMap:isBlocked(self.x + dx, self.y + dy) and not self.getBlockingEntityAtLocation(entities, self.x + dx, self.y + dy) then
        self:move(dx, dy)
    end
end

function Entity:distance(x, y)
    return ((x - self.x)^2 + (y - self.y)^2)^0.5
end

-- Might consider looking for an A* lib, unless you *really* wanna implement something yourself

return Entity