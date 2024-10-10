function capitalize(str)
    return (str:gsub("^%l", string.upper))
end

function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in inputstr:gmatch("([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
