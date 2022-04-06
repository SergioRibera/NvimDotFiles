require("gitsigns").setup {
    signs = {
        add = {hl = "DiffAdd", text = "▌", numhl = "GitSignsAddNr"},
        change = {hl = "DiffChange", text = "▌", numhl = "GitSignsChangeNr"},
        delete = {hl = "DiffDelete", text = "▌", numhl = "GitSignsDeleteNr"},
        topdelete = {hl = "DiffDelete", text = "▌", numhl = "GitSignsDeleteNr"},
        changedelete = {hl = "DiffChange", text = "▌", numhl = "GitSignsChangeNr"}
    },
    keymaps = {},
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },
    current_line_blame = true,
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    diff_opts = {
        internal = not vim.fn.has("windows"),
    }
}

local cmd = vim.cmd

cmd "hi DiffAdd guifg = #81A1C1 guibg = none"
cmd "hi DiffChange guifg = #838B97 guibg = none"
cmd "hi DiffModified guifg = #C88463 guibg = none"
cmd "hi DiffDelete guifg = #D76363 guibg = none"
