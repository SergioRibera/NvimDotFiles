vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'lukas-reineke/indent-blankline.nvim'

    -- color related stuff
    use 'norcalli/nvim-base16.lua'
    use 'norcalli/nvim-colorizer.lua'

    -- Completion stuff
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'nvim-lua/lsp_extensions.nvim'

    -- Snipets.
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'

    -- lsp stuff
    use 'folke/trouble.nvim'                -- show diagnostics
    use 'williamboman/mason.nvim'           -- pkg manager
    use 'williamboman/mason-lspconfig.nvim' -- pkg lsp config manager
    use 'neovim/nvim-lspconfig'             --  lsp configs
    use 'onsails/lspkind-nvim'              -- icons for lsp
    use 'terrortylor/nvim-comment'          -- manage comment code with kaymaps
    use 'dag/vim-fish'                      -- fish shell lsp
    use 'jayp0521/mason-nvim-dap.nvim'      -- Mason easy install dap adapters and debugers
    use {
        'j-hui/fidget.nvim',                -- show loading rust lsp progress
        tag = 'legacy',
    }
    use {
        "rcarriga/nvim-dap-ui",                -- pretty ui for dap
        requires = {
            "mfussenegger/nvim-dap",           -- debug code
            "theHamsta/nvim-dap-virtual-text", -- virtual text (ex, variable data) while debbuging
        },
        config = function()
            -- call my configuration
            require('core.lsp.debbuging').setup()
        end
    }
    use {
        'nvim-treesitter/nvim-treesitter', -- correct code highlight
        run = ':TSUpdate',
        requires = {
            'HiPhish/nvim-ts-rainbow2' -- rainbow plugin for treesitter
        },
    }
    -- use {
    --     'lvimuser/lsp-inlayhints.nvim',
    --     branch = 'anticonceal',
    --     event = { 'LspAttach' },
    --     config = function()
    --         require("lsp-inlayhints").setup()
    --     end
    -- }
    use {
        "folke/twilight.nvim", -- Focus into code section
        config = function()
            require("twilight").setup()
        end
    }

    -- Language-related
    use 'simrat39/rust-tools.nvim'

    -- Languajes Independents
    use 'nvim-lua/plenary.nvim'
    use 'rcarriga/nvim-notify'

    use 'lewis6991/gitsigns.nvim'
    use 'SmiteshP/nvim-navic'
    use 'hoob3rt/lualine.nvim'
    use 'windwp/nvim-autopairs'
    use 'kylechui/nvim-surround'
    use 'mg979/vim-visual-multi' -- Implement multicursor

    -- file managing , picker etc
    use 'kyazdani42/nvim-tree.lua'
    use 'kyazdani42/nvim-web-devicons'
    use 'sudormrfbin/cheatsheet.nvim' -- cheatsheet for nvim
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-media-files.nvim'
    use 'nvim-lua/popup.nvim'

    -- misc
    use 'andweeb/presence.nvim' -- display nvim on discord
    use 'jbyuki/instant.nvim'   -- Collaborative Nvim
    use 'monaqa/dial.nvim'      -- Increment/Decrement number and more
    use 'nvim-telescope/telescope-ui-select.nvim'

    -- My Plugins Customs
    use 'SergioRibera/nvim-conf'
end)
