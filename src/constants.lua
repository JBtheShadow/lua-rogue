local obj = {
    window = { title = "Roguelike Python Tutorial, ported to Lua" },
    screen = { width = 80, height = 50 },
    bar = { width = 20 },
    panel = { height = 7, y },
    message = { x, width, height },
    map = { width = 80, height = 43 },
    rooms = {
        max = 30,
        size = { min = 6, max = 10 },
        maxMonsters = 3,
        maxItems = 2
    },
    fov = { algorithm = 0, lightWalls = true, radius = 10 },
    colors = {
        wall = { dark = {0, 0, 100}, light = {200, 180, 50} },
        ground = { dark = {50, 50, 150}, light = {200, 180, 50} }
    }
}

obj.panel.y = obj.screen.height - obj.panel.height
obj.message = {
    x = obj.bar.width + 2,
    width = obj.screen.width - obj.bar.width - 2,
    height = obj.panel.height - 1
}

return obj