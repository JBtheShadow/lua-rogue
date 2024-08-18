local Tile = { blocked, blockSight, explored }

function Tile:new(blocked, blockSight)
    local obj = setmetatable({}, {__index = self})
    obj.blocked = blocked or false
    obj.blockSight = blockSight or blocked or false
    obj.explored = false
    return obj
end

function Tile:toSaveData()
    local blocked = self.blocked and "1" or "0"
    local blockSight = self.blockSight and "1" or "0"
    local explored = self.explored and "1" or "0"
    return string.format("%s%s%s", blocked, blockSight, explored)
end

function Tile:fromSaveData(data)
    local tile = Tile:new()
    tile.blocked = data[1] == "1" and true or false
    tile.blockSight = data[2] == "1" and true or false
    tile.explored = data[3] == "1" and true or false
    return tile
end

return Tile