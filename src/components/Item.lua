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

return Item