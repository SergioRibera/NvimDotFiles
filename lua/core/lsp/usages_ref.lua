local utils = require "core.lsp.utils"
local cfg = require 'nvim-conf'
local references_hints_ns = vim.api.nvim_create_namespace("lsp.references.count.inlay_hints")

local CONFIG_NS = 'lsp.ref.'

local enable = cfg.get_value(CONFIG_NS .. 'enable', "true")
local show_symbol_name = cfg.get_value(CONFIG_NS .. 'show_symbol_name', "false")
local inline_vt = cfg.get_value(CONFIG_NS .. 'inline_vt', "true")
local prefix = cfg.get_value(CONFIG_NS .. 'prefix', "~>")

local SPACE = "space"
local highlight = "Comment"
M = {}

local function lsp_list(action, opts, callback)
    local params = opts or vim.lsp.util.make_position_params()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.lsp.buf_request(bufnr, action, params, function(err, result, ctx, _)
        if err then
            vim.api.nvim_err_writeln("Error when executing " .. action .. " : " .. err.message)
            return
        end
        local flattened_results = {}
        if result then
            -- textDocument/definition can return Location or Location[]
            if not vim.tbl_islist(result) then
                flattened_results = { result }
            end

            vim.list_extend(flattened_results, result)
        end

        local offset_encoding = vim.lsp.get_client_by_id(ctx.client_id).offset_encoding

        callback(flattened_results, bufnr, offset_encoding, ctx)
    end)
end

-- opts.bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
-- opts.winnr = opts.winnr or vim.api.nvim_get_current_win()

local function distance_between_cols(bufnr, lnum, start_col, end_col)
    local lines = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)
    if vim.tbl_isempty(lines) then
        -- This can only happen is the line is somehow gone or out-of-bounds.
        return 0
    end

    local sub = string.sub(lines[1], start_col, end_col)
    -- Count spaces before first character
    -- local fist_line = lines[1]
    -- if fist_line:sub(1, 1) ~= ' ' or fist_line:sub(1, 1) ~= '\t' then
    --     return 1
    -- end
    -- local total = 0
    -- for i = 1, #fist_line do
    --     local c = fist_line:sub(i, i)
    --     if c == ' ' then
    --         total = total + 1
    --     elseif c == '\t' then
    --         total = total + 4
    --     else
    --         break
    --     end
    -- end
    return vim.fn.strdisplaywidth(sub, 0) -- these are indexed starting at 0
    --
    -- return total
end

local function show_references(references)
    if not references or vim.tbl_isempty(references) then
        return
    end

    local vlines = {}
    local lnum = symbol.lnum - 1
    local opts = { hl_mode = 'combine', virt_text = vlines }
    local tb_ref = vim.lsp.util.locations_to_items(references, o)
    print(symbol.text .. ': ' .. utils.dump(tb_ref))
    -- If inline vrtual text is not enabled
    if inline_vt == 'false' then
        lnum = symbol.lnum - 2
        opts = { virt_lines = { vlines } }
        -- Make space from left
        vim.list_extend(vlines,
            { { string.rep(" ", distance_between_cols(bufnr, symbol.lnum, 0, symbol.col)), SPACE } })
    end
    -- Add text to show
    local t = (show_symbol_name == 'true' and " for " .. symbol.text) or ''
    vim.list_extend(vlines, { { prefix .. " " .. #tb_ref .. " References" .. t, highlight } })
    -- Show the virtual lines
    vim.api.nvim_buf_set_extmark(bufnr, references_hints_ns, lnum, 0, opts)
end

M.list_lsp_references = function()
    -- local opts = vim.tbl_extend('force', o, { textDocument = vim.lsp.util.make_text_document_params() })
    if enable == 'false' then
        return
    end

    -- lsp_list("textDocument/documentSymbol", nil,
    vim.lsp.buf.document_symbol({ on_list = function(result, bufnr, _, _)
        if not result or vim.tbl_isempty(result) then
            -- TODO: show notification(?
            return
        end
        vim.api.nvim_buf_clear_namespace(bufnr, references_hints_ns, 0, -1)
        local locations = vim.lsp.util.symbols_to_items(result or {}, bufnr) or {}
        for _, raw_symbol in ipairs(locations) do
            local symbol = utils.gen_from_lsp_symbols(raw_symbol)
            -- NOTE: on here we capture all references for the symbol and get all references count for generate text
            local params = {
                position = {
                    character = symbol.col,
                    line = symbol.lnum,
                },
                context = { includeDeclaration = true },
                textDocument = vim.lsp.util.make_text_document_params()
            }
            -- lsp_list("textDocument/references", params,
            vim.lsp.buf.references(params, { on_list = function(references, _, o, _)
            end })
        end
    end })
    -- lsp_list("textDocument/implementation", nil, function(result, _, _)
    -- end)
    -- lsp_list("textDocument/definition", function(_, _)
    -- end)
    -- lsp_list("textDocument/typeDefinition", function(_, _)
    -- end)
end

return M
