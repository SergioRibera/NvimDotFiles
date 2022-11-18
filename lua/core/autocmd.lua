local auto_save = require("nvim-conf").get_value("auto_save", "true")

function _G.OnExit()
end

function _G.OnEnter()
end

--[
--
--      Autocommands
--
--]
vim.api.nvim_command("autocmd BufWritePre,BufWinLeave ?* silent! mkview")
vim.api.nvim_command("autocmd BufWinEnter ?* silent! loadview")
vim.api.nvim_command("autocmd CursorHold,CursorHoldI * checktime")
vim.api.nvim_command("autocmd VimEnter * lua _G.OnEnter()")
vim.api.nvim_command("autocmd VimLeavePre * lua _G.OnExit()")

--[
--
-- Autosave
--
--]
if auto_save == "true" then
    vim.api.nvim_command("autocmd TextChanged,TextChangedI * silent! write")
end
