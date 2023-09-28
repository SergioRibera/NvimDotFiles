M = {}

M.isModuleAvailable = function(name)
    if package.loaded[name] then
        return true
    else
        --- @diagnostic disable-next-line: deprecated
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end

local function dump_table(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump_table(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
M.dump_table = dump_table

M.is_str_empty = function (s)
    return s == nil or s == ''
end

M.get_lines = function (str)
    local t = {}
    local function helper(line) table.insert(t, line) return "" end
    helper((str:gsub("(.-)\r?\n", helper)))
    return t
end

M.split_str = function (str, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for s in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, s)
    end
    return t
end

return M
