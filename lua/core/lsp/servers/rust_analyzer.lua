local M = {}

local mason_registry = require("mason-registry")

local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

M.setup = function(on_attach, capabilities)
    require("rust-tools").setup({
        dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
        },
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
                auto = false,
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
            standalone = true,
            on_attach = on_attach,
            capabilities = capabilities,
            checkOnSave = {
                allFeatures = true,
                overrideCommand = {
                    "cargo",
                    "clippy",
                    "--workspace",
                    "--message-format=json",
                    "--all-targets",
                    "--all-features",
                },
            },
            -- settings = {
            --     ["rust-analyzer"] = {
            --         imports = {
            --             granularity = {
            --                 group = "module",
            --             },
            --             prefix = "self",
            --         },
            --         cargo = {
            --             features = "all",
            --             buildScripts = {
            --                 enable = true,
            --             },
            --         },
            --     }
            -- },
        }
    })
end

return M
