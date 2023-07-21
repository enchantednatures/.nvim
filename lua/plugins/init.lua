return {
	"editorconfig/editorconfig-vim",
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	"nvim-tree/nvim-web-devicons",
	"f-person/git-blame.nvim",
	"tpope/vim-abolish",
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" }, -- Required
			-- Optional
			{
				"williamboman/mason.nvim",
				build = function()
					pcall(vim.cmd, "MasonUpdate")
				end,
			}, -- Optional
			{ "williamboman/mason-lspconfig.nvim" }, -- Optional

			-- Autocompletion
			"onsails/lspkind-nvim", -- Completion icons
			{ "hrsh7th/nvim-cmp" }, -- Required
			{ "hrsh7th/cmp-nvim-lsp" }, -- Required
			{ "hrsh7th/cmp-buffer" }, -- Optional
			{ "hrsh7th/cmp-path" }, -- Optional
			{ "saadparwaiz1/cmp_luasnip" }, -- Optional
			{ "hrsh7th/cmp-nvim-lua" }, -- Optional

			-- Snippets
			{ "L3MON4D3/LuaSnip" }, -- Required
			{ "rafamadriz/friendly-snippets" }, -- Optional
		},
		lazy = true,
	},
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		config = function()
			require("plugins.lsp.cmp")
		end,
	},
	{
		"lvimuser/lsp-inlayhints.nvim",
		config = true,
		lazy = true,
	},

	{
		"ray-x/lsp_signature.nvim",
		config = true,
		event = "InsertEnter",
	},

	-- Null-LS
	{
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("plugins.lsp.null_ls")
		end,
		event = "User FileOpened",
	},
	{
		"simrat39/rust-tools.nvim",
		config = function()
			require("plugins.lsp.server_configurations.rust_analyzer")
		end,
		ft = { "rust", "rs" },
	},
	"jay-babu/mason-null-ls.nvim",
 { "folke/neodev.nvim", ft = { "lua" } },
	"jose-elias-alvarez/null-ls.nvim",
	"williamboman/mason.nvim",
	"mfussenegger/nvim-dap",
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = {
			automatic_installation = true,
			ensure_installed = { "python", "codelldb" },
		},
	},
	{
		"utilyre/barbecue.nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		config = true,
	},
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "nacro90/numb.nvim", event = "BufReadPre", config = true },
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPre",
		config = true,
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			input = { relative = "editor" },
			select = {
				backend = { "telescope", "fzf", "builtin" },
			},
		},
	},
	{ "tpope/vim-surround", event = "BufReadPre" },
	{
		"nvim-tree/nvim-web-devicons",
		dependencies = { "DaikyXendo/nvim-material-icon" },
		config = function()
			require("nvim-web-devicons").setup({
				override = require("nvim-material-icon").get_icons(),
			})
		end,
	},
	-- session management
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
        -- stylua: ignore
        keys = {
            { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            {
                "<leader>qd",
                function() require("persistence").stop() end,
                desc =
                "Don't Save Current Session"
            },
        },
	},
}
