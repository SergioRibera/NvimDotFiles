local settings_manager = require 'nvim-conf'
local notify = require("notify")
local base16 = require "base16"

M = {}

--
--  Cycle Themes
--
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

local function get_current_theme()
    return {
        name = themes_names[base16_position],
        theme = base16.themes[themes_names[base16_position]],
    }
end

local call_update_theme_event = function()
    settings_manager.set_value("current_theme", base16_position)
    notify("Theme changed to: " .. themes_names[base16_position], "info", { title = "Theme Color", timeout = 2000 })
    vim.api.nvim_exec_autocmds('User', {
        pattern = 'ThemeUpdate',
        data = get_current_theme(),
    })
end

function _G.cycle_teme()
    base16_position = ((base16_position) % #themes_names) + 1
    base16(base16.themes[themes_names[base16_position]], true)
    call_update_theme_event()
    if log_cycle_theme == true then
        print(base16_position)
        print("Theme changed to: " .. themes_names[base16_position])
    end
end

function _G.cycle_inverse_teme()
    base16_position = ((base16_position) % #themes_names) - 1
    base16(base16.themes[themes_names[base16_position]], true)
    call_update_theme_event()
    if log_cycle_theme == true then
        print(base16_position)
        print("Theme changed to: " .. themes_names[base16_position])
    end
end

M.cycle_teme = _G.cycle_teme
M.cycle_inverse_teme = _G.cycle_inverse_teme
M.get_current_theme = get_current_theme
M.call_update_theme_event = call_update_theme_event

return M
