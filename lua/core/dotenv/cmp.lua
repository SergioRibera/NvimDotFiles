local dotenv = require("core.dotenv.mod")
local source = {}

function source.new()
    return setmetatable({}, { __index = source })
end

function source.get_debug_name()
    return "dotenv"
end

function source:is_available()
    return true
end

source.get_trigger_characters = function()
    return { "'", '"' }
end

function source:complete(_, callback)
    local items = {}
    for key, value in ipairs(dotenv.get_all_env()) do
        table.insert(items, {
            word = '',
            label = key,
            kind = 'Constant',
            filterText = ' ',
            insertText = key,
            documentation = value
        }
        )
    end

    callback {
        items = items,
        isIncomplete = true,
    }
end

return source
