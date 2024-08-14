function capitalize(str)
    return (str:gsub("^%l", string.upper))
end