local messages = require("core.lsp.progress.messaging").messages
local aliases = {}

local config = {
    current_function = true,
    show_filename = true,
    component_separator = ' ',
    indicator_ok = '',
    spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
    status_symbol = '  ',
}

local function get_lsp_progress()
    local buf_messages = messages()
    local msgs = {}

    for _, msg in ipairs(buf_messages) do
        local name = aliases[msg.name] or msg.name
        local client_name = '[' .. name .. ']'
        local contents
        if msg.progress then
            contents = msg.title
            if msg.message then contents = contents .. ' ' .. msg.message end

            -- this percentage format string escapes a percent sign once to show a percentage and one more
            -- time to prevent errors in vim statusline's because of it's treatment of % chars
            if msg.percentage then contents = contents .. string.format(" (%.0f%%%%)", msg.percentage) end

            if msg.spinner then
                contents = config.spinner_frames[(msg.spinner % #config.spinner_frames) + 1] .. ' ' ..
                    contents
            end
        elseif msg.status then
            contents = msg.content
            if config.show_filename and msg.uri then
                local filename = vim.uri_to_fname(msg.uri)
                filename = vim.fn.fnamemodify(filename, ':~:.')
                local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
                if #filename > space then filename = vim.fn.pathshorten(filename) end

                contents = '(' .. filename .. ') ' .. contents
            end
        else
            contents = msg.content
        end

        table.insert(msgs, client_name .. ' ' .. contents)
    end
    return table.concat(msgs, config.component_separator)
end

local function get_lsp_statusline(bufnr)
    bufnr = bufnr or 0
    if vim.tbl_count(vim.lsp.buf_get_clients(bufnr)) == 0 then return '' end

    local msgs = get_lsp_progress()

    local base_status = vim.trim(config.component_separator .. ' ' .. msgs)
    local symbol = config.status_symbol .. ' '
    if config.current_function then
        local current_function = vim.b.lsp_current_function
        if current_function and current_function ~= '' then
            symbol = symbol .. '(' .. current_function .. ')' .. config.component_separator
        end
    end

    if base_status ~= '' then return symbol .. base_status .. ' ' end
    if not config.diagnostics then return symbol end
    return symbol .. config.indicator_ok .. ' '
end

local M = {
    status = get_lsp_statusline,
}

return M
