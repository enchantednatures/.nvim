local M = {}
local augroups = require("config.autocommands.augroups")

M.lsp_highlight_document = function(bufnr, client)
	-- Set autocommands conditional on server_capabilities
	local status_ok, highlight_supported = pcall(function()
		return client.supports_method("textDocument/documentHighlight")
	end)
	if not status_ok or not highlight_supported then
		return
	end
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = augroups.lspDocumentHighlight,
		buffer = bufnr,
		callback = vim.lsp.buf.document_highlight,
	})
	vim.api.nvim_create_autocmd("CursorMoved", {
		group = augroups.lspDocumentHighlight,
		buffer = bufnr,
		callback = vim.lsp.buf.clear_references,
	})
end

M.code_lens = function()
	vim.api.nvim_set_hl(0, "LspCodelens", { fg = "darkgray", bold = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
		group = augroups.codelens,
		pattern = "*",
		desc = "Refresh codelens",
		callback = function()
			pcall(vim.lsp.codelens.refresh)
		end,
	})
end

M.attach_navic = function(client, bufnr)
	vim.g.navic_silence = true
	local status_ok, navic = pcall(require, "nvim-navic")
	if not status_ok then
		return
	end
	navic.attach(client, bufnr)
end

return M
