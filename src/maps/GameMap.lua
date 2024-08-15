require "utils.diceUtils"

local BasicMonster = require "components.ai.BasicMonster"
local Equipment = require "components.Equipment"
local Equippable = require "components.Equippable"
local Fighter = require "components.Fighter"
local Item = require "components.Item"
local Stairs = require "component.Stairs"

local Entity = require "actors.Entity"
local EntityList = require "actors.EntityList"

local Message = require "messages.Message"

local itemEffects = require "functions.itemEffects"

local Rect = require "maps.Rect"
local Tile = require "maps.Tile"
local ChoiceTable = require "maps.ChoiceTable"
local LevelTable = require "maps.LevelTable"
local NodeMap = require "maps.NodeMap"

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

            local newX, newY = newRoom:center()

            centerLastRoomX = newX
            centerLastRoomY = newY

            if numRooms == 0 then
                player.x = newX
                player.y = newY
            else
                local prevX, prevY = rooms[#rooms]:center()

                if math.random(0, 1) == 1 then
                    self:createHTunnel(prevX, newX, prevY)
                    self:createVTunnel(prevY, newY, newX)
                else
                    self:createVTunnel(prevY, newY, prevX)
                    self.createHTunnel(prevX, newX, newY)
                end
            end

            self:placeEntities(newRoom, entities)

            table.insert(rooms, newRoom)
            numRooms = numRooms + 1
        end
    end

    local centerFirstX, centerFirstY = rooms[1]:center()

    local upStairs = Entity:newStairs(centerFirstX - 1, centerFirstY - 1, "<")
    entities:append(upStairs)

    local downStairs = Entity:newStairs(centerLastRoomX, centerLastRoomY, ">", self.level + 1)
    entities:append(upStairs)
end

return GameMap