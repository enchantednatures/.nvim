return {
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		cmd = "Copilot",
		build = ":Copilot auth",
		opts = {
			suggestion = {
				enabled = false,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<A-l>",
					accept_word = false,
					accept_line = false,
					next = "<A-]>",
					prev = "<A-[>",
					dismiss = "<C-]>",
				},
				panel = {
					enabled = false,
					auto_refresh = true,
					keymap = {
						jump_prev = "<A-b>",
						jump_next = "<A-f>",
						accept = "<CR>",
						refresh = "gr",
						open = "<A-s>",
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4,
					},
				},
				filetypes = {
					["."] = true,
					rust = true,
					rs = true,
				},
			},
		},
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
		lazy = false,
	},
}
