local Equippable = { owner, slot, powerBonus, defenseBonus, speedBonus, maxHpBonus }

function Equippable:new(args)
    if type(args.slot) == "nil" then
        error("no slot")
    end

    local obj = setmetatable({}, {__index = self})
    obj.owner = nil
    obj.slot = args.slot
    obj.powerBonus = args.powerBonus or 0
    obj.defenseBonus = args.defenseBonus or 0
    obj.speedBonus = args.speedBonus or 0
    obj.maxHpBonus = args.maxHpBonus or 0
    return obj
end

return Equippable