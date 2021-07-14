require "pluginsList.lua"
require "file-icons.lua"

require "misc-utils.lua"
require "tabline.lua".setup {
    show_index = false,
    show_modify = true,
    show_icon = true,
    show_close = false,
    separator = '',
    spacing = '',
    indicators = {
        modify = '●'
    },
    no_name = '[No Name]',
    colors = {
        selected = {
            bg = "#81A1C1",
            fg = "#1e222a"
        },
        disabled = {
            bg = "#72767b",
            -- bg = "#808892",
            fg = "#1e222a"
        },
        empty = "#282c34"
    }
}
require "statusline.lua"

require("colorizer").setup()

require"surround".setup{}

-- lsp
require "lsp.init"
require "completion.lua"
require "comments.lua"
require "mappings.lua"
require "treesitter.lua"

require "telescope.lua"
require "nvimTree.lua"
require "instant"

-- git signs
require "gitsigns.lua"

require("nvim-autopairs").setup()
-- require("nvim-autopairs").disable()

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
-- vim.api.nvim_exec([[
-- au BufEnter term://* setlocal nonumber
-- ]], false)
-- 
