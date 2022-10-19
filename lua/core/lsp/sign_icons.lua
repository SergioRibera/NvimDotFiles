local cfg = require 'nvim-conf'
local CONFIG_NS = 'lsp.signs.'


local opts = {
    signs = {
        Error = cfg.get_value(CONFIG_NS..'err', ' '),
        Warn = cfg.get_value(CONFIG_NS..'warn', ' '),
        Hint = cfg.get_value(CONFIG_NS..'hint', ' '),
        Info = cfg.get_value(CONFIG_NS..'info', ' ')
    },
    colors = {
        error = '#'..cfg.get_value(CONFIG_NS..'color.err', "f9929b"),
        warning = '#'..cfg.get_value(CONFIG_NS..'color.warn', "EBCB8B"),
        info = '#'..cfg.get_value(CONFIG_NS..'color.info', "A3BE8C"),
        hint = '#'..cfg.get_value(CONFIG_NS..'color.hint', "b6bdca"),
    },
}

M = {}
M.setup = function()
    for type, icon in pairs(opts.signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
    vim.cmd("hi DiagnosticSignError guifg=" .. opts.colors.error)
    vim.cmd("hi DiagnosticVirtualTextError guifg=" .. opts.colors.error)

    vim.cmd("hi DiagnosticSignWarning guifg=" .. opts.colors.warning)
    vim.cmd("hi DiagnosticVirtualTextWarning guifg=" .. opts.colors.warning)

    vim.cmd("hi DiagnosticSignInformation guifg=" .. opts.colors.info)
    vim.cmd("hi DiagnosticVirtualTextInformation guifg=" .. opts.colors.info)

    vim.cmd("hi DiagnosticSignHint guifg=" .. opts.colors.hint)
    vim.cmd("hi DiagnosticVirtualTextHint guifg=" .. opts.colors.hint)
end

return M
