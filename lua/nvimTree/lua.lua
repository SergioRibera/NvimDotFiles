local cmd = vim.cmd
local g = vim.g

vim.o.termguicolors = true

g.nvim_tree_side = "left"
g.nvim_tree_width = 25
g.nvim_tree_ignore = {".git", "node_modules", ".cache", ".vscode", ".vs", "*.meta"}
g.nvim_tree_auto_open = 1
g.nvim_tree_auto_close = 0
g.nvim_tree_quit_on_open = 0
g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_hide_dotfiles = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_root_folder_modifier = ":~"
g.nvim_tree_tab_open = 1
g.nvim_tree_allow_resize = 1
g.nvim_tree_width_allow_resize  = 0
g.nvim_tree_lsp_diagnostics = 1
g.nvim_tree_special_files = { 'README.md', 'Makefile', 'MAKEFILE' }
g.nvim_tree_window_picker_exclude = {
    filetype = {
        'packer',
        'qf'
    },
    buftype = {
        'terminal'
    }
}
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
    },
    lsp = {
        hint = "",
        info = "",
        warning = "",
        error = "",
    }
}

-- Mappings for nvimtree
vim.api.nvim_set_keymap(
"n",
"<leader>n",
":NvimTreeToggle<CR>",
{
    noremap = true,
    silent = true
}
)

local tree_cb = require'nvim-tree.config'.nvim_tree_callback

g.nvim_tree_bindings = {
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

cmd "hi NvimTreeFolderIcon guifg = #61afef"
cmd "hi NvimTreeFolderName guifg = #61afef"
cmd "hi NvimTreeIndentMarker guifg=#383c44"
