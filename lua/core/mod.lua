require("core.mappings")
require("core.autopairs")
require("core.cmp")
require("core.comments")
require("core.lsp")
require("core.file-icons")
require("core.treesitter")
require("core.git")
require("instant")

require("lspkind").init({
    mode = 'symbol_text',
    symbol_map = {
        Folder = "",
        Enum = ""
    }
})
