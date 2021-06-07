local ts_config = require("nvim-treesitter.configs")

ts_config.setup {
    ensure_installed = {
        "c_sharp",
        "javascript",
        "tsx",
        "typescript",
        "html",
        "php",
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
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            scope_incremental = "<CR>",
            node_incremental = "<TAB>",
            node_decremental = "<S-TAB>",
        },
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {},
        },
    },
    refactor = {
        highlight_definitions = {
            enable = true,
        },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "grr",
            },
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition = "gd",
                goto_next_usage = "]d",
                goto_previous_usage = "[d",
            },
        },
    },
    playground = {enable = true},
    query_linter = {enable = true},
}
