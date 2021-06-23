local M = {}
local fmt = string.format

function M.get_hex(opts)
    local name, attribute, fallback, not_match =
    opts.name, opts.attribute, opts.fallback, opts.not_match
    -- translate from internal part to hl part
    assert(
    attribute == "fg" or attribute == "bg",
    fmt('Color part for %s should be one of "fg" or "bg"', vim.inspect(opts))
    )
    attribute = attribute == "fg" and "foreground" or "background"

    -- try and get hl from name
    local success, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
    if success and hl and hl[attribute] then
        -- convert from decimal color value to hex (e.g. 14257292 => "#D98C8C")
        local hex = "#" .. bit.tohex(hl[attribute], 6)
        if not not_match or not_match ~= hex then
            return hex
        end
    end

    -- basic fallback
    if fallback and type(fallback) == "string" then
        return fallback
    end

    -- bit of recursive fallback logic
    if fallback and type(fallback) == "table" then
        assert(
        fallback.name and fallback.attribute,
        'Fallback should have "name" and "attribute" fields'
        )
        return M.get_hex(fallback) -- allow chaining
    end

    -- we couldn't resolve the color
    return "NONE"
end

return M
