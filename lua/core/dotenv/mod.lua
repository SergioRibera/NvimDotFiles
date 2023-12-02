local load = require('core.dotenv.load')

local M = {}
M.env_variables = {}

function M.get_env_variable(name, default)
    -- if vim.env[name] then
    --     return vim.env[name]
    -- else
    --     return default
    -- end
    if M.env_variables[name] then
        return M.env_variables[name]
    else
        return default
    end
end

M.get_all_env = function ()
    return M.env_variables
end

function M.set_env_variable(name, value)
    vim.env[name] = value
    M.env_variables[name] = value
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
    local cmp = package.loaded['cmp']
    if cmp then
        cmp.register_source('dotenv', require('core.dotenv.cmp').new())
    end
end

return M
