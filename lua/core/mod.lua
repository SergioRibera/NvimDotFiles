require("core.mappings")
require("core.autopairs")
require("core.cmp")
require("core.comments")
require("core.lsp")
require("core.file-icons")
require("core.git")
require("instant")
require("nvim-surround").setup()

require("lspkind").init({
    mode = 'symbol_text',
    symbol_map = {
        Folder = "",
        Enum = ""
    }
})


--[
--
-- Autosave
--
--]
local auto_save = require("nvim-conf").get_value("auto_save", "true")

if auto_save == "true" then
    vim.api.nvim_command("autocmd TextChanged,TextChangedI * silent! write")
end
