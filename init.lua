require("plugins")
require("misc")

require "nvim-conf".setup{
    conf_file = vim.fn.stdpath("config") .. "/lua_settings.conf",
    load_event = "setup",
    on_load = function (_)
    end
}

require("core.mod")
require("ui.mod")

require("cheatsheet").setup({
    bundled_cheatsheets = true,
    bundled_plugin_cheatsheets = true,
    include_only_installed_plugins = true,
})
