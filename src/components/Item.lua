local ItemEffects = require "enums.ItemEffects"

local Item = { onUse, args, targeting, targetingMessage }

function Item:new(args)
    args = args or {}
    local obj = setmetatable({}, {__index = self})
    obj.onUse = args.onUse
    obj.args = args.args or {}
    obj.targeting = args.targeting or false
    obj.targetingMessage = args.targetingMessage
    return obj
end

function Item:toSaveData()
    return {
        onUse = (self.onUse or {}).name,
        args = self.args,
        targeting = self.targeting,
        targetingMessage = self.targetingMessage
    }
end

function Item:fromSaveData(data)
    return Item:new {
        onUse = ItemEffects.fromName(data.onUse),
        args = data.args,
        targeting = data.targeting,
        targetingMessage = data.targetingMessage
    }
end

return Item