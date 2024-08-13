local Fighter = require "components/fighter"
--require "dump"

function love.load()
    math.randomseed(os.time())

    fighter = Fighter:new{hp=10, defense=1, power=3, speed=2}

    constants = require "constants"
    --local variables = require "variables"
    --print(dump(constants))
end

function love.update(dt)
end

function love.draw()
    
end
