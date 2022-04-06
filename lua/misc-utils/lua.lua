local cmd = vim.cmd
local g = vim.g

g.instant_username = "s4rch"
g.vsnip_snippet_dir = "~/.config/nvim/snippets"
g.mapleader = " "
g.autoread = true
g.vimspector_enable_mappings = 'HUMAN'
g.kommentary_create_default_mappings = false

-- colorscheme related stuff
cmd "syntax enable"
cmd "syntax on"

-- local base16 = require "base16"
-- base16(base16.themes["material"], true)

-- Identline
g.indentLine_enabled = 1
g.indentLine_char_list = { "▏", '¦', '┆', '┊' }
g.ident_blankline_ident_level = 4
g.indent_blankline_show_current_context = true
g.indent_blankline_use_treesitter = true
g.indent_blankline_context_patterns = { 'class', 'function', 'method', 'void', 'keyword' }

-- Copilot Configs
g.copilot_no_tab_map = true
g.copilot_assume_mapped = true
g.copilot_tab_fallback = ""


--
--  Neovide Configurations
--
if g.neovide ~= nil then
    -- g.neovide_transparency=0.8                  -- Neovide Transparency
    g.neovide_cursor_antialiasing = true        -- Nevovide cursor Antialiasing
    -- g.neovide_cursor_vfx_mode = "railgun"       -- Neovide Efect on Move Cursor
    vim.g.neovide_cursor_vfx_mode = "ripple"        -- Neovide
end

vim.o.guifont = 'FiraCode Nerd Font:10;CaskaydiaCove Nerd Font:10'
g.indent_blankline_filetype_exclude = {"help", "terminal"}
g.indent_blankline_buftype_exclude = {"terminal"}

g.indent_blankline_show_trailing_blankline_indent = false
g.indent_blankline_show_first_indent_level = false

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

opt("o", "hidden", true)
opt("o", "ignorecase", true)
opt("o", "splitbelow", true)
opt("o", "splitright", true)
opt("o", "termguicolors", true)
opt("w", "number", true)
opt("o", "numberwidth", 1)
opt("w", "cul", true)

opt("o", "mouse", "a")

opt("w", "signcolumn", "yes")
opt("o", "cmdheight", 1)

opt("o", "updatetime", 250) -- update interval for gitsigns
opt("o", "clipboard", "unnamedplus")

-- for indenline
opt("b", "expandtab", true)
opt("b", "shiftwidth", 4)

opt("w", "rnu", true)
opt("o", "modelines", 0)
opt("o", "formatoptions", "tcqrn1")
opt("o", "autoindent", true)
opt("o", "smartindent", true)
opt("o", "guicursor", "")
opt("o", "scrolloff", 1)
opt("o", "backspace", "indent,eol,start")
opt("o", "ttyfast", true)
opt("o", "showmode", true)
opt("o", "showcmd", true)
--opt("o", "laststatus", 2)
opt("o", "encoding", "utf-8")
opt("o", "hlsearch", true)
opt("o", "incsearch", true)
opt("o", "ignorecase", true)
opt("o", "smartcase", true)

Presence = require("presence"):setup({
    auto_update       = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua Presence:update()`)
    editing_text      = "Editing %s",               -- Editing format string (either string or function(filename: string|nil, buffer: string): string)
    workspace_text    = "Working on %s",            -- Workspace format string (either string or function(git_project_name: string|nil, buffer: string): string)
    neovim_image_text = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
    main_image        = "neovim",                   -- Main image display (either "neovim" or "file")
    log_level         = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout  = 30,                         -- Number of seconds to debounce TextChanged events (or calls to `:lua Presence:update(<buf>, true)`)
})
--[
--
--      Custom Folding text
--
--]
function custom_fold_text()
    local line = vim.fn.getline(vim.v.foldstart)

    local start_arrow = '⏤⏤⏤⏤► '
    local lines='[ ' .. (vim.v.foldend - vim.v.foldstart + 1) .. ' lines ]'
    return start_arrow .. lines .. ': ' .. line .. ' '
end


-- folding
-- vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 20
vim.opt.foldlevel = 20
-- use wider line for folding
vim.opt.fillchars = { fold = '⏤' }
vim.opt.foldtext = 'v:lua.custom_fold_text()'


--[
--
--      Autocommands
--
--]
vim.api.nvim_command("autocmd BufWritePre,BufWinLeave ?* silent! mkview")
vim.api.nvim_command("autocmd BufWinEnter ?* silent! loadview")
vim.api.nvim_command("autocmd TextChanged,TextChangedI * silent! write")

local M = {}

function M.is_buffer_empty()
    -- Check whether the current buffer is empty
    return vim.fn.empty(vim.fn.expand("%:t")) == 1
end

function M.has_width_gt(cols)
    -- Check if the windows width is greater than a given number of columns
    return vim.fn.winwidth(0) / 2 > cols
end

M.isModuleAviable = function(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                return true
            end
        end
        return false
    end
end
return M
