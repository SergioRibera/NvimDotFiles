require "pluginsList.lua"
require "file-icons.lua"

require "misc-utils.lua"
require "tabline.lua".setup {
    show_index = false,
    show_modify = true,
    show_icon = true,
    show_close = false,
    separator = '',
    indicators = {
        modify = '•'
    },
    no_name = '[No Name]',
    colors = {
        selected = {
            bg = "#98c379",
            fg = "#1e222a"
        },
        disabled = {
            bg = "#3e4452",
            fg = "#abb2bf"
        },
        empty = "#282c34"
    }
}
require "statusline.lua"

require("colorizer").setup()

require"surround".setup{}

require("notify").setup({
    -- Animation style (see below for details)
    stages = "fade_in_slide_out",
    -- Default timeout for notifications
    timeout = 5000,
    background_colour = "#000000",
    -- Icons for the different levels
    icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
    },
})

-- lsp
require "mappings.lua"
require "lsp.init"
require "completion.lua"
require "comments.lua"
require "treesitter.lua"

require("cheatsheet").setup({
    bundled_cheatsheets = true,
    bundled_plugin_cheatsheets = true,
    include_only_installed_plugins = true,
})
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
