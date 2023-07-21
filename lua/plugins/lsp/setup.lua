local M = {}

M.setup = function()
	local lsp_ok, lsp = pcall(require, "lsp-zero")
	if not lsp_ok then
		return
	end

	lsp.preset("lsp-compe")

	lsp.ensure_installed({
		"cssls",
		"eslint",
		"jsonls",
		"lua_ls",
		"tsserver",
	})

	require("user.lsp.server_configurations")

	lsp.setup()
	require("config.lsp.diagnostics")
	require("config.autocommands.inlay_hints")
end

return M
