local load = require('core.dotenv.load')

local M = {}

function M.get_env_variable(name, default)
    if vim.env[name] then
        return vim.env[name]
    else
        return default
    end
end

M.get_all_env = function ()
    return vim.env
end

function M.set_env_variable(name, value)
    vim.env[name] = value
end


function M.load()
    local files = vim.fs.find(".env", { upward = true, type = "file" })
    for i = 1, #files do
        local file = files[i]
        print(file)
        local data = load.load_data(file, false)
        for key, value in pairs(data) do
            M.set_env_variable(key, value)
        end
    end
end

return M
