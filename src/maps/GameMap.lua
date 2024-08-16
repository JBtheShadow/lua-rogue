require "utils.diceUtils"

local BasicMonster = require "components.ai.BasicMonster"
local Equipment = require "components.Equipment"
local Equippable = require "components.Equippable"
local Fighter = require "components.Fighter"
local Item = require "components.Item"
local Stairs = require "components.Stairs"

local Entity = require "actors.Entity"
local EntityList = require "actors.EntityList"

local Message = require "messages.Message"

local itemEffects = require "functions.itemEffects"

local Rect = require "maps.Rect"
local Tile = require "maps.Tile"
local ChoiceTable = require "maps.ChoiceTable"
local LevelTable = require "maps.LevelTable"
local NodeMap = require "maps.NodeMap"
local Node = require "maps.Node"

local EquipmentSlots = require "enums.EquipmentSlots"
local RenderOrder = require "enums.RenderOrder"

local GameMap = { width, height, level }

function GameMap:new(width, height, level)
    local obj = setmetatable({}, {__index = self})
    obj.width = width
    obj.height = height
    obj.tiles = obj:initializeTiles()
    obj.level = level or 1
    return obj
end

function GameMap:initializeTiles()
    local tiles = NodeMap:new()
    for y = 1, self.height do
        for x = 1, self.width do
            local node = Node:new(x, y)
            local tile = Tile:new(true)
            tiles:set(node, tile)
        end
    end
    return tiles
end

function GameMap:generate(maxRooms, roomMinSize, roomMaxSize, mapWidth, mapHeight, player, entities)
    local rooms = {}
    local numRooms = 0

    local centerLastRoomX = nil
    local centerLastRoomY = nil

    for _ = 1, maxRooms do
        local w = math.random(roomMinSize, roomMaxSize)
        local h = math.random(roomMinSize, roomMaxSize)

        local x = math.random(1, mapWidth - w)
        local y = math.random(1, mapHeight - h)

        local newRoom = Rect:new(x, y, w, h)

        local intersects = false
        for _, otherRoom in ipairs(rooms) do
            if newRoom:intersects(otherRoom) then
                intersects = true
                break
            end
        end
        if not intersects then
            self:createRoom(newRoom)

            local new = newRoom:center()

            centerLastRoomX = new.x
            centerLastRoomY = new.y

            if numRooms == 0 then
                player.x = new.x
                player.y = new.y
            else
                local prev = rooms[#rooms]:center()

                if math.random(0, 1) == 1 then
                    self:createHTunnel(prev.x, new.x, prev.y)
                    self:createVTunnel(prev.y, new.y, new.x)
                else
                    self:createVTunnel(prev.y, new.y, prev.x)
                    self:createHTunnel(prev.x, new.x, new.y)
                end
            end

            self:placeEntities(newRoom, entities)

            table.insert(rooms, newRoom)
            numRooms = numRooms + 1
        end
    end

    local centerFirst = rooms[1]:center()

    local upStairs = Entity:newStairs(centerFirst.x - 1, centerFirst.y - 1, "<")
    entities:append(upStairs)

    local downStairs = Entity:newStairs(centerLastRoomX, centerLastRoomY, ">", self.level + 1)
    entities:append(upStairs)
end

function GameMap:getTile(x, y)
    local node = Node:new(x, y)
    return self.tiles:get(node)
end

function GameMap:setTile(x, y, blocked, blockSight)
    local node = Node:new(x, y)
    local tile = self:getTile(x, y)
    tile.blocked = blocked
    tile.blockSight = blockSight
    self.tiles:set(node, tile)
end

function GameMap:createRoom(room)
    for x = room.x1 + 1, room.x2 - 1 do
        for y = room.y1 + 1, room.y2 - 1 do
            self:setTile(x, y, false, false)
        end
    end
end

function GameMap:createHTunnel(x1, x2, y)
    for x = math.min(x1, x2), math.max(x1, x2) do
        self:setTile(x, y, false, false)
    end
end

function GameMap:createVTunnel(y1, y2, x)
    for y = math.min(y1, y2), math.max(y1, y2) do
        self:setTile(x, y, false, false)
    end
end

function GameMap:placeEntities(room, entities)
    local maxMonstersPerRoom = LevelTable:new({{1, 2}, {4, 3}, {6, 5}}):getChanceByLevel(self.level)
    local maxItemsPerRoom = LevelTable:new({{1, 1}, {4, 2}}):getChanceByLevel(self.level)

    local numberMonsters = math.random(0, maxMonstersPerRoom)
    local numberItems = math.random(0, maxItemsPerRoom)

    local monsterChances = ChoiceTable:new {
        orc = 80,
        troll = LevelTable:new({{3, 15}, {5, 30}, {7, 60}}):getChanceByLevel(self.level)
    }
    print(table.concat(monsterChances, ", "))

    local itemChances = ChoiceTable:new {
        money = 20,
        healingPotion = 35,
        sword = LevelTable:new({{4, 5}}):getChanceByLevel(self.level),
        shield = LevelTable:new({{8, 15}}):getChanceByLevel(self.level),
        lightningScroll = LevelTable:new({{4, 25}}):getChanceByLevel(self.level),
        fireballScroll = LevelTable:new({{6, 25}}):getChanceByLevel(self.level),
        confusionScroll = LevelTable:new({{2, 10}}):getChanceByLevel(self.level)
    }

    for _ = 1, numberMonsters do
        local x = math.random(room.x1 + 1, room.x2 - 1)
        local y = math.random(room.y1 + 1, room.y2 - 1)

        local occupied = false
        for _, entity in ipairs(entities) do
            if entity.x == x and entity.y == y then
                occupied = true
                break
            end
        end
        if not occupied then
            local monsterChoice = monsterChances:getChoice()

            local monster
            if monsterChoice == "orc" then
                monster = Entity:newMonster(x, y, 'o', "olivegreen", "Orc", { hp=20, defense=0, power=4, speed=3, xp=35 })
            elseif monsterChoice == "troll" then
                monster = Entity:newMonster(x, y, 'T', "darkgreen", "Troll", { hp=30, defense=2, power=8, speed=2, xp=100 })
            end

            table.insert(entities, monster)
        end
    end

    for _ = 1, numberItems do
        local x = math.random(room.x1 + 1, room.x2 - 1)
        local y = math.random(room.y1 + 1, room.y2 - 1)

        local occupied = false
        for _, entity in ipairs(entities) do
            if entity.x == x and entity.y == y then
                occupied = true
                break
            end
        end
        if not occupied then
            local itemChoice = itemChances:getChoice()

            local item
            if itemChoice == "healingPotion" then
                item = Entity:newItem(x, y, "!", "violet", "Healing Potion", { onUse=itemEffects.heal, args={ amount= 40} })
            elseif itemChoice == "money" then
                item = Entity:newGoldPile(x, y, rangeRoll(self.level, self.level * 30))
            elseif itemChoice == "sword" then
                item = Entity:newEquipment(x, y, "/", "sky", "Sword", { slot=EquipmentSlots.MAIN_HAND, powerBonus=3 })
            elseif itemChoice == "shield" then
                item = Entity:newEquipment(x, y, "[", "darkorange", "Shield", { slot=EquipmentSlots.OFF_HAND, defenseBonus=1 })
            elseif itemChoice == "fireballScroll" then
                item = Entity:newItem(x, y, "#", "red", "Fireball Scroll", {
                    onUse=itemEffects.castFireball, targeting=true,
                    targetingMessage=Message:new("Left-click a target tile for the fireball, or right-click to cancel.", "lightcyan"),
                    args={ damage=25, radius=3 }
                })
            elseif itemChoice == "confusionScroll" then
                item = Entity:newItem(x, y, "#", "lightpink", "Confusion Scroll", {
                    onUse=itemEffects.castConfuse, targeting=true,
                    targetingMessage=Message:new("Left-click an enemy to confuse it, or right-click to cancel.", "lightcyan")
                })
            elseif itemChoice == "lightningScroll" then
                item = Entity:newItem(x, y, "#", "yellow", "Lightning Scroll", { onUse=itemEffects.castLightning, args={ damage=40, maxRange=5 } })
            end

            table.insert(entities, item)
        end
    end
end

function GameMap:isBlocked(x, y)
    if x < 1 or x > self.width or y < 1 or y > self.height then
        return true
    end

    local tile = self:getTile(x, y)
    return tile.blocked
end

function GameMap:nextFloor(player, messageLog, constants)
    self.level = self.level + 1
    entities = EntityList:new()
    entities:append(player)

    self.tiles = self:initializeTiles()
    self:generate(constants.rooms.max, constants.rooms.size.min, constants.rooms.size.max, constants.map.width, constants.map.height, player, entities)

    player.fighter:heal(math.floor(player.fighter.maxHp() / 2))

    messageLog:addMessage(Message:new("You take a moment to rest and recover your strength.", "lightviolet"))

    return entities
end

return GameMap