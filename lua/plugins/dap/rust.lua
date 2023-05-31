local M = {}
-- rust_analyzer = function(_, opts)
--                     local rt = require("rust-tools")
--                     local lsp_utils = require("plugins.lsp.utils")
--                     lsp_utils.on_attach(function(client, buffer)
--                         -- stylua: ignore
--                         if client.name == "rust_analyzer" then
--                             vim.keymap.set("n", "<leader>cR", rt.runnables.runnables(),
--                                 { buffer = buffer, desc = "Runnables" })
--                             vim.keymap.set("n", "<leader>cl", function() vim.lsp.codelens.run() end,
--                                 { buffer = buffer, desc = "Code Lens" })
--                         end
--                     end)

--                     rt.setup({
--                         tools = {
--                             hover_actions = { border = "solid" },
--                             on_initialized = function()
--                                 local ih = require("inlay-hints")
--                                 ih.set_all()
--                                 vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" },
--                                     {
--                                         pattern = { "*.rs" },
--                                         callback = function()
--                                             vim.lsp.codelens.refresh()
--                                         end,
--                                     })
--                             end,
--                         },
--                         server = opts,
--                         dap = {
--                             adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
--                         },
--                     })
--                     return true
--                 end,

M.config = function()
	local status_ok, rust_tools = pcall(require, "rust-tools")
	if not status_ok then
		return
	end
	local lsp_utils_status_ok, lsp_utils = pcall(require, "plugins.lsp.utils")
	if not lsp_utils_status_ok then
		return
	end

	local lsp_status_ok, lsp = pcall(require, "plugins.lsp")
	if not lsp_status_ok then
		return
	end

	local opts = {
		tools = {
			executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
			reload_workspace_from_cargo_toml = true,
			inlay_hints = {
				only_current_line = false,
				show_parameter_hints = true,
				parameter_hints_prefix = "<-",
				other_hints_prefix = "=>",
				max_len_align = false,
				max_len_align_padding = 1,
				right_align = false,
				right_align_padding = 7,
				highlight = "Comment",
			},
			hover_actions = {
				border = {
					{ "╭", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╮", "FloatBorder" },
					{ "│", "FloatBorder" },
					{ "╯", "FloatBorder" },
					{ "─", "FloatBorder" },
					{ "╰", "FloatBorder" },
					{ "│", "FloatBorder" },
				},
				auto_focus = true,
			},
		},
		server = {
			on_attach = function(client, bufnr)
				lsp_utils.common_on_attach(client, bufnr)
			end,
			on_init = lsp.common_on_init,
			-- capabilities = lsp.common_capabilities(),
			settings = {
				["rust-analyzer"] = {
					inlayHints = { locationLinks = false },
					lens = {
						enable = true,
					},
					checkOnSave = {
						enable = true,
						command = "clippy",
					},
				},
			},
		},
	}
	local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/")
	local vscode_path = vim.fn.expand("~/") .. ".vscode/extensions/codelldb/"

	local path = ""
	local debugger_found = true
	if M.dir_exists(mason_path) then
		path = mason_path
	elseif M.dir_exists(vscode_path) then
		path = vscode_path
	else
		debugger_found = false
		vim.notify("please install codelldb using :Mason or via vscode", vim.log.levels.WARN)
	end

	if debugger_found then
		local codelldb_path = path .. "adapter/codelldb"
		local liblldb_path = path .. "lldb/lib/liblldb.so"

		if vim.fn.has("mac") == 1 then
			liblldb_path = path .. "lldb/lib/liblldb.dylib"
		end

		if vim.fn.filereadable(codelldb_path) and vim.fn.filereadable(liblldb_path) then
			opts.dap = {
				adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
			}
		else
			vim.notify("please reinstall codellb, i cannot find liblldb or codelldb itself", vim.log.levels.WARN)
		end
	end
	rust_tools.setup(opts)
end

M.dir_exists = function(file)
	local ok, _, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok
end

return M
