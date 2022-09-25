local cwd = vim.loop.cwd()

M = {}

M.checkVimspector = function()
    local name = cwd .. "/.vimspector.json"
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

M.checkVimspectorSession = function()
    local name = cwd .. "/.vimspector.session"
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

M.loadSession = function()
    if not M.checkVimspector() then
       return
    end
    if M.checkVimspectorSession() then
        vim.api.nvim_command("silent VimspectorLoadSession " .. cwd .. "/.vimspector.session")
    end
end

M.saveSession = function()
    if not M.checkVimspector() then
       return
    end
    vim.api.nvim_command("silent VimspectorMKSession")
end

return M
