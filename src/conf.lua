function love.conf(t)
    config = require "config.constants"
    t.console = true
    t.window.title = config.window.title
end