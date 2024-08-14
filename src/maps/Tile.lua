local Tile = { blocked, blockSight, explored }

function Tile:new(blocked, blockSight)
    local obj = setmetatable({}, {__index = self})
    obj.blocked = blocked
    obj.blockSight = blockSight or blocked
    obj.explored = false
    return obj
end

return Tile