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
}
