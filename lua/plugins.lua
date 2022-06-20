vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'lukas-reineke/indent-blankline.nvim'

    -- color related stuff
    use "norcalli/nvim-base16.lua"
    use "norcalli/nvim-colorizer.lua"

    -- Completion stuff
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'github/copilot.vim'
    use 'nvim-lua/lsp_extensions.nvim'

    -- Snipets.
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'

    -- lsp stuff
    use 'puremourning/vimspector'
    use 'williamboman/nvim-lsp-installer'
    use "nvim-treesitter/nvim-treesitter"
    use "onsails/lspkind-nvim"
    use 'neovim/nvim-lspconfig'
    use 'mattn/emmet-vim' -- Impllemt emmet for html/js/css
    use "terrortylor/nvim-comment"
    use 'simrat39/symbols-outline.nvim'

    -- Languajes Independents
    use 'nvim-lua/plenary.nvim'
    use 'rcarriga/nvim-notify'

    use "lewis6991/gitsigns.nvim"
    use 'hoob3rt/lualine.nvim'
    use "windwp/nvim-autopairs"
    use "alvan/vim-closetag"
    use "mg979/vim-visual-multi" -- Implement multicursor

    -- file managing , picker etc
    use "kyazdani42/nvim-tree.lua"
    use "kyazdani42/nvim-web-devicons"
    use "ryanoasis/vim-devicons"
    use 'sudormrfbin/cheatsheet.nvim' -- cheatsheet for nvim
    use 'xiyaowong/telescope-emoji.nvim'
    use "nvim-telescope/telescope.nvim"
    use "nvim-telescope/telescope-media-files.nvim"
    use "nvim-lua/popup.nvim"

    -- misc
    use 'andweeb/presence.nvim' -- display nvim on discord
    use 'ur4ltz/surround.nvim'
    use 'jbyuki/instant.nvim' -- Collaborative Nvim
    use 'monaqa/dial.nvim' -- Increment/Decrement number and more
    use 'nvim-telescope/telescope-ui-select.nvim'

    -- My Plugins Customs
    use 'SergioRibera/nvim-conf'
end)
