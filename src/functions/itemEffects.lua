local Message = require "messages.Message"

local obj = {}
obj.heal = function(args)
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

obj.castLightning = function(args)
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

return obj