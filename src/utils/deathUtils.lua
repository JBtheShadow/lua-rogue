require "utils.stringUtils"
local Message = require "messages.Message"
local GameStates = require "enums.GameStates"
local RenderOrder = require "enums.RenderOrder"

function killPlayer(player)
    player.char = "%"
    player.color = "darkred"

    return {{ state = GameStates.PLAYER_DEAD, message = Message:new("You died", "red") }}
end

function killMonster(monster)
    local deathMessage = Message:new(string.format("%s is dead!", capitalize(monster.name)), "orange")

    monster.char = "%"
    monster.color = "darkred"
    monster.blocks = false
    monster.fighter = nil
    monster.ai = nil
    monster.name = "remains of " + monster.name
    monster.renderOrder = RenderOrder.CORPSE

    return {{ message = deathMessage }}
end