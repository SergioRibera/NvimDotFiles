local settings_manager = require 'nvim-conf'
local notify = require("notify")

_G.my_mapping_table = {}
function _G.register_map(m, ls, rs, opts, c, d)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(m, ls, rs, options)
    if m == "" then
        m = " "
    end
    table.insert(_G.my_mapping_table, { mode = m, lhs = ls, rhs = rs, options = opts, category = c, description = d })
end

--
--  Cycle Themes
--
local base16 = require "base16"
local themes_names = {
    "monokai", "onedark", "nord", "flat", "google-dark", "solarized-dark", "tomorrow-night",
    "ocean", "oceanicnext", "macintosh",
    "gruvbox-dark-hard", "gruvbox-dark-medium", "gruvbox-dark-pale", "gruvbox-dark-soft", 
    -- "gruvbox-light-hard", "gruvbox-light-medium", "gruvbox-light-pale", "gruvbox-light-soft"
}
local log_cycle_theme = false
local base16_position = settings_manager.get_value("current_theme", 1)
base16_position = (base16_position - 1 % #themes_names) + 1
base16(base16.themes[themes_names[base16_position]], true)

function _G.cycle_teme ()
    base16_position = (base16_position % #themes_names) + 1
    base16(base16.themes[themes_names[base16_position]], true)
    settings_manager.set_value("current_theme", base16_position)
    notify("Theme changed to: " .. themes_names[base16_position], "info", { title="Theme Color", timeout=2000 })
    if log_cycle_theme == true then
        print(base16_position)
        print("Theme changed to: " .. themes_names[base16_position])
    end
end
function _G.cycle_inverse_teme()
    base16_position = (base16_position % #themes_names) - 1
    base16(base16.themes[themes_names[base16_position]], true)
    settings_manager.set_value("current_theme", base16_position)
    notify("Theme changed to: " .. themes_names[base16_position], "info", { title="Theme Color", timeout=2000 })
    if log_cycle_theme == true then
        print(base16_position)
        print("Theme changed to: " .. themes_names[base16_position])
    end
end



--
--  Mappings
--

_G.register_map("n", "<leader>tn", ":lua cycle_teme()<Cr>", {}, "themes", "Cycle to next theme")
_G.register_map("n", "<leader>tp", ":lua cycle_inverse_teme()<Cr>", {}, "themes", "Cycle to preview theme")
_G.register_map("n", "<C-h>", ":tabprevious<Cr>", {}, "tabs", "Go to preview tab") -- Move to prev tab
_G.register_map("n", "<C-l>", ":tabnext<Cr>", {}, "tabs", "Go to next tab") -- Move to next tab
_G.register_map("n", "<leader>y", '"+y', {}, "clipboard", "Copy into system clipboard") -- Copy any selected text
_G.register_map("n", "<leader>p", '"+p', {}, "clipboard", "Paste from system clipboard") -- Paste any text
_G.-- register_map("", "<leader>ws", ":split<Cr>") -- Open Split windows
_G.-- register_map("", "<leader>wh", ":vsplit<Cr>") -- Open Vertical split windows
_G.register_map("v", "<leader>ps", ":TakeScreenShot<Cr>", {}, "screenshot", "Take screenshot (SergioRibera/nvim-silicon)") -- Take Screenshot (require SergioRibera/vim-screenshot plugin)

-- Snippets enable jump to next cursor
_G.register_map('i', '<TAB>', 'v:lua.tab_complete()', { expr = true, noremap = false }, "completion", "Next completion suggest")

_G.register_map('i', '<S-TAB>', 'pumvisible() ? "<C-p>" : vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<S-TAB>"', {
  expr = true,
  noremap = false
}, "completion", "Preview completion suggest")
_G.register_map('s', '<TAB>', 'vsnip#available(1)  ? "<Plug>(vsnip-expand-or-jump)" : "<TAB>"', {
  expr = true,
  noremap = false
}, "completion", "Next completion suggest")
_G.register_map('s', '<S-TAB>', 'vsnip#available(-1)  ? "<Plug>(vsnip-jump-prev)" : "<S-TAB>"', {
  expr = true,
  noremap = false
}, "completion", "Preview completion suggest")

--
--  Save or Quit
--
_G.register_map("n", "<leader>q", ':q!<CR>', {}, "save", "Quit buffer")
_G.register_map("n", "<leader>w", ':w!<CR>', {}, "save", "Write buffer")
_G.register_map("n", "<leader>wq", ':x<CR>', {}, "save", "Write and close buffer")

-- OPEN TERMINALS --
local os_type = vim.bo.fileformat:upper()
if os_type == 'UNIX' or os_type == 'MAC' then
    _G.register_map("n", "<C-b>", [[<Cmd> split term://zsh | resize 10 <CR>]], {}, "terminal", "Open new zsh terminal on bottom") -- open term bottom
else
    _G.register_map("n", "<C-b>", [[<Cmd> split term://powershell | resize 10 <CR>]], {}, "terminal", "Open new powershell terminal on bottom") -- open term bottom
end
