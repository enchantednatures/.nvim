return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			{
				"folke/neodev.nvim",
				opts = {
					library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
				},
			},
			{ "j-hui/fidget.nvim", tag = "legacy", config = true },
			{ "smjonas/inc-rename.nvim", config = true },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"simrat39/rust-tools.nvim",
			"rust-lang/rust.vim",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
		},
		opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = { callSnippet = "Replace" },
							telemetry = { enable = false },
							hint = {
								enable = false,
							},
						},
					},
				},
				dockerls = {},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							assist = {
								importMergeBehavior = "full",
							},
							cargo = { allFeatures = true },
							checkOnSave = {
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
						},
					},
				},
			},
			setup = {
				rust_analyzer = function(_, opts)
					local rt = require("rust-tools")
					local lsp_utils = require("plugins.lsp.utils")
					lsp_utils.on_attach(function(client, buffer)
                        -- stylua: ignore
                        if client.name == "rust_analyzer" then
                            vim.keymap.set("n", "<leader>cR", rt.runnables.runnables(),
                                { buffer = buffer, desc = "Runnables" })
                            vim.keymap.set("n", "<leader>cl", function() vim.lsp.codelens.run() end,
                                { buffer = buffer, desc = "Code Lens" })
                        end
					end)

					local ih = require("inlay-hints")

					local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.9.1/"
					local codelldb_path = extension_path .. "adapter/codelldb"
					local liblldb_path = extension_path .. "lldb/lib/liblldb"
					local this_os = vim.loop.os_uname().sysname

					if this_os:find("Windows") then
						codelldb_path = package_path .. "adapter\\codelldb.exe"
						liblldb_path = package_path .. "lldb\\bin\\liblldb.dll"
					else
						-- The liblldb extension is .so for linux and .dylib for macOS
						liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
					end
					rt.setup({
						tools = {
							hover_actions = { border = "solid" },
							on_initialized = function()
								ih.set_all()
								vim.api.nvim_create_autocmd(
									{ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" },
									{
										pattern = { "*.rs" },
										callback = function()
											vim.lsp.codelens.refresh()
										end,
									}
								)
							end,
						},
						server = opts,
						dap = {
							adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
						},
					})
					return true
				end,
				lua_ls = function(_, _)
					local lsp_utils = require("plugins.lsp.utils")
					lsp_utils.on_attach(function(client, buffer)
                        -- stylua: ignore
                        if client.name == "lua_ls" then
                            vim.keymap.set("n", "<leader>dX", function() require("osv").run_this() end,
                                { buffer = buffer, desc = "OSV Run" })
                            vim.keymap.set("n", "<leader>dL", function() require("osv").launch({ port = 8086 }) end,
                                { buffer = buffer, desc = "OSV Launch" })
                        end
						if client.name == "omnisharp" then
							client.server_capabilities.semanticTokensProvider = {
								full = vim.empty_dict(),
								legend = {
									tokenModifiers = { "static_symbol" },
									tokenTypes = {},
								},
								range = true,
							}
						end
					end)
				end,
			},
		},
		config = function(plugin, opts)
			require("plugins.lsp.servers").setup(plugin, opts)
		end,
	},
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				"stylua",
				"rust-analyzer",
				"sqlls",
				"sqlfmt",
				"lua-language-server",
				"debugpy",
				"codelldb",
			},
		},
		config = function(_, opts)
			require("mason").setup()
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},
	{
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
	},
	{
		"utilyre/barbecue.nvim",
		event = "VeryLazy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		config = true,
	},
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
			{ "<leader>cD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
		},
	},
	{
		"glepnir/lspsaga.nvim",
		event = "VeryLazy",
		config = true,
	},
}
