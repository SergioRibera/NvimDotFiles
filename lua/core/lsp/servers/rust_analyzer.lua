local M = {}

-- local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.6.10/"
-- local codelldb_path = extension_path .. "adapter/codelldb"
-- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

M.setup = function(on_attach, capabilities)
    require("rust-tools").setup({
        -- dap = {
        --     adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        -- },
        tools = {
            -- autoSetHints = true,
            -- executor = require("rust-tools.executors").toggleterm,
            hover_with_actions = false,
            completion = {
                autoimport = {
                    enable = true
                }
            },
            inlay_hints = {
                auto = true,
                parameter_hints_prefix = ": ",
                other_hints_prefix = ": ",
            },
            on_initialized = function()
                vim.api.nvim_create_autocmd(
                    { "BufEnter", "CursorHold", "InsertLeave" },
                    { pattern = "*.rs", callback = vim.lsp.codelens.refresh }
                )
            end,
        },
        server = {
            standalone = false,
            on_attach = on_attach,
            capabilities = capabilities,
        },
    })
end

return M
