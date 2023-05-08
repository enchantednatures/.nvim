return {
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	"nvim-tree/nvim-web-devicons",
	"f-person/git-blame.nvim",
	"tpope/vim-abolish",

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
	{
		"saecki/crates.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		tag = "v0.3.0",
		opts = {},
		config = function(_, opts)
			require("crates").setup(opts)
		end,
	},
	{
		"simrat39/inlay-hints.nvim",
		opts = {
			highlight = "Comment",
			prefix = "     > ",
			aligned = false,
			only_current_line = false,
			enabled = { "ChainingHint", "TypeHint", "ParameterHint" },
			eol = {
				right_align = false,
			},
		},
		config = function(_, opts)
			require("inlay-hints").setup(opts)
		end,
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {
			timeout = 3000,
			background_colour = "#000000",
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		},
		config = function(_, opts)
			require("notify").setup(opts)
			vim.notify = require("notify")
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = false,
	},
	{
		"andymass/vim-matchup",
		event = { "BufReadPost" },
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
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
