function love.conf(t)
    local fontSize = 17
    config = require "config.constants"
    t.console = true
    t.window.title = config.window.title
    t.window.width = config.screen.width * fontSize
    t.window.height = config.screen.height * fontSize

    t.modules.joystick = false
    t.modules.physics = false
    t.identity = "lua-rogue"
end