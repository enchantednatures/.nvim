vim.g.mapleader = " "

require("config.options")
require("config.lazy")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.autocommands")
		require("config.keymaps")
	end,
})
