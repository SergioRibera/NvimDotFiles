require'nvim-treesitter'.setup {
    ensure_installed = {
        "c_sharp",
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
        use_languagetree = true
    },
}
