function capitalize(str)
    return (str:gsub("^%l", string.upper))
end

function group(options)
    local groups = {}
    for i, option in ipairs(options) do
        if not groups[option] then
            groups[option] = { count = 0, index = i }
        end
        groups[option].count = groups[option].count + 1
    end
    
    return groups
end

function groupOptions(options)
    local newOptions = {}
    local groups = group(options)
    for key, group in pairs(groups) do
        if group.count > 1 then
            table.insert(string.format("%s x%d", key, group.count))
        else
            table.insert(key)
        end
    end

    return newOptions
end

function groupIndexes(options)
    local groups = group(options)
    local indexes = {}
    for key, group in pairs(groups) do
        table.insert(indexes, group.index)
    end
    return indexes
end