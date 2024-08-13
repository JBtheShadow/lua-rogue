local Stairs = { owner, floor }

function Stairs:new(floor)
    local obj = setmetatable({}, {__index = self})
    obj.owner = nil
    obj.floor = floor
    return obj
end

return Stairs