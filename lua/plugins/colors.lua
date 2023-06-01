return {
	{
		"folke/styler.nvim",
		event = "VeryLazy",
		config = function()
			require("styler").setup({
				themes = {
					help = { colorscheme = "catppuccin" },
				},
			})
		end,
	},
	{ "nyoom-engineering/oxocarbon.nvim", event = "VeryLazy" },
	{ "rose-pine/neovim", event = "VeryLazy" },
	{ "lunarvim/synthwave84.nvim", event = "VeryLazy" },
	{ "lunarvim/horizon.nvim", event = "VeryLazy" },
	{ "lunarvim/templeos.nvim", event = "VeryLazy" },
	{ "sts10/vim-pink-moon", event = "VeryLazy" },
	{
		"folke/tokyonight.nvim",
		event = "VeryLazy",
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},
	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 999,
		config = function()
			local catppuccin = require("catppuccin")
			catppuccin.setup({
				flavour = "macchiato", -- latte, frappe, macchiato, mocha
				background = { -- :h background
					light = "latte",
					dark = "macchiato",
				},
				transparent_background = true,
				show_end_of_buffer = false, -- show the '~' characters after the end of buffers
				term_colors = true,
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},
				no_italic = false, -- Force no italic
				no_bold = false, -- Force no bold
				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				color_overrides = {},
				custom_highlights = {},
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					telescope = true,
					notify = true,
					mini = false,
					which_key = true,
					aerial = true,
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			})
			catppuccin.load()
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		config = function()
			require("gruvbox").setup()
		end,
	},
}
