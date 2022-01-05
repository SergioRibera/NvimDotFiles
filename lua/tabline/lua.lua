local M = {}
local fn = vim.fn

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

-- vim.cmd [[
-- function! tabline_lua#handle_close_tab(minwid, clicks, btn, modifiers) abort
--  call luaeval("require'tabline.lua'.handle_close_tab(_A)", a:minwid)
-- endfunction
-- ]]


---Add click action to a component
---@param func_name string
---@param id number
---@param component string
---@return string
function M.make_clickable(id, func_name, component)
  -- v:lua does not support function references in vimscript so
  -- the only way to implement this is using autoload vimscript functions
  return "%" .. id .. "@tabline_lua#" .. func_name .. "@" .. component
end

function M.get_icon(name, extension, selected, opts)
    local ok, devicons = pcall(require, 'nvim-web-devicons')
    if ok then
        local icon, icon_hgroup = devicons.get_icon(name, extension)
        if icon then
            local _guibg = opts.colors.disabled.bg
            local _guifg = require('tabline.colors').get_hex({ name=icon_hgroup, attribute="fg" })
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
            s = s .. M.make_clickable(index, "handle_close_tab", gengroup .. M.options.close_icon .. M.options.spacing .. "%X" )
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
        vim.highlight.create("TabLine", {
            guibg = M.options.colors.disabled.bg,
            guifg = M.options.colors.disabled.fg
        }, false) -- No Selected
        vim.highlight.create("TabLineSel", {
            guibg = M.options.colors.selected.bg,
            guifg = M.options.colors.selected.fg
        }, false) -- Selected
        -- Separator
        vim.highlight.create("TabLineSep", {
            guibg = M.options.colors.disabled.bg,
            guifg = M.options.colors.disabled.bg
        }, false) -- No Selected
        vim.highlight.create("TabLineSepSel", {
            guibg = M.options.colors.disabled.bg,
            guifg = M.options.colors.selected.bg
        }, false) -- Selected
        vim.highlight.create("TabLineSepNextSel", {
            guibg = M.options.colors.selected.bg,
            guifg = M.options.colors.disabled.bg
        }, false) -- Next is Selected
        vim.highlight.create("TabLineSepEnd", {
            guibg = M.options.colors.empty,
            guifg = M.options.colors.disabled.bg
        }, false) -- End
        vim.highlight.create("TabLineSepEndSel", {
            guibg = M.options.colors.empty,
            guifg = M.options.colors.selected.bg
        }, false) -- End Selected
        vim.highlight.create("TabLineFill", {guibg=M.options.colors.empty}, false) -- Fill Empty
        return tabline(M.options)
    end

    vim.o.showtabline = 2
    vim.o.tabline = "%!v:lua.s4rch_tabline()"

    vim.g.loaded_s4rch_tabline = 1
end

return M
