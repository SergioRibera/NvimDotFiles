M = {
    publish_diagnostics = {
        virtual_text = {
            prefix = '●',
        },
        signs = true,
        underline = true,
        update_in_insert = true
    }
}

M.setup = function()
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, M.publish_diagnostics
    )
end

return M
