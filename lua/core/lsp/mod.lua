local settings_manager = require("nvim-conf")
local split_func = require("nvim-conf.utils").split_str
local notify = require("notify")

--      MySelf Implementation
local setup_sign_icons = require("core.lsp.sign_icons").setup
local setup_handlers = require("core.lsp.handlers").setup
-- local inlay_hints = require("core.lsp.inlay_hints")
local references = require("core.lsp.usages_ref")
local mappings = require("core.mappings")

local on_attach = function(_, bufnr)
    local function buf_set_option(name, value)
        vim.api.nvim_buf_set_option(bufnr, name, value)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- if (args.data and args.data.client_id) then
    --     inlay_hints.request(bufnr)
    -- end

    mappings.lsp_mapping()
    -- vim.api.nvim_create_autocmd({ "BufEnter" }, {
    --     callback = references.list_lsp_references
    -- })
    -- references.list_lsp_references()
end

setup_handlers()
setup_sign_icons()

--
-- Local server required
--
local servers_required_raw = settings_manager.get_value("lsp_servers", "sumneko_lua")

--[
--
--      Autoinstall
--
--]
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
require('core.lsp.servers').setup(on_attach)
