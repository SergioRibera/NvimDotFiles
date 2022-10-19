local M = {}
local fn = vim.fn

local function set_hl(id, opts)
    vim.api.nvim_set_hl(0, id, opts)
end

M.options = {
    show_index = false,
    show_modify = true,
    show_icon = true,
    show_close = true,
    separator = '',
    spacing = '',
    close_icon = '×',
    close_command = "deletebuf !",
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
        empty = "#282c34"
    }
}



---Handle a user "command" which can be a string or a function
---@param command string|function
---@param buf_id string
local function handle_user_command(command, buf_id)
    if not command then
        return
    end
    if type(command) == "function" then
        command(buf_id)
    elseif type(command) == "string" then
        vim.cmd(fmt(command, buf_id))
    end
end

function M.handle_close_tab(buf_id)
    local options = M.options
    local close = options.close_command
    handle_user_command(close, buf_id)
end

---Add click action to a component
function M.make_clickable(id, func_name, component)
    return "%" .. id .. "@tabline_lua#" .. func_name .. "@" .. component
end

function M.get_icon(name, extension, selected, opts)
    local ok, devicons = pcall(require, 'nvim-web-devicons')
    if ok then
        local icon, icon_hgroup = devicons.get_icon(name, extension)
        if icon then
            local _guibg = opts.colors.disabled.bg
            local _guifg = require('ui.tabline.colors').get_hex({ name = icon_hgroup, attribute = "fg" })
            if selected then
                icon_hgroup = "TabLineSelect" .. icon_hgroup
                _guibg = opts.colors.selected.bg
            else
                icon_hgroup = "TabLine" .. icon_hgroup
            end
            set_hl(icon_hgroup, {
                bg = _guibg, fg = _guifg
            }) -- End
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
        local separatorgroup = "%#TabLineSep#"

        s = s .. '%' .. index .. 'T'
        if index == fn.tabpagenr() then -- Current is selected
            gengroup = '%#TabLineSel#'
            if index == fn.tabpagenr('$') then
                separatorgroup = "%#TabLineSepEndSel#"
            else
                separatorgroup = "%#TabLineSepSel#"
            end
            -- TODO: made color border on multiple case
        elseif (index + 1) == fn.tabpagenr() then -- Next is selected
            separatorgroup = "%#TabLineSepNextSel#"
        elseif index == fn.tabpagenr('$') then
            separatorgroup = "%#TabLineSepEnd#"
        else -- Not Selected
            separatorgroup = "%#TabLineSep#"
        end

        s = s .. gengroup
        -- tab index
        if options.show_index then
            s = s .. index
        end
        s = s .. ' '
        if options.show_icon then
            s = s ..
                M.get_icon(fn.fnamemodify(bufname, ':e'), fn.fnamemodify(bufname, ':e'), index == fn.tabpagenr(), options)
                .. gengroup .. ' '
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
            s = s ..
                M.make_clickable(index, "handle_close_tab", gengroup .. M.options.close_icon .. M.options.spacing .. "%X")
        end
        s = s .. options.spacing



        s = s .. separatorgroup .. options.separator .. gengroup .. options.spacing
    end

    s = s .. '%#TabLineFill#'
    return s
end

function M.setup(user_options)
    M.options = vim.tbl_extend('force', M.options, user_options)

    function _G.s4rch_tabline()
        set_hl("TabLine", {
            bg = M.options.colors.disabled.bg,
            fg = M.options.colors.disabled.fg
        }) -- No Selected
        set_hl("TabLineSel", {
            bg = M.options.colors.selected.bg,
            fg = M.options.colors.selected.fg
        }) -- Selected
        -- Separator
        set_hl("TabLineSep", {
            bg = M.options.colors.disabled.bg,
            fg = M.options.colors.disabled.bg
        }) -- No Selected
        set_hl("TabLineSepSel", {
            bg = M.options.colors.disabled.bg,
            fg = M.options.colors.selected.bg
        }) -- Selected
        set_hl("TabLineSepNextSel", {
            bg = M.options.colors.selected.bg,
            fg = M.options.colors.disabled.bg
        }) -- Next is Selected
        set_hl("TabLineSepEnd", {
            bg = M.options.colors.empty,
            fg = M.options.colors.disabled.bg
        }) -- End
        set_hl("TabLineSepEndSel", {
            bg = M.options.colors.empty,
            fg = M.options.colors.selected.bg
        }) -- End Selected
        set_hl("TabLineFill", { bg = M.options.colors.empty }) -- Fill Empty
        return tabline(M.options)
    end

    vim.o.showtabline = 2
    vim.o.tabline = "%!v:lua.s4rch_tabline()"

    vim.g.loaded_s4rch_tabline = 1
end

return M
