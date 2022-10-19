require("ui.themes")
require("ui.treesitter")
require("colorizer").setup()
require("ui.nvimtree")
require("ui.telescope")
require("ui.statusline")
require("ui.tabline.mod").setup {
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
require("notify").setup({
    stages = "fade_in_slide_out",
    timeout = 5000,
    background_colour = "#000000",
    icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
    },
})
