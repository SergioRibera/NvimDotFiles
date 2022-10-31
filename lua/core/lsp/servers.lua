local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

M = {}

M.setup = function(on_attach)
    --[
    --  General Configuration
    --]
    require("mason-lspconfig").setup_handlers {
        function (server_name)
            lspconfig[server_name].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end,
    }
    --[
    --  sumneko_lua
    --]
    lspconfig.sumneko_lua.setup( {
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
    })
    --[
    --  Omnisharp
    --]
    lspconfig.omnisharp.setup({
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
    })
end

return M
