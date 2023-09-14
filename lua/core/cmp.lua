local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
local neogen = require('neogen')

vim.o.completeopt = "menu,menuone,noselect"

-- Local functions
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

--[
--
--      Cmp Config
--
--]
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            maxwidth = 50,
            menu = { buffer = "[Buf]", cmp_tabnine = "", nvim_lsp = "[LSP]", dictionary = "[Dict]", vsnip = "[Vsnip]" }
        })
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if neogen.jumpable() then
                neogen.jump_next()
            elseif cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                -- cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if neogen.jumpable(true) then
                neogen.jump_prev()
            elseif cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                -- cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
                fallback()
            end
        end, { "i", "s" }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ select = false }),
        }),
    },
    sources = cmp.config.sources({
        {
            name = "nvim_lsp",
            entry_filter = function(entry)
                return not (entry:get_kind() == require("cmp.types").lsp.CompletionItemKind.Snippet
                    and entry.source:get_debug_name() == "nvim_lsp:emmet_ls")
            end,
        },
        { name = 'path' },
        { name = 'luasnip' },
        { name = 'omni' },
    }, {
        { name = 'buffer' },
    }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

vim.cmd("autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }")
