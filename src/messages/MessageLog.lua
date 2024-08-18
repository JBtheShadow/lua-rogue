local MessageLog = { messages, x, width, height, font, fontSize }

function MessageLog:new(x, width, height, font)
    local obj = setmetatable({}, {__index = self})
    obj.messages = {}
    obj.x = x
    obj.width = width
    obj.height = height
    obj.font = font
    obj.fontSize = fontSize
    return obj
end

function MessageLog:addMessage(message)
    print(message.text)

    local _, newMsgLines = font.getWrap(message.text, self.width * fontSize)
    for _, line in ipairs(newMsgLines) do
        if #self.messages >= self.height then
            table.remove(self.messages, 1)
        end

        table.insert(self.messages, Message:new(line, message.color))
    end
end

return MessageLog