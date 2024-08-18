local RenderOrder = require "enums.RenderOrder"
local Colors = require "enums.Colors"

local CollisionMap = require "maps.CollisionMap"
local Node = require "maps.Node"

local BasicMonster = require "components.ai.BasicMonster"
local UnknownMonster = require "components.ai.UnknownMonster"
local Fighter = require "components.Fighter"
local Inventory = require "components.Inventory"
local Item = require "components.Item"
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
    elseif type(args.color) ~= "table" then
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
        elseif obj.item.owner == nil then
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
        x=x, y=y, char="@", color=Colors.WHITE, name="Player", blocks=true, renderOrder=RenderOrder.ACTOR,
        fighter=fighterComponent, inventory=inventoryComponent, level=levelComponent,
        equipment=equipmentComponent
    }
    return player
end

function Entity:newMonster(x, y, char, color, name, args)
    local fighterComponent = Fighter:new(args)
    local aiComponent = BasicMonster:new()
    local monster = Entity:new {
        x=x, y=y, char=char, color=Colors.WHITE, name=name, blocks=true,
        renderOrder=RenderOrder.ACTOR, fighter=fighterComponent, ai=aiComponent
    }
    return monster
end

function Entity:newGoldPile(x, y, amount)
    local itemComponent = Item:new { args={ canStack=true, amount=amount }}
    local item = Entity:new { x=x, y=y, char="$", color=Colors.GOLD, name="Gold Coin", renderOrder=RenderOrder.ITEM, item=itemComponent }
    return item
end

function Entity:newItem(x, y, char, color, name, args)
    local itemComponent = Item:new { onUse = args.onUse, args = args.args }
    local item = Entity:new { x=x, y=y, char=char, color=color, name=name, renderOrder=RenderOrder.ITEM, item=itemComponent }
    return item
end

function Entity:newEquipment(x, y, char, color, name, args)
    local equippableComponent = Equippable:new(args)
    local equipment = Entity:new { x=x, y=y, char=char, color=color, name=name, equippable=equippableComponent }
    return equipment
end

function Entity:newStairs(x, y, char, floor)
    local stairsComponent = Stairs:new(floor)
    local stairs = Entity:new {
        x = x, y = y, char = char, color = Colors.WHITE, name = "Stairs",
        renderOrder = RenderOrder.STAIRS, stairs = stairsComponent
    }
    return stairs
end

function Entity:toSaveData()
    local data = {}
    data.x = self.x
    data.y = self.y
    data.char = self.char
    data.color = self.color.name
    data.name = self.name
    data.blocks = self.blocks
    data.renderOrder = self.renderOrder
    if self.fighter then
        data.fighter = self.fighter:toSaveData()
    end
    if self.ai then
        data.ai = self.ai:toSaveData()
    end
    if self.item then
        data.item = self.item:toSaveData()
    end
    if self.inventory then
        data.inventory = self.inventory:toSaveData()
    end
    if self.stairs then
        data.stairs = self.stairs:toSaveData()
    end
    if self.level then
        data.level = self.level:toSaveData()
    end
    if self.equipment then
        data.equipment = self.equipment:toSaveData()
    end
    if self.equippable then
        data.equippable = self.equippable:toSaveData()
    end
    return data
end

function Entity:fromSaveData(data)
    local fighter, ai, item, inventory, stairs, level, equipment, equippable
    if data.fighter then
        fighter = Fighter:fromSaveData(data.fighter)
    end
    if data.ai then
        ai = UnknownMonster:fromSaveData(data.ai)
    end
    if data.item then
        item = Item:fromSaveData(data.item)
    end
    if data.inventory then
        inventory = Inventory:fromSaveData(data.inventory)
    end
    if data.stairs then
        stairs = Stairs:fromSaveData(data.stairs)
    end
    if data.level then
        level = Level:fromSaveData(data.level)
    end
    if data.equipment then
        data.equipment.mainHand, data.equipment.offHand = inventory:getEquippedHands(data.equipment.mainHand, data.equipment.offHand)
        equipment = Equipment:fromSaveData(data.equipment)
    end
    if data.equippable then
        equippable = Equippable:fromSaveData(data.equippable)
    end
    return Entity:new {
        x = data.x,
        y = data.y,
        char = data.char,
        color = Colors:fromName(data.color),
        name = data.name,
        blocks = data.blocks,
        renderOrder = data.renderOrder,
        fighter = fighter,
        ai = ai,
        item = item,
        inventory = inventory,
        stairs = stairs,
        level = level,
        equipment = equipment,
        equippable = equippable
    }
end

return Entity