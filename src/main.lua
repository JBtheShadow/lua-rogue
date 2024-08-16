function love.load()
    local variables = require "config.variables"
    local font = love.graphics.newImageFont("img/love-font.png",
        " abcdefghijklmnopqrstuvwxyz" ..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
        "123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(font)
end

function love.update(dt)
end

function love.draw()
    love.graphics.print("Hurray, it loaded!")
end
