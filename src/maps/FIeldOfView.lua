local FieldOfView = { width, height, map }

function FieldOfView:new(width, height)
    local obj = setmetatable({}, {__index = self})
    obj.width = width
    obj.height = height
    obj.map = {}
    for y = 1, height do
        table.insert(obj.map, {})
        for x = 1, width do
            obj.map[y][x] = { blockSight = false, blocked = false }
        end
    end
    return obj
end

function FieldOfView:setProps(x, y, blockSight, blocked)
    obj.map[y][x] = { blockSight = blockSight, blocked = blocked }
end

return FieldOfView