local MessageLog = { messages, x, width, height }

function MessageLog:new(x, width, height)
    local obj = setmetatable({}, {__index = self})
    obj.messages = {}
    obj.x = x
    obj.width = width
    obj.height = height
    return obj
end

function MessageLog:addMessage(message)
    print(message.text)
    table.insert(self.messages, message)
    if #self.messages > self.height then
        table.remove(self.messages, 1)
    end
end

return MessageLog