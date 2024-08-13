local Level = { owner, currentLevel, currentXp, levelUpBase, levelUpFactor }

function Level:new(currentLevel, currentXp, levelUpBase, levelUpFactor)
    local obj = setmetatable({}, {__index = self})
    obj.owner = nil
    obj.currentLevel = currentLevel or 1
    obj.currentXp = currentXp or 0
    obj.levelUpBase = levelUpBase or 200
    obj.levelUpFactor = levelUpFactor or 150
    return obj
end

function Level:experienceToNextLevel()
    return self.levelUpBase + self.currentLevel * self.levelUpFactor
end

function Level:addXp(xp)
    self.currentXp = self.currentXp + xp

    if self.currentXp > self:experienceToNextLevel() then
        self.currentXp = self.currentXp - self.experienceToNextLevel()
        self.currentLevel = self.currentLevel + 1
        
        return true
    else
        return false
    end
end

return Level