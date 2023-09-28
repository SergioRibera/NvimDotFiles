---@diagnostic disable: unused-local

vim.filetype.add({
    extension = {
        conf = "conf",
        env = "dotenv",
    },
    filename = {
        [".env"] = "dotenv",
        ["tsconfig.json"] = "jsonc",
        [".yamlfmt"] = "yaml",
    },
    pattern = {
        ["env%.(%a+)"] = function(_path, _bufnr, ext)
            vim.print(ext)
            if vim.tbl_contains({ "local", "example", "dev", "prod" }, ext) then
                return "dotenv"
            end
        end,
    },
})
