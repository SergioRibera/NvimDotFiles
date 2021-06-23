local M = {}
local fn = vim.fn

M.options = {
    show_index = false,
    show_modify = true,
    show_icon = true,
    show_close = true,
    -- separator = '',
    separator = '',
    spacing = '',
    indicators = {
        modify = '+'
    },
    no_name = '[No Name]',
    colors = {
        selected = {
            bg = "#81A1C1",
            fg = "#1e222a"
        },
        disabled = {
            bg = "#D8DEE9",
            fg = "#1e222a"
        },
        --separator = {
        --    bg = "#282c34",
        --    fg = "#81A1C1",
        --},
        empty = "#282c34"
    }
}

function M.get_icon(name, extension, selected, opts)
    local ok, devicons = pcall(require, 'nvim-web-devicons')
    if ok then
        local icon, icon_hgroup = devicons.get_icon(name, extension)
        if icon then
            local _guibg = opts.colors.disabled.bg
            local _guifg = require('bufferline.colors').get_hex({ name=icon_hgroup, attribute="fg" })
            if selected then
                icon_hgroup = "TabLineSelect" .. icon_hgroup
                _guibg = opts.colors.selected.bg
            else
                icon_hgroup = "TabLine" .. icon_hgroup
            end
            vim.highlight.create(icon_hgroup, {
                guibg=_guibg, guifg=_guifg
            }, false) -- End
            return '%#' .. icon_hgroup .. '#' .. icon .. ' '
        end
        return ''
    else
        ok = vim.fn.exists('*WebDevIconsGetFileTypeSymbol')
        if ok ~= 0 then
            return vim.fn.WebDevIconsGetFileTypeSymbol() .. ' '
        end
    end
    return ''
end

local function tabline(options)
    local s = ''
    for index = 1, fn.tabpagenr('$') do
        local winnr = fn.tabpagewinnr(index)
        local buflist = fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]
        local bufname = fn.bufname(bufnr)
        local bufmodified = fn.getbufvar(bufnr, "&mod")
        local gengroup = '%#TabLine#'

        s = s .. '%' .. index .. 'T'
        if index == fn.tabpagenr() then
            gengroup = '%#TabLineSel#'
        end
        s = s .. gengroup
        -- tab index
        if options.show_index then
            s = s .. index
        end
        s = s .. ' '
        if options.show_icon then
            s = s .. M.get_icon(fn.fnamemodify(bufname, ':e'), fn.fnamemodify(bufname, ':e'), index == fn.tabpagenr(), options) .. gengroup .. ' '
        end
        -- buf name
        if bufname ~= '' then
            s = s .. fn.fnamemodify(bufname, ':t') .. ' '
        else
            s = s .. options.no_name .. ' '
        end
        -- modification indicator
        if options.show_modify and bufmodified == 1 then
            s = s .. options.indicators.modify .. ' '
        end
        if options.show_close then
            s = s .. "%999Xx"
        end
        s = s .. options.spacing .. "%#TabLineSep#" .. options.separator .. gengroup .. options.spacing
    end

    s = s .. '%#TabLineFill#'
    return s
end

function M.setup(user_options)
    M.options = vim.tbl_extend('force', M.options, user_options)

    function _G.s4rch_tabline()
        vim.highlight.create("TabLine", {
            guibg=M.options.colors.disabled.bg,
            guifg=M.options.colors.disabled.fg
        }, false) -- No Selected
        vim.highlight.create("TabLineSel", {
            guibg=M.options.colors.selected.bg,
            guifg=M.options.colors.selected.fg
        }, false) -- Selected
        vim.highlight.create("TabLineFill", {guibg=M.options.colors.empty}, false) -- Fill Empty
        return tabline(M.options)
    end

    vim.o.showtabline = 2
    vim.o.tabline = "%!v:lua.s4rch_tabline()"

    vim.g.loaded_s4rch_tabline = 1
end

return M
