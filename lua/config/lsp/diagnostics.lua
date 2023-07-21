local icons = require("user.icons")
custom_nvim.signs = {
	{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
	{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
	{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
	{ name = "DiagnosticSignInfo", text = icons.diagnostics.BigInformation },
}

for _, sign in ipairs(custom_nvim.signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
end

vim.diagnostic.config({
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		format = function(d)
			local code = d.code or (d.user_data and d.user_data.lsp.code)
			if code then
				return string.format("%s [%s]", d.message, code):gsub("1. ", "")
			end
			return d.message
		end,
	},
	severity_sort = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	virtual_text = {
		prefix = "",
	},
	title = false,
})
