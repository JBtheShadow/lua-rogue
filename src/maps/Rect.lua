local Node = require "maps/Node"

local Rect = { x1, y1, x2, y2 }

function Rect:new(x, y, width, height)
    local obj = setmetatable({}, {__index = self})
    obj.x1 = x
    obj.y1 = y
    obj.x2 = x + width
    obj.y2 = y + height
    return obj
end

function Rect:width()
    return obj.x2 - obj.x1
end

function Rect:height()
    return obj.y2 - obj.y1
end

function Rect:center()
    local x = math.floor((self.x1 + self.x2) / 2)
    local y = math.floor((self.y1 + self.y2) / 2)
    return Node:new(x, y)
end

function Rect:intersects(other)
    if self.x1 > other.x2 or self.x2 < other.x1 then
        return false
    elseif self.y1 > other.y2 or self.y2 < other.y1 then
        return false
    else
        return true
    end
end

return Rect