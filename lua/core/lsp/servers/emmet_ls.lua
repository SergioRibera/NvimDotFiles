M = {}

M.setup = function(on_attach, capabilities)
    local lspconfig = require('lspconfig')
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    lspconfig.emmet_ls.setup({
        on_attach = function(client, bufnr)
            _G.register_map("i", "<c-s>", function()
                client.request(
                    "textDocument/completion",
                    vim.lsp.util.make_position_params(),
                    function(_, result)
                        local textEdit = result[1].textEdit
                        local snip_string = textEdit.newText
                        textEdit.newText = ""
                        vim.lsp.util.apply_text_edits({ textEdit }, bufnr, client.offset_encoding)
                        require("luasnip").lsp_expand(snip_string)
                    end,
                    bufnr
                )
            end, { buffer = bufnr }, "emmet", "Complete Emmet")
            on_attach(client, bufnr)
        end,
        capabilities = capabilities,
        filetypes = {
            "css", "eruby", "html", "javascript", "javascriptreact",
            "less", "sass", "scss", "svelte", "pug", "typescriptreact",
            "vue", "rust"
        },
        init_options = {
            html = {
                options = {
                    -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                    ["bem.enabled"] = true,
                },
            },
            jsx = {
                options = {
                    ["markup.attributes"] = { className = "class" },
                },
            },
            rust = {
                options = {
                    ["markup.attributes"] = { className = "className" },
                },
            },
        }
    })
end

return M
