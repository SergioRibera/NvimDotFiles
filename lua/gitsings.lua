require("gitsigns").setup {
    signs              = {
        add          = { hl = 'GitSignsAdd', text = '▌', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change       = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete       = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete    = { hl = 'GitSignsDelete', text = '▌', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    },
    signcolumn         = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl              = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl             = true, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff          = true, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir       = {
        interval = 1000,
        follow_files = true
    },
    current_line_blame = true,
    sign_priority      = 6,
    update_debounce    = 100,
    status_formatter   = nil,
}

local cmd = vim.cmd

cmd "hi DiffAdd guifg = #81A1C1"
-- cmd "hi DiffChange guifg = #838B97"
cmd "hi DiffChange guifg = #C88463"
cmd "hi DiffDelete guifg = #D76363"


-- cmd "hi GitSignsCurrentLineBlame guifg = #81A1C1"
-- cmd "hi GitSignsChange guifg = #838B97"
-- cmd "hi GitSignsModified guifg = #C88463"
-- cmd "hi GitSignsDelete guifg = #D76363"
