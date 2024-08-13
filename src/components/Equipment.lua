local EquipmentSlots = require "enums/EquipmentSlots"

local Equipment = { mainHand, offHand }

function Equipment:new(mainHand, offHand)
    local obj = setmetatable({}, {__index = self})
    obj.mainHand = mainHand
    obj.offHand = offHand
    return obj
end

function Equipment:maxHpBonus()
    bonus = 0

    if self.mainHand and self.mainHand.equippable then
        bonus = bonus + self.mainHand.equippable.maxHpBonus
    end

    if self.offHand and self.offHand.equippable then
        bonus = bonus + self.offHand.equippable.maxHpBonus
    end

    return bonus
end

function Equipment:powerBonus()
    bonus = 0

    if self.mainHand and self.mainHand.equippable then
        bonus = bonus + self.mainHand.equippable.powerBonus
    end

    if self.offHand and self.offHand.equippable then
        bonus = bonus + self.offHand.equippable.powerBonus
    end

    return bonus
end

function Equipment:defenseBonus()
    bonus = 0

    if self.mainHand and self.mainHand.equippable then
        bonus = bonus + self.mainHand.equippable.defenseBonus
    end

    if self.offHand and self.offHand.equippable then
        bonus = bonus + self.offHand.equippable.defenseBonus
    end

    return bonus
end

function Equipment:speedBonus()
    bonus = 0

    if self.mainHand and self.mainHand.equippable then
        bonus = bonus + self.mainHand.equippable.speedBonus
    end

    if self.offHand and self.offHand.equippable then
        bonus = bonus + self.offHand.equippable.speedBonus
    end

    return bonus
end

function Equipment:toggleEquip(equippableEntity)
    results = {}

    slot = equippableEntity.equippable.slot

    if slot == EquipmentSlots.MAIN_HAND then
        if self.mainHand == equippableEntity then
            self.mainHand = nil
            table.insert(results, { deEquipped = equippableEntity })
        else
            if self.mainHand then
                table.insert(results, { deEquipped = self.mainHand })
            end

            self.mainHand = equippableEntity
            table.insert(results, { equipped = equippableEntity })
        end
    elseif slot == EquipmentSlots.OFF_HAND then
        if self.offHand == equippableEntity then
            self.offHand = nil
            table.insert(results, { deEquipped = equippableEntity })
        else
            if self.offHand then
                table.insert(results, { deEquipped = self.offHand })
            end

            self.offHand = equippableEntity
            table.insert(results, { equipped = equippableEntity })
        end
    end

    return results
end

return Equipment