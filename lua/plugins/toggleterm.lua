return {
	"akinsho/toggleterm.nvim",
	lazy = false,
	keys = { [[<C-\>]] },
	cmd = { "ToggleTerm", "TermExec" },
	opts = {
		size = 20,
		hide_numbers = true,
		open_mapping = [[<C-\>]],
		shade_filetypes = {},
		shade_terminals = false,
		shading_factor = 0.3,
		start_in_insert = true,
		persist_size = true,
		direction = "float",
		winbar = {
			enabled = false,
			name_formatter = function(term)
				return term.name
			end,
		},
	},
	--	module = { "toggleterm", "toggleterm.terminal" },
	--	config = function(_, opts)
	--		require("config.toggleterm").setup(opts)
	--	end,
}
