local MessageLog = { messages, x, width, height, font, fontSize }

function MessageLog:new(x, width, height)
    local obj = setmetatable({}, {__index = self})
    obj.messages = {}
    obj.x = x
    obj.width = width
    obj.height = height
    return obj
end

function MessageLog:addMessage(message)
    --print(message.text)

    local _, newMsgLines = font:getWrap(message.text, self.width * fontSize)
    for _, line in ipairs(newMsgLines) do
        if #self.messages >= self.height then
            table.remove(self.messages, 1)
        end

        table.insert(self.messages, Message:new(line, message.color))
    end
end

function MessageLog:toSaveData()
    local data = {
        messages = {},
        x = self.x,
        width = self.width,
        height = self.height
    }
    for _, message in ipairs(self.messages) do
        table.insert(data.messages, message:toSaveData())
    end
    return data
end

function MessageLog:fromSaveData(data)
    local log = MessageLog:new(data.x, data.width, data.height)
    for _, value in ipairs(data.messages) do
        log:addMessage(Message:fromSaveData(value))
    end
    return log
end

return MessageLog