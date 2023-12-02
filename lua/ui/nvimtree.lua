local cmd = vim.cmd
vim.o.termguicolors = true

-- Mappings for nvimtree
_G.register_map(
    "n",
    "<leader>n",
    ":NvimTreeToggle<CR>",
    {
        noremap = true,
        silent = true
    }, "nvimtree", "Toggle between open/close NvimTree"
)

cmd "hi NvimTreeFolderIcon guifg = #61afef"
cmd "hi NvimTreeFolderName guifg = #61afef"
cmd "hi NvimTreeIndentMarker guifg=#383c44"

local function on_attach(bufnr)
    local api = require('nvim-tree.api')
    -- Load default mappings
    api.config.mappings.default_on_attach(bufnr)

    local function opts(desc)
        return { desc = desc, noremap = true, silent = true, nowait = true }
    end

    local maps = {
        { "n", "o", api.node.open.vertical,        opts('Open: Vertical Split'),   "nvimtree" },
        { "n", "v", api.node.open.vertical,        opts('Open: Vertical Split'),   "nvimtree" },
        { "n", "s", api.node.open.horizontal,      opts('Open: Horizontal Split'), "nvimtree" },
        { "n", "t", api.node.open.tab,             opts('Open: New Tab'),          "nvimtree" },
        { "n", "I", api.tree.toggle_custom_filter, opts('Toggle Hidden'),          "nvimtree" },
    }

    for _, map in pairs(maps) do
        _G.register_map(map[1], map[2], map[3], map[4], map[5], nil)
        local o = vim.tbl_extend("force", { buffer = bufnr }, map[4])
        vim.keymap.set(map[1], map[2], map[3], o)
    end
end

require("nvim-tree").setup {
    on_attach = on_attach,
    disable_netrw = true,
    renderer = {
        group_empty = true,
        highlight_git = true,
        special_files = { 'README.md', 'Makefile', 'MAKEFILE', 'Makefile.toml' },
        icons = {
            glyphs = {
                default = " ",
                symlink = " ",
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "●"
                },
                folder = {
                    default = "",
                    open = "",
                    symlink = ""
                }
            }
        }
    },
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        }
    },
    update_focused_file = {
        enable      = true,
        update_cwd  = false,
        ignore_list = {}
    },
    filters = {
        dotfiles = false,
        custom = { ".git$", "node_modules$", ".cache$", ".vscode$", ".vs$", "*.meta$" }
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        width = 30,
        side = 'left',
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "yes"
    },
    trash = {
        cmd = "trash",
        require_confirm = true
    },
    actions = {
        change_dir = {
            enable = true,
            global = false,
        },
        open_file = {
            quit_on_open = true,
            resize_window = false,
            window_picker = {
                enable = true,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", },
                    buftype  = { "nofile", "terminal", "help", },
                }
            }
        }
    },
}
