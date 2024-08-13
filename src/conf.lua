function love.conf(t)
    config = require "constants"
    t.console = true
    t.window.title = config.window.title
end