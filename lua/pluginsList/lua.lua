require 'paq-nvim' {
    -- 'savq/paq-nvim';
    {"lukas-reineke/indent-blankline.nvim", branch = "lua"};

    -- color related stuff
    "norcalli/nvim-base16.lua";
    "norcalli/nvim-colorizer.lua";

    -- lsp stuff
    "nvim-treesitter/nvim-treesitter";
    -- "sheerun/vim-polyglot"
    "hrsh7th/nvim-compe";
    "onsails/lspkind-nvim";
    'hrsh7th/vim-vsnip';
    'hrsh7th/vim-vsnip-integ';
    'neovim/nvim-lspconfig';
    'mattn/emmet-vim'; -- Impllemt emmet for html/js/css
    "terrortylor/nvim-comment";
    -- Languajes Independents
    -- {'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim'}
    'nvim-lua/plenary.nvim';
    'simrat39/rust-tools.nvim';

    "lewis6991/gitsigns.nvim";
    "akinsho/nvim-bufferline.lua";
    'hoob3rt/lualine.nvim';
    "windwp/nvim-autopairs";
    "alvan/vim-closetag";
    "mg979/vim-visual-multi"; -- Implement multicursor

    -- file managing , picker etc
    "kyazdani42/nvim-tree.lua";
    "kyazdani42/nvim-web-devicons";
    "ryanoasis/vim-devicons";
    "nvim-telescope/telescope.nvim";
    "nvim-telescope/telescope-media-files.nvim";
    "nvim-lua/popup.nvim";

    -- misc
    'andweeb/presence.nvim'; -- display nvim on discord
    "blackCauldron7/surround.nvim";
    'jbyuki/instant.nvim'; -- Collaborative Nvim
    'monaqa/dial.nvim'; -- Increment/Decrement number and more
}
