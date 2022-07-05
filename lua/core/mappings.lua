local settings_manager = require 'nvim-conf'
local notify = require("notify")

_G.my_mapping_table = {}
local mapping_table_contains = function (t, v)
    for _, value in ipairs(t) do
        if value.mode == v.mode and value.lhs == v.lhs and value.category == v.category then
            return true
        end
    end
    return false
end
function _G.register_map(m, ls, rs, opts, c, d)
    local options = {noremap = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(m, ls, rs, options)
    if m == "" then
        m = " "
    end
    local data = { mode = m, lhs = ls, rhs = rs, options = opts, category = c, description = d }
    if not mapping_table_contains(_G.my_mapping_table, data) then
        table.insert(_G.my_mapping_table, data)
    end
end

--
--  Cycle Themes
--
local base16 = require "base16"
local themes_names = {
    "monokai", "onedark", "nord", "flat", "google-dark", "solarized-dark", "tomorrow-night",
    "ocean", "oceanicnext", "macintosh",
    "gruvbox-dark-hard", "gruvbox-dark-medium", "gruvbox-dark-pale", "gruvbox-dark-soft",
    "gruvbox-light-hard", "gruvbox-light-medium", "gruvbox-light-pale", "gruvbox-light-soft"
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
-- _G.register_map("", "<leader>ws", ":split<Cr>") -- Open Split windows
-- _G.register_map("", "<leader>wh", ":vsplit<Cr>") -- Open Vertical split windows
_G.register_map("v", "<leader>ps", ":TakeScreenShot<Cr>", {}, "screenshot", "Take screenshot (SergioRibera/nvim-silicon)") -- Take Screenshot (require SergioRibera/vim-screenshot plugin)

--
--  Save or Quit
--
_G.register_map("n", "<leader>q", ':q!<CR>', {}, "save", "Quit buffer")
_G.register_map("n", "<leader>w", ':w!<CR>', {}, "save", "Write buffer")
_G.register_map("n", "<leader>wq", ':x<CR>', {}, "save", "Write and close buffer")

_G.register_map("n", "<Leader>dd", ":call vimspector#Launch()<CR>", {}, "viminspector", "")
_G.register_map("n", "<Leader>de", ":call vimspector#Reset()<CR>", {}, "viminspector", "")
_G.register_map("n", "<Leader>dc", ":call vimspector#Continue()<CR>", {}, "viminspector", "")
_G.register_map("n", "<Leader>dt", ":call vimspector#ToggleBreakpoint()<CR>", {}, "viminspector", "")
_G.register_map("n", "<Leader>dT", ":call vimspector#ClearBreakpoints()<CR>", {}, "viminspector", "")
_G.register_map("n", "<Leader>dk", "<Plug>VimspectorRestart", {}, "viminspector", "")
_G.register_map("n", "<Leader>dh", "<Plug>VimspectorStepOut", {}, "viminspector", "")
_G.register_map("n", "<Leader>dl", "<Plug>VimspectorStepInto", {}, "viminspector", "")
_G.register_map("n", "<Leader>dj", "<Plug>VimspectorStepOver", {}, "viminspector", "")

-- OPEN TERMINALS --
local os_type = vim.bo.fileformat:upper()
if os_type == 'UNIX' or os_type == 'MAC' then
    -- Detect if exists a command
    local default_terminal = vim.fn.expand("$SHELL")
    if default_terminal == "/bin/zsh" or default_terminal == '/usr/bin/zsh' then
        _G.register_map("n", "<C-b>", [[<Cmd> split term://zsh | resize 10 <CR>]], {}, "terminal", "Open new zsh terminal on bottom") -- open term bottom
    elseif default_terminal == '/bin/fish' or default_terminal == '/usr/bin/fish' then
        _G.register_map("n", "<C-b>", [[<Cmd> split term://fish | resize 10 <CR>]], {}, "terminal", "Open new fish terminal on bottom") -- open term bottom
    else
        _G.register_map("n", "<C-b>", [[<Cmd> split term://bash | resize 10 <CR>]], {}, "terminal", "Open new terminal on bottom") -- open term bottom
    end
else
    _G.register_map("n", "<C-b>", [[<Cmd> split term://powershell | resize 10 <CR>]], {}, "terminal", "Open new powershell terminal on bottom") -- open term bottom
end
