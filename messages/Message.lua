local Message = { text, color }

function Message:new(text, color)
    local obj = setmetatable({}, {__index = self})
    obj.text = text
    obj.color = color or 'white'
    return obj
end

return Message