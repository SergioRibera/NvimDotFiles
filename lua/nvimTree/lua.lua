local cmd = vim.cmd
local g = vim.g

vim.o.termguicolors = true

g.nvim_tree_ignore = { ".git", "node_modules", ".cache", ".vscode", ".vs", "*.meta" }
g.nim_tree_quit_on_open = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_group_empty = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_root_folder_modifier = ":~"
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
  -- disables netrw completely
  disable_netrw       = true,
  -- hijack netrw window on startup
  hijack_netrw        = true,
  -- open the tree when running this setup function
  open_on_setup       = false,
  -- will not open on setup if the filetype is in this list
  ignore_ft_on_setup  = {},
  -- closes neovim automatically when the tree is the last **WINDOW** in the view
  auto_close          = false,
  -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
  open_on_tab         = false,
  -- hijacks new directory buffers when they are opened.
  update_to_buf_dir   = {
      enable = true,
      auto_open = true
  },
  -- hijack the cursor in the tree to put it at the start of the filename
  hijack_cursor       = false,
  -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually) 
  update_cwd          = true,
  -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
  update_focused_file = {
    -- enables the feature
    enable      = true,
    -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
    -- only relevant when `update_focused_file.enable` is true
    update_cwd  = true,
    -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
    -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
    ignore_list = {}
  },
  -- configuration options for the system open command (`s` in the tree by default)
  system_open = {
    -- the command to run this, leaving nil should work in most cases
    cmd  = nil,
    -- the command arguments as a list
    args = {}
  },

  view = {
    -- width of the window, can be either a number (columns) or a string in `%`
    width = 30,
    -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
    side = 'left',
    -- if true the tree will resize itself after opening a file
    auto_resize = true,
    mappings = {
      -- custom only false will merge the list with the default mappings
      -- if true, it will only use your list to set the mappings
      custom_only = false,
      -- list of mappings to set on the tree manually
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
    }
  }
}
