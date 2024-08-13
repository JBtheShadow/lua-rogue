local Item = { onUse, onUseArgs, targeting, targetingMessage }

function Item:new(args)
    local obj = setmetatable({}, {__index = self})
    obj.onUse = args.onUse
    obj.onUseArgs = args.onUseArgs
    obj.targeting = args.targeting or false
    obj.targetingMessage = args.targetingMessage
    return obj
end

return Item