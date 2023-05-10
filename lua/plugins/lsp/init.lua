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
			{ "j-hui/fidget.nvim", config = true },
			{ "smjonas/inc-rename.nvim", config = true },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
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
			},
			setup = {
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
									tokenTypes = {
										"comment",
										"excluded_code",
										"identifier",
										"keyword",
										"keyword_control",
										"number",
										"operator",
										"operator_overloaded",
										"preprocessor_keyword",
										"string",
										"whitespace",
										"text",
										"static_symbol",
										"preprocessor_text",
										"punctuation",
										"string_verbatim",
										"string_escape_character",
										"class_name",
										"delegate_name",
										"enum_name",
										"interface_name",
										"module_name",
										"struct_name",
										"type_parameter_name",
										"field_name",
										"enum_member_name",
										"constant_name",
										"local_name",
										"parameter_name",
										"method_name",
										"extension_method_name",
										"property_name",
										"event_name",
										"namespace_name",
										"label_name",
										"xml_doc_comment_attribute_name",
										"xml_doc_comment_attribute_quotes",
										"xml_doc_comment_attribute_value",
										"xml_doc_comment_cdata_section",
										"xml_doc_comment_comment",
										"xml_doc_comment_delimiter",
										"xml_doc_comment_entity_reference",
										"xml_doc_comment_name",
										"xml_doc_comment_processing_instruction",
										"xml_doc_comment_text",
										"xml_literal_attribute_name",
										"xml_literal_attribute_quotes",
										"xml_literal_attribute_value",
										"xml_literal_cdata_section",
										"xml_literal_comment",
										"xml_literal_delimiter",
										"xml_literal_embedded_expression",
										"xml_literal_entity_reference",
										"xml_literal_name",
										"xml_literal_processing_instruction",
										"xml_literal_text",
										"regex_comment",
										"regex_character_class",
										"regex_anchor",
										"regex_quantifier",
										"regex_grouping",
										"regex_alternation",
										"regex_text",
										"regex_self_escaped_character",
										"regex_other_escape",
									},
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
