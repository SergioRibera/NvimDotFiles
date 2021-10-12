vim.cmd [[packadd nvim-lspconfig]]
vim.cmd [[packadd nvim-compe]]

vim.o.completeopt = "menuone,noselect"

require "compe".setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = "enable",
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,
    source = {
        path = true,
        buffer = true,
        calc = true,
        vsnip = true,
        nvim_lsp = true,
        nvim_lua = true,
        spell = true,
        tags = true,
        snippets_nvim = true,
        treesitter = true
    }
}
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col(".") - 1
    if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
        return true
    else
        return false
    end
end
-- tab completion

_G.tab_complete = function()
    if vim.fn['vsnip#jumpable'](1) > 0 then
        return t '<Plug>(vsnip-jump-next)'
    end
    if vim.fn.pumvisible() > 0 then
        return t '<C-n>'
    end
    if check_back_space() then
        return t '<TAB>'
    end
    if vim.fn['vsnip#expandable']() > 0 then
        return t '<Plug>(vsnip-expand)'
    end

    return vim.fn["compe#complete"]()
end
_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
    elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t "<S-Tab>"
    end
end

--  mappings

-- _G.register_map("i", "<Tab>", "v:lua.tab_complete()", {expr = true}, "completion", "")
-- _G.register_map("s", "<Tab>", "v:lua.tab_complete()", {expr = true}, "completion", "")
-- _G.register_map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true}, "completion", "")
-- _G.register_map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true}, "completion", "")

function _G.completions()
    local npairs = require("nvim-autopairs")
    if vim.fn.pumvisible() == 1 then
        if vim.fn.complete_info()["selected"] ~= -1 then
            return vim.fn["compe#confirm"]("<CR>")
        end
    end
    return npairs.check_break_line_char()
end

_G.register_map("i", "<CR>", "v:lua.completions()", {expr = true})
