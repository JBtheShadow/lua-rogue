local Tile = { blocked, blockSight, explored }

function Tile:new(blocked, blockSight)
    local obj = setmetatable({}, {__index = self})
    obj.blocked = blocked or false
    obj.blockSight = blockSight or blocked or false
    obj.explored = false
    return obj
end

return Tile