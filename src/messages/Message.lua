local Colors = require "enums.Colors"

local Message = { text, color }

function Message:new(text, color)
    local obj = setmetatable({}, {__index = self})
    obj.text = text
    obj.color = color or Colors.WHITE
    return obj
end

function Message:toSaveData()
    return {
        text = self.text,
        color = self.color.name
    }
end

function Message:fromSaveData(data)
    local color = Colors:fromName(data.color)
    return Message:new(data.text, color)
end

return Message