require "utils.stringUtils"
local Message = require "messages.Message"

local Fighter = { owner, baseMaxHp, baseDefense, basePower, baseSpeed, hp, xp = 0 }

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
    obj.baseMaxHp = args.hp
    obj.baseDefense = args.defense
    obj.basePower = args.power
    obj.baseSpeed = args.speed
    obj.hp = args.hp
    obj.xp = args.xp or 0
    return obj
end

function Fighter:maxHp()
    local bonus = 0
    if self.owner and self.owner.equipment then
        bonus = self.owner.equipment:maxHpBonus()
    end

    return self.baseMaxHp + bonus
end

function Fighter:power()
    local bonus = 0
    if self.owner and self.owner.equipment then
        bonus = self.owner.equipment:powerBonus()
    end
       
    return self.basePower + bonus
end

function Fighter:defense()
    local bonus = 0
    if self.owner and self.owner.equipment then
        bonus = self.owner.equipment:defenseBonus()
    end
       
    return self.baseDefense + bonus
end

function Fighter:speed()
    local bonus = 0
    if self.owner and self.owner.equipment then
        bonus = self.owner.equipment:speedBonus()
    end
       
    return self.baseSpeed + bonus
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

function Fighter:toSaveData()
    return {
        baseMaxHp = self.baseMaxHp,
        baseDefense = self.baseDefense,
        basePower = self.basePower,
        baseSpeed = self.baseSpeed,
        hp = self.hp,
        xp = self.xp
    }
end

function Fighter:fromSaveData(data)
    local fighter = Fighter:new {
        hp = data.baseMaxHp,
        defense = data.baseDefense,
        power = data.basePower,
        speed = data.baseSpeed,
        xp = data.xp
    }
    fighter.hp = data.hp
    return fighter
end

return Fighter