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
    use 'j-hui/fidget.nvim'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'neovim/nvim-lspconfig'
    use 'onsails/lspkind-nvim'
    use 'mattn/emmet-vim' -- Impllemt emmet for html/js/css
    use 'terrortylor/nvim-comment'
    use 'simrat39/symbols-outline.nvim'
    use 'dag/vim-fish'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        requires = {
            'HiPhish/nvim-ts-rainbow2'
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
        "folke/twilight.nvim",
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
