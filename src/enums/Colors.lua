local function newColor(r, g, b)
    return { r=r, g=g, b=b }
end

local Colors = {
    WHITE = newColor(1, 1, 1),
    YELLOW = newColor(1, 1, 0),
    GOLD = newColor(1, 0.8, 0),
    BLOOD = newColor(0.5, 0, 0),
    SKY = newColor(0.5, 0.8, 1),
    OLIVEGREEN = newColor(0.2, 0.8, 0),
    DARKGREEN = newColor(0, 0.5, 0),
    VIOLET = newColor(0.8, 0, 1),
    RED = newColor(1, 0, 0),
    LIGHTPINK = newColor(1, 0.8, 0.8),
    DARKORANGE = newColor(0.8, 0.5, 0)
}
return Colors