local function newColor(r, g, b)
    return { r=r, g=g, b=b }
end

local Colors = {
    BLACK = { name = "black", color = newColor(0, 0, 0) },
    WHITE = { name = "white", color = newColor(1, 1, 1) },
    YELLOW = { name = "yellow", color = newColor(1, 1, 0) },
    GOLD = { name = "gold", color = newColor(1, 0.8, 0) },
    BLOOD = { name = "blood", color = newColor(0.5, 0, 0) },
    SKY = { name = "sky", color = newColor(0.5, 0.8, 1) },
    OLIVEGREEN = { name = "olivegreen", color = newColor(0.2, 0.8, 0) },
    DARKGREEN = { name = "darkgreen", color = newColor(0, 0.5, 0) },
    VIOLET = { name = "violet", color = newColor(0.8, 0, 1) },
    RED = { name = "red", color = newColor(1, 0, 0) },
    LIGHTPINK = { name = "lightpink", color = newColor(1, 0.8, 0.8) },
    DARKORANGE = { name = "darkorange", color = newColor(0.8, 0.5, 0) }
}

function Colors:fromName(name)
    for _, color in Colors do
        if color.name == name then
            return color
        end
    end
    return nil
end

return Colors