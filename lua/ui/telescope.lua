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
        },
    }
}

require("telescope").load_extension("media_files")
require("telescope").load_extension("ui-select")

local opt = {noremap = true, silent = true}
-- vim.g.mapleader = " "
-- mappings
_G.register_map("n", "<Leader>ff", [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], opt, "telescope", "Show and find files on workspace with preview")

-- git
_G.register_map("n", "<Leader>gc", [[<Cmd>lua require('telescope.builtin').git_commits()<CR>]], opt, "telescope", "Show commits on git project")
_G.register_map("n", "<Leader>gbc", [[<Cmd>lua require('telescope.builtin').git_bcommits()<CR>]], opt, "telescope", "Show commits on current file")
_G.register_map("n", "<Leader>gb", [[<Cmd>lua require('telescope.builtin').git_branches()<CR>]], opt, "telescope", "Show git branches, can checkout on any")
_G.register_map("n", "<Leader>gs", [[<Cmd>lua require('telescope.builtin').git_status()<CR>]], opt, "telescope", "Lists current changes per file with diff preview and add action")
_G.register_map("n", "<Leader>gt", [[<Cmd>lua require('telescope.builtin').git_stash()<CR>]], opt, "telescope", "Show Lists stash items in current repository with ability to apply them on Enter press")
_G.register_map("n", "<Leader>lg", [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]], opt, "telescope", "Show regex content on all files on workspace")

-- help keymaps
-- _G.register_map("n", "<Leader>hk", [[<Cmd>lua require('telescope.builtin').keymaps()<CR>]], opt, "telescope", "Show ")
_G.register_map("n", "<Leader>hk", [[<Cmd>lua show_my_keymaps()<CR>]], opt, "telescope", "Show all my commands to help you")
_G.register_map("n", "<Leader>?", [[<Cmd>Cheatsheet<CR>]], opt, "telescope", "Show all cheatsheet on Neovim config")

-- Extensions
_G.register_map("n", "<Leader>se", [[<Cmd>Telescope emoji<CR>]], opt, "telescope", "Show emojis for easy implementation")
_G.register_map(
"n",
"<Leader>fp",
[[<Cmd>lua require('telescope').extensions.media_files.media_files()<CR>]],
opt, "telescope", "Show all media files on project with preview (if is compatible)"
)

-- highlights
local cmd = vim.cmd

cmd "hi TelescopeBorder guifg = #31314A"
cmd "hi TelescopePromptBorder guifg = #31314A"
cmd "hi TelescopeResultsBorder guifg = #31314A"
cmd "hi TelescopePreviewBorder guifg = #525865"


-- Custom show keymaps
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local config = require("telescope.config").values
local entry_display = require('telescope.pickers.entry_display')

function _G.show_my_keymaps(opts)
    local keymaps_table = _G.my_mapping_table

    -- for _, mode in pairs(modes) do
    --     local buf_local = vim.api.nvim_buf_get_keymap(0, mode)
    --     for _, keymap in pairs(buf_local) do
    --         table.insert(keymaps_table, keymap)
    --     end
    -- end

    pickers.new({
        prompt_title = "My Custom Key Maps",
        finder = finders.new_table {
            results = keymaps_table,
            entry_maker = function(entry)
                if entry.mode == "i" then
                    entry.mode = "Insert"
                elseif entry.mode == "v" or entry.mode == "x" then
                    entry.mode = "Visual"
                elseif entry.mode == "s" then
                    entry.mode = "Select"
                elseif entry.mode == "n" then
                    entry.mode = "Normal"
                elseif entry.mode == "t" then
                    entry.mode = "Terminal"
                end

                local width = config.width or config.layout_config.width or config.layout_config[config.layout_strategy].width
                local cols = vim.o.columns
                local tel_win_width
                if width > 1 then
                    tel_win_width = width
                else
                    tel_win_width = math.floor(cols * width)
                end
                local cheatcode_width = math.floor(cols * 0.25)
                local section_width = 15

                -- NOTE: the width calculating logic is not exact, but approx enough
                local displayer = entry_display.create {
                    separator = " ▏",
                    items = {
                        { width = 7 }, -- mode
                        { width = section_width }, -- category
                        { width = section_width }, -- mapping
                        { width = tel_win_width - cheatcode_width
                                - section_width, }, -- description
                    },
                }

                local function make_display(ent)
                    return displayer {
                        -- text, highlight group
                        { ent.value.mode, "cheatCode" },
                        { ent.value.category, "cheatMetadataSection" },
                        { ent.value.lhs, "cheatMetadataSection" },
                        { ent.value.description, "cheatDescription" },
                    }
                end

                return {
                    value = entry,
                    -- generate the string that user sees as an item
                    display = make_display,
                    -- queries are matched against ordinal
                    ordinal = string.format(
                        '%s %s %s %s', entry.mode, entry.category, entry.lhs, entry.description
                    ),
                }
            end,
        },
        sorter = config.generic_sorter(opts),
--         attach_mappings = function(prompt_bufnr)
--             actions.select_default:replace(function()
--                 local selection = action_state.get_selected_entry()
--                 if selection == nil then
--                     print "[telescope] Nothing currently selected"
--                     return
--                 end
--
--                 vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(selection.value.lhs, true, false, true), "t", true)
--                 return actions.close(prompt_bufnr)
--             end)
--             return true
--         end,
    }):find()
end

