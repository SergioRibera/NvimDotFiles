require("telescope").setup {
    defaults = {
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case'
        },
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        -- prompt_prefix = " ",
        -- selection_caret = " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = false,
            },
        },
        file_sorter =  require'telescope.sorters'.get_fuzzy_file,
        file_ignore_patterns = {},
        generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
        winblend = 0,
        border = {},
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        use_less = true,
        path_display = {},
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
    },
    extensions = {
        media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg"},
            find_cmd = "rg" -- find command (defaults to `fd`)
        }
    }
}

require("telescope").load_extension("media_files")

local opt = {noremap = true, silent = true}
vim.g.mapleader = " "
-- mappings
vim.api.nvim_set_keymap("n", "<Leader>ff", [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], opt)
vim.api.nvim_set_keymap(
"n",
"<Leader>fp",
[[<Cmd>lua require('telescope').extensions.media_files.media_files()<CR>]],
opt
)

-- git
vim.api.nvim_set_keymap("n", "<Leader>gc", [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>gbc", [[<Cmd>lua require('telescope.builtin').git_bcommits()<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>gb", [[<Cmd>lua require('telescope.builtin').git_branches()<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>gs", [[<Cmd>lua require('telescope.builtin').git_status()<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>gt", [[<Cmd>lua require('telescope.builtin').git_stash()<CR>]], opt)
vim.api.nvim_set_keymap("n", "<Leader>lg", [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], opt)
-- highlights

local cmd = vim.cmd

cmd "hi TelescopeBorder guifg = #31314A"
cmd "hi TelescopePromptBorder guifg = #31314A"
cmd "hi TelescopeResultsBorder guifg = #31314A"
cmd "hi TelescopePreviewBorder guifg = #525865"
