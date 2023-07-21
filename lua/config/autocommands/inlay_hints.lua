local augroups = require("user.augroups")

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroups.inlayHints,
	callback = function(args)
		if not (args.data and args.data.client_id) then
			return
		end
		local ok, lsp_inlay_hints = pcall(require, "lsp-inlayhints")

		if not ok then
			return
		end

		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if
			custom_nvim.enable_inlayHints
			and (client.server_capabilities.inlayHintsProvider or client.server_capabilities.inlayHintProvider)
		then
			lsp_inlay_hints.on_attach(client, bufnr, false)
		end
	end,
})
