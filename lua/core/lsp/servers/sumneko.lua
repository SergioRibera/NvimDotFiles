local M = {}

M.setup = function(on_attach, capabilities)
    require("lspconfig").sumneko_lua.setup({
        settings = {
            Lua = {
                completion = { callSnippet = "Disable" },
                diagnostics = {
                    globals = {
                        "vim",
                        "describe",
                        "pending",
                        "it",
                        "before_each",
                        "after_each",
                        "setup",
                        "teardown",
                    },
                },
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ";")
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                    maxPreload = 2000,
                },
            },
        },
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

return M
