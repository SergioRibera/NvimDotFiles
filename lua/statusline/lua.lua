local lualine = require('lualine')

local colors = {
    bg = "#1e222a",
    line_bg = "#1e222a",
    fg = "#D8DEE9",
    fg_green = "#65a380",
    yellow = "#A3BE8C",
    cyan = "#22262C",
    darkblue = "#61afef",
    green = "#BBE67E",
    orange = "#FF8800",
    purple = "#252930",
    magenta = "#c678dd",
    blue = "#22262C",
    red = "#DF8890",
    lightbg = "#282c34",
    nord = "#81A1C1",
    greenYel = "#EBCB8B"

}
local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end
}

lualine.setup {
    options = {
        theme = 'onedark',
        -- section_separators = {'', ''},
        -- component_separators = {'', ''},
        section_separators = {'', ''},
        component_separators = {'', ''},
        disabled_filetypes = { 'NvimTree', 'Term' },
        icons_enabled = true,
    },
    sections = {
        lualine_a = { {'mode', upper = true} },
        lualine_b = {
            {'branch', icon = ''},
            {
                'diff',
                symbols = {added= ' ', modified= '柳 ', removed= ' '},
                color_added = colors.green,
                color_modified = colors.orange,
                color_removed = colors.red,
                condition = conditions.hide_in_width
            }
        },
        lualine_c = {
            {
                'diagnostics',
                sources = {'nvim_lsp'},
                symbols = {error = ' ', warn = ' ', info= ' '},
                color_error = colors.red,
                color_warn = colors.yellow,
                color_info = colors.cyan,
            },
            {
                'filename',
                icons_enabled = true,
                file_status = true,
                symbols = { modified = ' [+]', readonly = ' [-]'}
            }
        },
        lualine_x = { },
        lualine_y = { },
        lualine_z = { 'progress', 'location'  },
    },
    inactive_sections = {
        lualine_a = {  },
        lualine_b = {  },
        lualine_c = { 'filetype' },
        lualine_x = { 'location' },
        lualine_y = {  },
        lualine_z = {  }
    },
    extensions = { }
}
