local settings_manager = require("nvim-conf")
local split_func = require("nvim-conf.utils").split_str
local utils = require('core.utils')
local lspconfig = require('lspconfig')

--      MySelf Implementation
local setup_sign_icons = require("core.lsp.sign_icons").setup
local handlers = require("core.lsp.handlers")

-- Override handlers
handlers.override_handlers()
setup_sign_icons()

--
-- Local server required
--
local servers_required_raw = settings_manager.get_value("lsp_servers", "lua_ls")

-- Autoinstall
local servers = split_func(servers_required_raw, ',')
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = false,
})
require("mason").setup({
    ui = {
        check_outdated_packages_on_open = true,
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
-- Load and configure servers
for _, server in ipairs(servers) do
    local mod = "core.lsp.servers." .. server
    if utils.isModuleAvailable(mod) then
        require(mod).setup(handlers.on_attach, handlers.capabilities)
    else
        lspconfig[server].setup({
            on_attach = handlers.on_attach,
            capabilities = handlers.capabilities,
        })
    end
end
