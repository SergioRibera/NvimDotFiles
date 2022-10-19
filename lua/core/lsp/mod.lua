local lsp_installer = require("nvim-lsp-installer")
local lsp_installer_servers = require("nvim-lsp-installer.servers")
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
    references.list_lsp_references()
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities
    }

    if server.name == "sumneko_lua" then
        opts = {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = function()
                return vim.loop.cwd()
            end,
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                        path = vim.split(package.path, ";")
                    },
                    diagnostics = {
                        globals = { "vim" }
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                        }
                    },
                    telemetry = {
                        enable = false
                    }
                }
            }
        }
    elseif server.name == "omnisharp" then
        opts = {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                FormattingOptions = {
                    EnableEditorConfigSupport = true
                },
                ImplementTypeOptions = {
                    InsertionBehavior = 'WithOtherMembersOfTheSameKind',
                    PropertyGenerationBehavior = 'PreferAutoProperties'
                },
                RenameOptions = {
                    RenameInComments = true,
                    RenameInStrings  = true,
                    RenameOverloads  = true
                },
                RoslynExtensionsOptions = {
                    EnableAnalyzersSupport = true,
                    EnableDecompilationSupport = true,
                    EnableImportCompletion = true,
                    locationPaths = {}
                }
            }
        }
    end
    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
end)

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
for s in pairs(servers) do
    local ok, each_server = lsp_installer_servers.get_server(servers[s])
    if ok then
        if not each_server:is_installed() then
            each_server:install()
        end
    else
        notify("LSP Server \"" .. servers[s] .. "\" not recognized", "warn", { title = "LSP Autoinstall", timeout = 1000 })
    end
end
