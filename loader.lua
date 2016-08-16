local Loader = {}

local function capitalize(str)
    return str:gsub("^%l", string.upper)
end

function Loader.includeNamespace(path, ...)
    return Loader.include(path, false, ...)
end

function Loader.includeModules(path, ...)
    return Loader.include(path, true, ...)
end

function Loader.include(path, global, ...)
    local includes = global and _G or {}
    local nargs = select('#', ...)

    for m = 1, nargs do
        local key = select(m, ...)
        local name = capitalize(key)
        includes[name] = require(path .. "." .. key)
    end

    return includes
end

return Loader
