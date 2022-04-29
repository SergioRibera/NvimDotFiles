local cmd = vim.cmd
local g = vim.g

vim.o.termguicolors = true

g.nim_tree_quit_on_open = 0
g.nvim_tree_group_empty = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_root_folder_modifier = ":~"
g.nvim_tree_special_files = { 'README.md', 'Makefile', 'MAKEFILE' }
g.nvim_tree_show_icons = {
    git = 1,
    folders = 1,
    files = 1
}

g.nvim_tree_icons = {
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

-- Mappings for nvimtree
_G.register_map (
"n",
"<leader>n",
":NvimTreeToggle<CR>",
{
    noremap = true,
    silent = true
}, "nvimtree", "Toggle between open/close NvimTree"
)

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

cmd "hi NvimTreeFolderIcon guifg = #61afef"
cmd "hi NvimTreeFolderName guifg = #61afef"
cmd "hi NvimTreeIndentMarker guifg=#383c44"

require'nvim-tree'.setup {
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
    system_open = {
       cmd  = nil,
        args = {}
    },
    filters = {
        dotfiles = false,
        custom = { ".git", "node_modules", ".cache", ".vscode", ".vs", "*.meta" }
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        width = 30,
        height = 30,
        hide_root_folder = false,
        side = 'left',
        preserve_window_proportions = true,
        mappings = {
            custom_only = false,
            list = {
                { key = "o", cb = tree_cb("edit") },
                { key = "<2-LeftMouse>", cb = tree_cb("edit") },
                { key = "v", cb = tree_cb("vsplit") },
                { key = "s", cb = tree_cb("split") },
                { key = "t", cb = tree_cb("tabnew") },
                { key = "C", cb = tree_cb("cd") },
                { key = "I", cb = tree_cb("toggle_ignored") },
                { key = "H", cb = tree_cb("toggle_dotfiles") },
                { key = "R", cb = tree_cb("refresh") },
                { key = "a", cb = tree_cb("create") },
                { key = "d", cb = tree_cb("remove") },
                { key = "r", cb = tree_cb("rename") },
                { key = "x", cb = tree_cb("cut") },
                { key = "c", cb = tree_cb("copy") },
                { key = "p", cb = tree_cb("paste") },
                { key = "-", cb = tree_cb("dir_up") },
                { key = "q", cb = tree_cb("close") }
            }
        },
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
            enable = false,
            global = false,
        },
        open_file = {
            quit_on_open = false,
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
    }
}
