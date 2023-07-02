M = {}

local lsp = vim.lsp
local navic = require('nvim-navic')
local telescope = require("telescope.builtin")
-- local references = require("core.lsp.usages_ref")
local mappings = require("core.mappings")

local publish_diagnostics = {
    virtual_text = {
        prefix = '●',
    },
    signs = true,
    underline = true,
    update_in_insert = true
}

M.override_handlers = function()
    -- lsp.handlers["textDocument/codeAction"] = telescope.lsp_code_actions
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, publish_diagnostics
    )
    -- lsp.handlers["callHierarchy/incomingCalls"] = telescope.lsp_incoming_calls
    -- lsp.handlers["callHierarchy/outgoingCalls"] = telescope.lsp_outgoing_calls
    -- lsp.handlers["textDocument/definition"] = telescope.lsp_definitions
    -- lsp.handlers["textDocument/documentSymbol"] = telescope.lsp_document_symbols
    -- lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
    --     border = "solid",
    --     max_width = 60,
    --     max_height = 19,
    -- })
    -- lsp.handlers["textDocument/implementation"] = telescope.lsp_implementations
    -- lsp.handlers["textDocument/references"] = telescope.lsp_references
    -- lsp.handlers["textDocument/typeDefinition"] = telescope.lsp_type_definitions
    -- lsp.handlers["workspace/symbol"] = telescope.lsp_workspace_symbols
end

M.capabilities = require("cmp_nvim_lsp").default_capabilities(lsp.protocol.make_client_capabilities())
M.capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

M.on_attach = function(client, bufnr)
    local function buf_set_option(name, value)
        vim.api.nvim_buf_set_option(bufnr, name, value)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    mappings.lsp_mapping()
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end

    -- Code Lens
    if client.supports_method("textDocument/codeLens") and client.name ~= "rust_analyzer" then
        vim.api.nvim_create_autocmd(
            { "BufEnter", "CursorHold", "InsertLeave" },
            { buffer = bufnr, callback = lsp.codelens.refresh }
        )
    end

    -- Semantic Token
    -- if client.supports_method("textDocument/semanticTokens/full") then
    --   vim.api.nvim_create_autocmd(
    --     { "CursorHold", "BufEnter" },
    --     { buffer = bufnr, callback = lsp.buf.semantic_tokens_full }
    --   )
    -- end

    -- Inlay Hints
    -- if client.server_capabilities.inlayHintProvider or client.server_capabilities.clangdInlayHintsProvider or client.supports_method("textDocument/inlayHints") then
    --     -- require("inlay-hints").on_attach(client, bufnr)
    --     -- vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
    --     require("lsp-inlayhints").on_attach(client, bufnr)
    -- end

    -- Register nvim-cmp LSP source
    if client.name ~= "null-ls" then
        require("cmp_nvim_lsp").setup()
    end
end

return M
