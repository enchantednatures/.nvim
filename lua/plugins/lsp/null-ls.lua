return {
	"jose-elias-alvarez/null-ls.nvim",
	event = "BufReadPre",
	dependencies = { "mason.nvim" },
	config = function()
		local nls = require("null-ls")
		nls.setup({
			sources = {
				nls.builtins.formatting.stylua,
				nls.builtins.formatting.prettierd,
				nls.builtins.diagnostics.ruff.with({ extra_args = { "--max-line-length=180" } }),
			},
		})
	end,
}
