vim.cmd [[packadd nvim-lspconfig]]
vim.cmd [[packadd nvim-compe]]

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = true
    }
)
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", numhl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "", numhl = "LspDiagnosticsDefaultHint"})

local cmd = vim.cmd
cmd "hi LspDiagnosticsSignError guifg=#f9929b"
cmd "hi LspDiagnosticsVirtualTextError guifg=#BF616A"

cmd "hi LspDiagnosticsSignWarning guifg=#EBCB8B"
cmd "hi LspDiagnosticsVirtualTextWarning guifg=#EBCB8B"

cmd "hi LspDiagnosticsSignInformation guifg=#A3BE8C"
cmd "hi LspDiagnosticsVirtualTextInformation guifg=#A3BE8C"

cmd "hi LspDiagnosticsSignHint guifg=#b6bdca"
cmd "hi LspDiagnosticsVirtualTextHint guifg=#b6bdca"

function _G.on_attach (options)
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
    map("n", "ga", "<cmd>lua require'telescope.builtin'.lsp_code_actions()<Cr>", opts, "lsp", "Show code actions on line")
    map("n", "gD", "<Cmd>lua require'telescope.builtin'.lsp_definitions()<CR>", opts, "lsp", "Show definitions on project")
    map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts, "lsp", "Show definitions on current file")
    map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts, "lsp", "Show details for element where hold cursor")
    map("n", "gi", "<cmd>lua require'telescope.builtin'.lsp_implementations()<CR>", opts, "lsp", "Show implementations")
    map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, "lsp", "")
    map("n", "aw", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts, "lsp", "Add folder into workspace")
    map("n", "rw", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts, "lsp", "Remove folder from workspace")
    map("n", "lw", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts, "lsp", "List folders on workspace")
    map("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, "lsp", "Rename definition")
    map("n", "gr", "<cmd>lua require'telescope.builtin'.lsp_references()<CR>", opts, "lsp", "Show all references of definition")
    map("n", "e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts, "lsp", "Show diagnostic on current line")
    map("n", "ld", [[<Cmd>lua require('telescope.builtin').lsp_document_diagnostics()<CR>]], opt, "telescope", "Show diagnostic on current file")
    map("n", "<Leader>ws", [[<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], opt, "telescope", "Show all symbols on workspace")
    -- map("n", "q", "<cmd>lua require'telescope.builtin'.loclist()<CR>", opts, "lsp", "")
end
require 'lsp.servers'
