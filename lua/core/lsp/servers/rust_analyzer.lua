local M = {}

local mason_registry = require("mason-registry")

local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

M.setup = function(on_attach, capabilities)
    local opts = {
        assist = {
            importEnforceGranularity = true,
            importPrefix = "create"
        },
        cache = {
            warmup = false,
        },
        cachePriming = {
            enable = false,
        },
        cargo = {
            allFeatures = true,
            buildScripts = {
                enable = true,
            },
        },
        completion = {
            autoimport = {
                enable = true,
            },
        },
        diagnostics = {
            experimental = {
                enable = true,
            },
        },
        imports = {
            granularity = {
                group = "module",
            },
            prefix = "self",
        },
        procMacros = {
            enable = true,
        },
    }

    -- local default = require('lspconfig.server_configurations.rust_analyzer')
    -- local rustanalyzer = vim.tbl_deep_extend('force', )

    require("rust-tools").setup({
        dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
        },
        tools = {
            -- autoSetHints = true,
            -- executor = require("rust-tools.executors").toggleterm,
            hover_with_actions = false,
            inlay_hints = {
                auto = false,
                parameter_hints_prefix = ": ",
                other_hints_prefix = ": ",
                -- NOT SURE THIS IS VALID/WORKS 😬
                lifetimeElisionHints = {
                    enable = true,
                    useParameterNames = true
                }
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
            settings = {
                ["rust-analyzer"] = opts
            },
        }
    })
end

return M
