local RenderOrder = require "enums.RenderOrder"
local Item = require "components.Item"
local CollisionMap = require "maps.CollisionMap"
local Node = require "maps.Node"

local Fighter = require "components.Fighter"
local Inventory = require "components.Inventory"
local Level = require "components.Level"
local Equipment = require "components.Equipment"
local Equippable = require "components.Equippable"
local Stairs = require "components.Stairs"

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

function Entity:moveTowards(target, gameMap, entities)
    local dx = target.x - self.x
    local dy = target.y - self.y
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

function Entity:moveAround(target, entities, gameMap)
    local fov = CollisionMap:newFromMap(gameMap)

    for _, entity in ipairs(entities) do
        if entity.blocks and entity ~= self and entity ~= target then
            fov:setProps(entity.x, entity.y, false, true)
        end
    end

    local path = fov:findPath(self, target, 25)
    if path == nil then
        self:moveTowards(target)
    else
        local nextMove = path[0]
        self.x = nextMove.x
        self.y = nextMove.y
    end
end

function Entity:distanceTo(other)
    return self:distance(other.x, other.y)
end

function Entity.getBlockingEntityAtLocation(entities, x, y)
    for _, entity in ipairs(entities) do
        if entity.blocks and entity.x == x and entity.y == y then
            return entity
        end
    end

    return nil
end

function Entity:newPlayer(x, y)
    local fighterComponent = Fighter:new { hp=100, defense=1, power=2, speed=4 }
    local inventoryComponent = Inventory:new(26)
    local levelComponent = Level:new()
    local equipmentComponent = Equipment:new()
    local player = Entity:new {
        x=x, y=y, char="@", color="white", name="Player", blocks=true, renderOrder=RenderOrder.ACTOR,
        fighter=fighterComponent, inventory=inventoryComponent, level=levelComponent,
        equipment=equipmentComponent
    }
    return player
end

function Entity:newEquipment(x, y, char, color, name, args)
    local equippableComponent = Equippable:new(args)
    local equipment = Entity:new { x=x, y=y, char=char, color=color, name=name, equippable=equippableComponent }
    return equipment
end

function Entity:newStairs(x, y, char, floor)
    local stairsComponent = Stairs:new(floor)
    local stairs = Entity:new {
        x = x, y = y, char = char, color = "white", name = "Stairs",
        renderOrder = RenderOrder.STAIRS, stairs = stairsComponent
    }
    return stairs
end

return Entity