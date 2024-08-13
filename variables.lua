local Fighter = require "components/Fighter"
local Inventory = require "components/Inventory"

local constants = require "constants"

local fighterComponent = Fighter:new { hp=100, defense=1, power=2, speed=4 }
local inventoryComponent = Inventory:new(26)
local levelComponent = {} --Level()
local equipmentComponent = {} --Equipment()
local player = {} --Entity(0, 0, '@', libtcod.white, 'Player', blocks=True, render_order=RenderOrder.ACTOR,
                  --fighter=fighter_component, inventory=inventory_component, level=level_component,
                 --equipment=equipment_component)
local entities = {} -- EntityList()
--entities.append(player)

local equippableComponent = {} -- Equippable(EquipmentSlots.MAIN_HAND, power_bonus=2)
local dagger = {} -- Entity(0, 0, '-', libtcod.sky, 'Dagger', equippable=equippable_component)
--player.inventory.add_item(dagger)
--player.equipment.toggle_equip(dagger)

local gameMap = {} -- GameMap(constants['map_width'], constants['map_height'])
--game_map.make_map(constants['max_rooms'], constants['room_min_size'], constants['room_max_size'],
--                  constants['map_width'], constants['map_height'], player, entities)

local messageLog = {} -- MessageLog(constants['message_x'], constants['message_width'], constants['message_height'])

local gameState = {} -- GameStates.PLAYERS_TURN

return {
    player = player,
    entities = entities,
    gameMap = gameMap,
    messageLog = messageLog,
    gameState = gameState
}