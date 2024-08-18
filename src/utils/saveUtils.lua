local lume = require "libraries.lume"

local EntityList = require "actors.EntityList"
local GameMap = require "maps.GameMap"
local MessageLog = require "messages.MessageLog"
local GameStates = require "enums.GameStates"

function saveGame(player, entities, gameMap, messageLog, gameState)
    local data = {}
    data.playerIndex = entities:indexOf(player)
    data.entities = entities:toSaveData()
    data.gameMap = gameMap:toSaveData()
    data.messageLog = messageLog:toSaveData()
    data.gameState = gameState
    
    local serialized = lume.serialize(data)
    love.filesystem.write("savegame.txt", serialized)
end

function loadGame()
    if not love.filesystem.getInfo("savegame.txt") then
        return nil
    end

    local file = love.filesystem.read("savegame.txt")
    data = lume.deserialize(file)

    local playerIndex = data.playerIndex
    local entities = EntityList:fromSaveData(data.entities)
    local gameMap = GameMap:fromSaveData(data.gameMap)
    local messageLog = MessageLog:fromSaveData(data.messageLog)
    local gameState = data.gameState
    local player = entities:atIndex(playerIndex)

    return player, entities, gameMap, messageLog, gameState
end