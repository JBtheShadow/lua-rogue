local Message = require "messages.Message"
local ConfusedMonster = require "components.ai.ConfusedMonster"

local function heal(args)
    local entity = args.entity
    local amount = args.amount

    local results = {}

    if entity.fighter.hp == entity.fighter:maxHp() then
        table.insert(results, { consumed = false, message = Message:new("You are already at full health", "yellow") })
    else
        entity.fighter:heal(amount)
        table.insert(results, { consumed = true, message = Message:new("Your wounds start to feel better!", "green") })
    end

    return results
end

local function castLightning(args)
    local caster = args.entity
    local entities = args.entities
    local fovMap = args.fovMap
    local damage = args.damage
    local maxRange = args.maxRange

    local results = {}

    local target
    local closestDistance = maxRange + 1

    for _, entity in ipairs(entities) do
        if entity.fighter and entity ~= caster and fovMap:isInFieldOfView(entity.x, entity.y) then
            local distance = caster:distanceTo(entity)

            if distance < closestDistance then
                target = entity
                closestDistance = distance
            end
        end
    end

    if target then
        table.insert(results, { consumed = true, target = target, message = Message:new(string.format("A lightning bolt strikes the %s with a loud thunder! The damage is %d", target.name, damage)) })
        for _, result in ipairs(target.fighter:takeDamage(damage)) do
            table.insert(results, result)
        end
    else
        table.insert(results, { consumed = false, target, message = Message:new("No enemy is close enough to strike.", "red") })
    end

    return results
end

local function castFireball(args)
    local entities = args.entities
    local fovMap = args.fovMap
    local damage = args.damage
    local radius = args.radius
    local targetX = args.targetX
    local targetY = args.targetY

    local results = {}

    if not fovMap:isInFieldOfView(targetX, targetY) then
        table.insert(results, { consumed = false, message = Message:new("You cannot target a tile outside of your field of view.", "yellow") })
        return results
    end

    table.insert(results, { consumed = true, message = Message:new(string.format("the fireball explodes, burning everything within %d tiles!", radius), "orange") })

    for _, entity in ipairs(entities) do
        if entity:distance(targetX, targetY) <= radius and entity.fighter then
            table.insert(results, { message = Message:new(string.format("The %s gets burned for %d hit points.", entity.name, damage), "orange") })
            for _, result in entity.fighter:takeDamage(damage) do
                table.insert(results, result)
            end
        end
    end

    return results
end

function castConfuse(args)
    local entities = args.entities
    local fovMap = args.fovMap
    local targetX = args.targetX
    local targetY = args.targetY

    local results = {}

    if not fovMap:isInFieldOfView(targetX, targetY) then
        table.insert(results, { consumed = false, message = Message:new("You cannot target a tile outside of your field of view.", "yellow") })
        return results
    end

    local found = false
    for _, entity in ipairs(entities) do
        if entity.x == targetX and entity.y == targetY and entity.ai then
            found = true
            local confusedAi = ConfusedMonsters:new(entityAi, 10)

            confusedAi.owner = entity
            entity.ai = confusedAi

            table.insert(results, { consumed = true, message = Message:new(string.format("The eyes of the %s look vacant, as he starts to stumble around!", entity.name, "lightgreen")) })
            break
        end
    end
    if not found then
        table.insert(results, { consumed = false, message = Message:new("There is no targetable enemy at that location.", "yellow") })
    end

    return results
end 

local ItemEffects = {
    HEAL = { name = "heal", effect = heal },
    CAST_LIGHTNING = { name = "castLightning", effect = castLightning },
    CAST_FIREBALL = { name = "castFireball", effect = castFireball },
    CAST_CONFUSE = { name = "castConfuse", effect = castConfuse }
}

function ItemEffects.fromName(name)
    for _, effect in pairs(ItemEffects) do
        if type(effect) == "table" and effect.name == name then
            return effect
        end
    end
    return nil
end

return ItemEffects