local lsp_installer = require("nvim-lsp-installer")
local lsp_installer_servers = require'nvim-lsp-installer.servers'
local settings_manager = require 'nvim-conf' local split_func = require 'nvim-conf.utils'.split_str
local notify = require("notify")

--[
--
--      LSP Configuration
--
--]

_G.load_inlay_hints = function ()
    require"lsp_extensions".inlay_hints{ prefix = " » ", highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"}}
end

-- vim.api.nvim_command('autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua _G.load_inlay_hints()')

local function setup_handlers()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = {
                prefix = '●',
            },
            signs = true,
            underline = true,
            update_in_insert = true
        }
    )
end
local function setup_sign_icons()
    local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

    for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    vim.cmd "hi DiagnosticSignError guifg=#f9929b"
    vim.cmd "hi DiagnosticVirtualTextError guifg=#BF616A"

    vim.cmd "hi DiagnosticSignWarning guifg=#EBCB8B"
    vim.cmd "hi DiagnosticVirtualTextWarning guifg=#EBCB8B"

    vim.cmd "hi DiagnosticSignInformation guifg=#A3BE8C"
    vim.cmd "hi DiagnosticVirtualTextInformation guifg=#A3BE8C"

    vim.cmd "hi DiagnosticSignHint guifg=#b6bdca"
    vim.cmd "hi DiagnosticVirtualTextHint guifg=#b6bdca"
end

local on_attach = function (_, bufnr)
    local function map(mode, lhs, rhs, opts, c, d)
        _G.register_map(mode, lhs, rhs, opts, c, d)
        -- vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    local function buf_set_option(name, value)
        vim.api.nvim_buf_set_option(bufnr, name, value)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = {silent = true}
    map("n", "<leader>ga", "<cmd>lua require'telescope.builtin'.lsp_code_actions()<Cr>", opts, "lsp", "Show code actions on line")
    map("n", "<leader>gD", "<Cmd>lua require'telescope.builtin'.lsp_definitions()<CR>", opts, "lsp", "Show definitions on project")
    map("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts, "lsp", "Show definitions on current file")
    map("n", "<leader>K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts, "lsp", "Show details for element where hold cursor")
    map("n", "<leader>gi", "<cmd>lua require'telescope.builtin'.lsp_implementations()<CR>", opts, "lsp", "Show implementations")
    map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, "lsp", "")
    map("n", "<leader>aw", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts, "lsp", "Add folder into workspace")
    map("n", "<leader>rw", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts, "lsp", "Remove folder from workspace")
    map("n", "<leader>lw", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts, "lsp", "List folders on workspace")
    map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, "lsp", "Rename definition")
    map("n", "<leader>gr", "<cmd>lua require'telescope.builtin'.lsp_references()<CR>", opts, "lsp", "Show all references of definition")
    map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts, "lsp", "Show diagnostic on current line")
    map("n", "<leader>ld", [[<Cmd>lua require('telescope.builtin').lsp_document_diagnostics()<CR>]], opts, "telescope", "Show diagnostic on current file")
    map("n", "<leader>ws", [[<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], opts, "telescope", "Show all symbols on workspace")
    map("n", "<C-f>", [[<Cmd>lua vim.lsp.buf.formatting({ tabSize = vim.o.shiftwidth or 4 })<CR>]], opts, "lsp", "Format the current document with LSP")
    -- map("n", "q", "<cmd>lua require'telescope.builtin'.loclist()<CR>", opts, "lsp", "")
end
_G.register_map("i", "<C-L>", "copilot#Accept()", {silent = true, expr = true, script = true}, "copilot", "Accept current copilot suggest")

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
                        globals = {"vim"}
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
                    locationPaths= {}
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
    local ok, each_server= lsp_installer_servers.get_server(servers[s])
    if ok then
        if not each_server:is_installed() then
            each_server:install()
        end
    else
        notify("LSP Server \"" .. servers[s] .. "\" not recognized", "warn", { title="LSP Autoinstall", timeout=2000 })
    end
end
