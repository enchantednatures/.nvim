return {
	{
		"jakewvincent/mkdnflow.nvim",
		ft = { "markdown" },
		rocks = "luautf8",
		opts = {},
	},
	{ "AckslD/nvim-FeMaco.lua", ft = { "markdown" }, opts = {} },
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},
	{ "mzlogin/vim-markdown-toc", ft = { "markdown" } },
}
