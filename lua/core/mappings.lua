M = {}
-- [
--
--      Basic Global funcitonality
--
-- ]
local mapping_table_contains = function(t, v)
    for _, value in ipairs(t) do
        if value.mode == v.mode and value.lhs == v.lhs and value.category == v.category then
            return true
        end
    end
    return false
end
M.register_map = function(m, ls, rs, opts, c, d)
    local options = { noremap = true }
    local desc = opts.desc or d or ""

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    if m == "" then
        m = "n"
    end
    if type(rs) == "string" then
        vim.api.nvim_set_keymap(m, ls, rs, options)
    end
    local data = { mode = m, lhs = ls, rhs = rs, options = opts, category = c, description = desc }
    if not mapping_table_contains(_G.my_mapping_table, data) then
        table.insert(_G.my_mapping_table, data)
    end
end

-- Set Globals
_G.my_mapping_table = {}
_G.register_map = M.register_map

local map = M.register_map

--
--  Mappings
--
map("n", "<leader>tn", ":lua cycle_teme()<Cr>", {}, "themes", "Cycle to next theme")
map("n", "<leader>tp", ":lua cycle_inverse_teme()<Cr>", {}, "themes", "Cycle to preview theme")
map("n", "<C-h>", ":tabprevious<Cr>", {}, "tabs", "Go to preview tab")                                         -- Move to prev tab
map("n", "<C-l>", ":tabnext<Cr>", {}, "tabs", "Go to next tab")                                                -- Move to next tab
map("n", "<leader>y", '"+y', {}, "clipboard", "Copy into system clipboard")                                    -- Copy any selected text
map("n", "<leader>p", '"+p', {}, "clipboard", "Paste from system clipboard")                                   -- Paste any text
map("v", "<leader>ps", ":TakeScreenShot<Cr>", {}, "screenshot", "Take screenshot (SergioRibera/nvim-silicon)") -- Take Screenshot (require SergioRibera/vim-screenshot plugin)

--
--  Save or Quit
--
map("n", "<leader>q", ':q!<CR>', {}, "save", "Quit buffer")
map("n", "<leader>w", ':w!<CR>', {}, "save", "Write buffer")
map("n", "<leader>wq", ':x<CR>', {}, "save", "Write and close buffer")

-- [
--
--      Dap - Debugger
--
-- ]
map('n', '<F7>', "<Cmd>lua require'dap'.clear_breakpoints()<CR>", {}, "dap", "Clear Breakpoints")
map('n', '<F8>', "<Cmd>lua require'dap'.continue()<CR>", {}, "dap", "Continue")
map('n', '<F9>', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", {}, "dap", "Toggle Breakpoint")
map('n', '<F12>', "<Cmd>lua require'dap'.run_to_cursor()<CR>", {}, "dap", "Run to cursor")
map('n', '<leader>dr', "<Cmd>lua require'dap'.repl.toggle()<CR>", {}, "dap", "Toggle controller window")
map('n', '<leader>dc', "<Cmd>lua require'dap'.terminate()<CR>", {}, "dap", "End Debugging")
map('n', '<leader>dt', "<Cmd>lua require'dapui'.toggle()<CR>", {}, "dap", "Debug UI Toggle")
map('n', '<leader>dd', "<Cmd>lua require'dap'.clear_breakpoints()<CR>", {}, "dap", "Clear Breakpoints")
map('n', '<leader>dl', "<Cmd>lua require'dap'.continue()<CR>", {}, "dap", "Continue")
map('n', '<leader>db', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", {}, "dap", "Toggle Breakpoint")
-- Requests the debugee to step into a function or method if possible.
-- If it cannot step into a function or method it behaves like `dap.step_over()`.
map('n', '<leader>i', "<Cmd>lua require'dap'.step_into()<CR>", {}, "dap", "Step Into")
-- step_next: Requests the debugee to run again for one step.
map('n', '<leader>n', "<Cmd>lua require'dap'.step_over()<CR>", {}, "dap", "Step Over")
-- finish: Requests the debugee to step out of a function or method if possible.
map('n', '<leader>o', "<Cmd>lua require'dap'.step_out()<CR>", {}, "dap", "Step Out")

-- nvim-dap-ui
-- For a one time expression evaluation, you can call a hover window to show a value
map('n', '<C-k>', "<Cmd>lua require('dapui').eval()<CR>", {}, "dap", "Eval")
map('n', '<space>k', "<cmd>lua require('dapui').float_element()<cr>", {}, "dap", "Float Element")


map("i", "<C-L>", "copilot#Accept()", { silent = true, expr = true, script = true }, "copilot",
    "Accept current copilot suggest")
M.lsp_mapping = function()
    local opts = { silent = true }
    map("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<Cr>", opts, "lsp", "Show code actions on line")
    map("n", "<leader>gD", "<Cmd>lua require'telescope.builtin'.lsp_definitions()<CR>", opts, "lsp",
        "Show definitions on project")
    map("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts, "lsp", "Show definitions on current file")
    map("n", "<leader>K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts, "lsp", "Show details for element where hold cursor")
    map("n", "<leader>gi", "<cmd>lua require'telescope.builtin'.lsp_implementations()<CR>", opts, "lsp",
        "Show implementations")
    map("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts, "lsp", "")
    map("n", "<leader>aw", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts, "lsp", "Add folder into workspace")
    map("n", "<leader>rw", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts, "lsp",
        "Remove folder from workspace")
    map("n", "<leader>lw", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts, "lsp",
        "List folders on workspace")
    map("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts, "lsp", "Rename definition")
    map("n", "<leader>gr", "<cmd>lua require'telescope.builtin'.lsp_references()<CR>", opts, "lsp",
        "Show all references of definition")
    map("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts, "lsp", "Show diagnostic on current line")
    map("n", "<leader>ld", [[<Cmd>lua require('telescope.builtin').lsp_document_diagnostics()<CR>]], opts, "telescope",
        "Show diagnostic on current file")
    map("n", "<leader>ws", [[<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]], opts, "telescope",
        "Show all symbols on workspace")
    map("n", "<C-f>", [[<Cmd>lua vim.lsp.buf.format({ tabSize = vim.o.shiftwidth or 4, aync = true })<CR>]], opts, "lsp",
        "Format the current document with LSP")
    map("n", "<leader>nf", ":lua require('neogen').generate()<CR>", opts, "generate",
        "Intellisense for generate documentation")
    -- map("n", "q", "<cmd>lua require'telescope.builtin'.loclist()<CR>", opts, "lsp", "")
end

-- [
--
--      OPEN TERMINALS
--
-- ]
local os_type = vim.bo.fileformat:upper()
local term = 'bash'
if os_type == 'UNIX' or os_type == 'MAC' then
    -- Detect if exists a command
    local default_terminal = vim.fn.expand("$SHELL")
    if default_terminal == "/bin/zsh" or default_terminal == '/usr/bin/zsh' then
        term = "zsh"
    elseif default_terminal == '/bin/fish' or default_terminal == '/usr/bin/fish' then
        term = "fish"
    else
        term = "bash"
    end
else
    term = "powershell"
end
-- open term bottom
map("n", "<C-b>", "<Cmd> split term://" .. term .. " | resize 10 <CR>", {}, "terminal",
    "Open new " .. term .. " terminal on bottom")

return M
