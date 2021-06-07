-- misc-utils.oneinstance"
-- load all plugins
require "pluginsList.lua"
require "file-icons.lua"

require "misc-utils.lua"
-- require "bufferline.lua"
require "lualine.lua"

require("colorizer").setup()

require"surround".setup{}
require("kommentary.lua")

-- lsp
require "lsp.init"
require "completion.lua"

local cmd = vim.cmd
local g = vim.g

g.instant_username = "s4rch"
g.vsnip_snippet_dir = "~/.config/nvim/snippets"
g.mapleader = " "
g.auto_save = 0
g.kommentary_create_default_mappings = false

-- colorscheme related stuff
cmd "syntax enable"
cmd "syntax on"

-- local base16 = require "base16"
-- base16(base16.themes["material"], true)

-- blankline

g.indentLine_enabled = 1
g.indentLine_char_list = { "▏", '¦', '┆', '┊' }
g.ident_blankline_ident_level = 4
-- g.indent_blankline_char = "▏"

--
--  Neovide Configurations
--
-- g.neovide_transparency=0.8                  " Neovide Transparency
g.neovide_cursor_antialiasing = true        -- Nevovide cursor Antialiasing
-- g.neovide_cursor_vfx_mode = "railgun"       -- Neovide Efect on Move Cursor
g.neovide_cursor_vfx_mode = "ripple"        -- Neovide
-- set guifont=Inconsolata:h15
-- set guifont=NotoSansMono:h15
-- set guifont=Hack:15;Iosevka:15;NotoSansMono:h15


g.indent_blankline_filetype_exclude = {"help", "terminal"}
g.indent_blankline_buftype_exclude = {"terminal"}

g.indent_blankline_show_trailing_blankline_indent = false
g.indent_blankline_show_first_indent_level = false

require "mappings.lua"
require "treesitter.lua"

require "telescope.lua"
require "nvimTree.lua"
require "instant"

-- git signs
require "gitsigns.lua"

require("nvim-autopairs").setup()

require("lspkind").init(
{
    with_text = true,
    symbol_map = {
        Folder = "",
        Enum = ""
    }
}
)
-- hide line numbers in terminal windows
vim.api.nvim_exec([[
au BufEnter term://* setlocal nonumber
]], false)
