local augroups = require("user.augroups")

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroups.lspFeatures,
	callback = function(args)
		if not (args.data and args.data.client_id) then
			return
		end

		local lsp_common = require("user.lsp.common")
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf

		if client.server_capabilities.documentSymbolProvider then
			lsp_common.attach_navic(client, bufnr)
		end
		-- Code lens
		if client.server_capabilities.codeLensProvider then
			lsp_common.code_lens()
		end
		-- Formatting
		if client.server_capabilities.documentFormattingProvider and custom_nvim.format_on_save.enable then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroups.autoformat,
				pattern = "*",
				callback = function()
					vim.lsp.buf.format({ timeout_ms = 2000 })
				end,
			})
		end

		require("user.lsp.lsp_keymappings").set_lsp_keymaps(bufnr)
		lsp_common.lsp_highlight_document(bufnr, client)
	end,
})
