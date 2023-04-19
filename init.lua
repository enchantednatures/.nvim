vim.g.mapleader = " "

require("config.options")
require("config.lazy")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.autocmds")
		require("config.keymaps")
	end,
})

-- use {
--     'nvim-telescope/telescope.nvim', tag = '0.1.0',
--     requires = { { 'nvim-lua/plenary.nvim' } }
-- }
-- -- Colors
-- use({ 'EdenEast/nightfox.nvim', as = "nightfox" })
-- use({ 'folke/tokyonight.nvim', as = "tokyonight" })
-- use({ 'nyoom-engineering/oxocarbon.nvim' })
-- use({ "catppuccin/nvim", as = "catppuccin" })
-- use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
-- use {
--     'numToStr/Navigator.nvim',
--     config = function()
--         require('Navigator').setup()
--     end
-- }
-- use('OmniSharp/omnisharp-vim')
-- use('neovim/nvim-lspconfig')
-- use('simrat39/rust-tools.nvim')

-- use({
--     'kosayoda/nvim-lightbulb',
--     requires = 'antoinemadec/FixCursorHold.nvim',
-- })
-- use('kdheepak/lazygit.nvim')
-- use('nvim-treesitter/playground')
-- use('theprimeagen/harpoon')
-- use('mbbill/undotree')
-- use('tpope/vim-fugitive')
-- use('ThePrimeagen/vim-be-good')
-- use('ThePrimeagen/git-worktree.nvim')
-- use({
--     'lewis6991/gitsigns.nvim',
--     config = function()
--         require('gitsigns').setup()
--     end
-- })
-- use { 'ms-jpq/coq_nvim' }
-- use { 'ms-jpq/coq.artifacts', branch = 'artifacts' }
-- use {
--     'VonHeikemen/lsp-zero.nvim',
--     requires = {
--         -- LSP Support
--         { 'neovim/nvim-lspconfig' },
--         { 'williamboman/mason.nvim' },
--         { 'williamboman/mason-lspconfig.nvim' },

--         -- Autocompletion
--         { 'hrsh7th/nvim-cmp' },
--         { 'hrsh7th/cmp-buffer' },
--         { 'hrsh7th/cmp-path' },
--         { 'saadparwaiz1/cmp_luasnip' },
--         { 'hrsh7th/cmp-nvim-lsp' },
--         { 'hrsh7th/cmp-nvim-lua' },

--         -- Snippets
--         { 'L3MON4D3/LuaSnip' },
--         { 'rafamadriz/friendly-snippets' },
--     }
-- }
-- use { "j-hui/fidget.nvim" }
-- use {
--     "SmiteshP/nvim-navic",
--     requires = "neovim/nvim-lspconfig"
-- }
-- -- dadbod
-- use('tpope/vim-dadbod')
-- use('kristijanhusak/vim-dadbod-completion')
-- use('kristijanhusak/vim-dadbod-ui')

-- use {
--     'saecki/crates.nvim',
--     tag = 'v0.3.0',
--     requires = { 'nvim-lua/plenary.nvim' },
--     config = function()
--         require('crates').setup()
--     end,
-- }
-- use('rcarriga/nvim-notify')
-- use({
--     -- Additional text objects via treesitter
--     'nvim-treesitter/nvim-treesitter-textobjects',
--     after = 'nvim-treesitter',
-- })
-- -- Lua
-- use({
--     "folke/trouble.nvim",
--     requires = "nvim-tree/nvim-web-devicons",
--     config = function()
--         require("trouble").setup {
--             -- your configuration comes here
--             -- or leave it empty to use the default settings
--             -- refer to the configuration section below
--         }
--     end
-- })
-- use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
-- use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
-- use {
--     "nvim-neotest/neotest",
--     requires = {
--         "nvim-lua/plenary.nvim",
--         "nvim-treesitter/nvim-treesitter",
--         "antoinemadec/FixCursorHold.nvim"
--     }
-- }
-- use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }
-- use { 'nvim-telescope/telescope-ui-select.nvim' }

-- use('nvim-telescope/telescope-file-browser.nvim')
-- use { 'nvim-orgmode/orgmode', config = function()
--     require('orgmode').setup {}
-- end
-- }
-- use('mfussenegger/nvim-dap')
-- use {
--     "folke/twilight.nvim",
--     config = function()
--         require("twilight").setup {
--             -- your configuration comes here
--             -- or leave it empty to use the default settings
--             -- refer to the configuration section below
--         }
--     end
-- }

-- use {
--     "windwp/nvim-autopairs",
--     config = function() require("nvim-autopairs").setup {} end
-- }
-- use {
--     "folke/which-key.nvim",
--     config = function()
--         vim.o.timeout = true
--         vim.o.timeoutlen = 300
--         require("which-key").setup {
--             -- your configuration comes here
--             -- or leave it empty to use the default settings
--             -- refer to the configuration section below
--         }
--     end
-- }
