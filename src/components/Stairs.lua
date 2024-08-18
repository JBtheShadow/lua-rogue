local Stairs = { owner, floor }

function Stairs:new(floor)
    local obj = setmetatable({}, {__index = self})
    obj.owner = nil
    obj.floor = floor
    return obj
end

function Stairs:toSaveData()
    return { floor = self.floor }
end

function Stairs:fromSaveData(data)
    return Stairs:new(data.floor)
end

return Stairs