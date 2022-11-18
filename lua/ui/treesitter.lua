require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "c_sharp",
        "comment",
        "javascript",
        "tsx",
        "typescript",
        "html",
        "css",
        "bash",
        "lua",
        "json",
        "python",
        "cpp",
        "rust",
        "dart",
        "regex"
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        colors = {
            '#bf616a',
            '#d08770',
            '#ebcb8b',
            '#a3be8c',
            '#88c0d0',
            '#5e81ac',
            '#b48ead',
        }
    },
}

vim.g.rainbow_active = 1
