local constants = require "constants"
local Entity = require "actors/Entity"
local Fighter = require "components/Fighter"
local Inventory = require "components/Inventory"
local Level = require "components/Level"
local Equipment = require "components/Equipment"
local Equippable = require "components/Equippable"
local RenderOrder = require "enums/RenderOrder"
local EquipmentSlots = require "enums/EquipmentSlots"
local GameStates = require "enums/GameStates"

local fighterComponent = Fighter:new { hp=100, defense=1, power=2, speed=4 }
local inventoryComponent = Inventory:new(26)
local levelComponent = Level:new()
local equipmentComponent = Equipment:new()
local player = Entity:new {
    x=0, y=0, char="@", color="white", name="Player", blocks=true, renderOrder=RenderOrder.ACTOR,
    fighter=fighterComponent, inventory=inventoryComponent, level=levelComponent,
    equipment=equipmentComponent
}
local entities = {} -- EntityList()
--entities.append(player)

local equippableComponent = Equippable:new { slot=EquipmentSlots.MAIN_HAND, powerBonus=2 }
local dagger = Entity:new { x=0, y=0, char="-", color="sky", name="Dagger", equippable=equippableComponent }
player.inventory:addItem(dagger)
player.equipment:toggleEquip(dagger)

local gameMap = {} -- GameMap(constants['map_width'], constants['map_height'])
--game_map.make_map(constants['max_rooms'], constants['room_min_size'], constants['room_max_size'],
--                  constants['map_width'], constants['map_height'], player, entities)

local messageLog = {} -- MessageLog(constants['message_x'], constants['message_width'], constants['message_height'])

local gameState = GameStates.PLAYERS_TURN

return {
    player = player,
    entities = entities,
    gameMap = gameMap,
    messageLog = messageLog,
    gameState = gameState
}