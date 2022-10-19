require("core.mappings")
require("core.autopairs")
require("core.cmp")
require("core.comments")
require("core.lsp.mod")
require("core.file-icons")
require("core.git")
require("core.autocmd")
require("instant")
require("nvim-surround").setup()
require('fidget').setup()

require("lspkind").init({
    mode = 'symbol_text',
    symbol_map = {
        Folder = "",
        Enum = ""
    }
})
