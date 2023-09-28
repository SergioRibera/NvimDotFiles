local utils = require("core.utils")
local M = {}

function M.load_data(file_path, create_if_not_exists)
    local file, _ = io.open (file_path, "r")
    local data_loaded = {}
    if file == nil and create_if_not_exists == true then
        local f = io.open(file_path, "w")
        f:write("")
    else
        local content = file:read("*a")
        data_loaded = M.load_data_from_text(content)
        file:close()
    end
    return data_loaded
end

function M.load_data_from_text (content)
    local data_loaded = {}
        local lines_arr = utils.get_lines(content)
        if next(lines_arr) ~= nil then
            for v in pairs(lines_arr) do
                local line = lines_arr[v]
                if not utils.is_str_empty(line) and string.sub(line, 1, 1) ~= "#" then
                    local raw_values = utils.split_str(line, "=")
                    data_loaded[raw_values[1]] = raw_values[2]
                end
            end
        end
    return data_loaded
end

return M
