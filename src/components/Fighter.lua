require "helpers"
local Message = require "messages/Message"

local Fighter = {
    owner,
    base = { maxHp, defense, power, speed },
    hp,
    xp = 0
}

function Fighter:new(args)
    if type(args.hp) ~= "number" then
        error("no hp")
    elseif type(args.defense) ~= "number" then
        error("no defense")
    elseif type(args.power) ~= "number" then
        error("no power")
    elseif type(args.speed) ~= "number" then
        error("no speed")
    end

    local obj = setmetatable({}, {__index = self})
    obj.owner = nil
    obj.base.maxHp = args.hp
    obj.base.defense = args.defense
    obj.base.power = args.power
    obj.base.speed = args.speed
    obj.hp = args.hp
    obj.xp = args.xp or 0
    return obj
end

function Fighter:maxHp()
    local bonus = 0
    if self.owner and self.owner.equipment then
        bonus = self.owner.equipment:maxHpBonus()
    end

    return self.base.maxHp + bonus
end

function Fighter:power()
    local bonus = 0
    if self.owner and self.owner.equipment then
        bonus = self.owner.equipment:powerBonus()
    end
       
    return self.base.power + bonus
end

function Fighter:defense()
    local bonus = 0
    if self.owner and self.owner.equipment then
        bonus = self.owner.equipment:defenseBonus()
    end
       
    return self.base.defense + bonus
end

function Fighter:speed()
    local bonus = 0
    if self.owner and self.owner.equipment then
        bonus = self.owner.equipment:speedBonus()
    end
       
    return self.base.speed + bonus
end

function Fighter:takeDamage(amount)
    local results = {}

    self.hp = self.hp - amount
    if self.hp <= 0 then
        self.hp = 0
        table.insert(results, { dead = self.owner, xp = self.xp })
    end

    return results
end

function Fighter:heal(amount)
    self.hp = self.hp + amount

    if self.hp > self:maxHp() then
        self.hp = self:maxHp()
    end
end

function Fighter:attack(target)
    local results = {}

    local damage = self:power() - target.fighter:defense()

    if damage > 0 then
        table.insert(results, {
            message = Message:new(string.format("%s attacks %s for %d hit point(s).", capitalize(self.owner.name), target.name, damage))
        })
        for _, result in ipairs(target.fighter:takeDamage(damage)) do
            results.append(result)
        end
    else
        table.insert(results, {
            message = Message:new(string.format("%s attacks %s but does not damage.", capitalize(self.owner.name), target.name))
        })
    end

    return results
end

return Fighter