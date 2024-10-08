local runTests = false

function rangeRoll(low, high)
    local range
    if high == nil then
        range = low
    else
        range = rangeDice(low, high)
    end
    return diceRoll(range.dice1Count, range.dice1) + diceRoll(range.dice2Count, range.dice2) + range.diceMod
end

function rangeDice(low, high)
    local lowest = {
        dice1 = 0,
        dice1Count = 0,
        dice2 = 0,
        dice2Count = 0,
        diceTotal = math.huge,
        diceMod = low
    }

    local range = high - low
    
    if range < 1 then
        return lowest
    elseif range == 1 then
        return {
            dice1 = 2,
            dice1Count = 1,
            dice2 = 0,
            dice2Count = 0,
            diceTotal = 1,
            diceMod = low - 1
        }
    elseif range == 2 then
        return {
            dice1 = 2,
            dice1Count = 2,
            dice2 = 0,
            dice2Count = 0,
            diceTotal = 2,
            diceMod = low - 2
        }
    end

    local dice = {
        { sides = 100, mult = 99 },
        { sides = 20, mult = 19 },
        { sides = 12, mult = 11 },
        { sides = 10, mult = 9 },
        { sides = 8, mult = 7 },
        { sides = 6, mult = 5 },
        { sides = 4, mult = 3 },
    }

    for _, d in ipairs(dice) do
        if d.mult <= range then
            local dice1Count, dice1, dice2Count, dice2, diceTotal

            dice1Count = math.floor(range / d.mult)
            dice1 = d.sides

            local mod = range % d.mult
            if mod == 0 then
                dice2Count = 0
                dice2 = 0
            else
                local found = false
                for _, d2 in ipairs(dice) do
                    if d2.mult <= mod then
                        if mod % d2.mult == 0 then
                            found = true
                            dice2Count = math.floor(mod / d2.mult)
                            dice2 = d2.sides
                            break
                        end
                    end
                end
                if not found then
                    dice2Count = mod
                    dice2 = 2
                end
            end

            diceTotal = dice1Count + dice2Count
            diceMod = low - diceTotal
            if diceMod ~= 0 then
                diceTotal = diceTotal + 1
            end
            if diceTotal < lowest.diceTotal or diceTotal == lowest.diceTotal and dice2 < lowest.dice2 then
                lowest.dice1 = dice1
                lowest.dice1Count = dice1Count
                lowest.dice2 = dice2
                lowest.dice2Count = dice2Count
                lowest.diceTotal = diceTotal
                lowest.diceMod = diceMod
            end
        end
    end

    return lowest
end

function diceRoll(count, sides)
    count = count or nil
    sides = sides or nil
    
    if count < 1 or sides < 1 then
        return 0
    end

    local runningSum = 0
    for i = 1,count do
        runningSum = runningSum + math.random(1, sides)
    end
    return runningSum
end

local function mainDiceString(count, sides)
    if count == 0 or sides == 0 then
        return ""
    elseif count == 1 then
        return string.format("d%d", sides)
    else
        return string.format("%dd%d", count, sides)
    end
end

local function sideDiceString(count, sides)
    if count == 0 or sides == 0 then
        return ""
    else
        return string.format("+%s", mainDiceString(count, sides))
    end
end

local function modString(mod)
    if mod == 0 then
        return ""
    elseif mod < 0 then
        return string.format("%d", mod)
    else
        return string.format("+%d", mod)
    end
end

local function printRollHeader(rolls, min, max, range)
    local dice = string.format("%s%s%s",
        mainDiceString(range.dice1Count, range.dice1),
        sideDiceString(range.dice2Count, range.dice2),
        modString(range.diceMod))
    io.write(string.format("%d rolls of [%d,%d] with %s = ", rolls, min, max, dice))
end

local function printRollResults(results)
    print(string.format("[%s]", table.concat(results, ", ")))
end

local function test(rolls, min, max)
    local results = {}
    local range = rangeDice(min, max)
    for i = 1, rolls do
        table.insert(results, rangeRoll(range))
    end
    printRollHeader(rolls, min, max, range)
    printRollResults(results)
end

if runTests then
    test(10, 1, 6)
    test(10, 2, 7)
    test(10, 3, 8)
    test(10, 0, 5)
    test(10, -2, 3)
    test(10, 2, 12)
    test(10, 3, 18)
    test(10, 1, 4)
    test(10, 2, 8)
    test(10, 3, 12)
    test(10, 4, 16)
    test(10, 5, 20)
    test(10, 9, 32)
    test(10, 1, 30)
    test(10, 2, 60)
    test(10, 3, 90)
    test(10, 4, 120)
    test(10, 5, 150)
    test(10, 6, 180)
    test(10, 7, 210)
    test(10, 10, 900)
end