local constants = require "config.constants"

local Entity = require "actors.Entity"
local EntityList = require "actors.EntityList"

local RenderOrder = require "enums.RenderOrder"
local EquipmentSlots = require "enums.EquipmentSlots"
local GameStates = require "enums.GameStates"

local MessageLog = require "messages.MessageLog"

math.randomseed(os.time())

local entities = EntityList:new()
local player = Entity:newPlayer(0, 0)
entities:append(player)

local dagger = Entity:newEquipment(0, 0, "-", "sky", "Dagger", { slot=EquipmentSlots.MAIN_HAND, powerBonus=2 })
player.inventory:addItem(dagger)
player.equipment:toggleEquip(dagger)

local gameMap = GameMap:new(constants.map.width, constants.map.height)
gameMap.makeMap(constants.rooms.max, constants.rooms.size.min, constants.rooms.size.max, constants.map.width, constants.map.height, player, entities)

local messageLog = MessageLog:new(constants.message.x, constants.message.width, constants.message.height)

local gameState = GameStates.PLAYERS_TURN

return {
    player = player,
    entities = entities,
    gameMap = gameMap,
    messageLog = messageLog,
    gameState = gameState
}