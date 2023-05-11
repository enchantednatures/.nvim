return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"lukas-reineke/cmp-under-comparator",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
			"zbirenbaum/copilot-cmp",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local neogen = require("neogen")
			local icons = require("config.icons")

			local gh_issues = require("plugins.completion.gh_issues")
			local has_words_before = function()
				if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
					return false
				end
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
			end
			local lspkind = require("lspkind")
			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping({
						i = cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = false,
						}),
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
					}),
					["<C-y>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif neogen.jumpable() then
							neogen.jump_next()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, {
						"i",
						"s",
						"c",
					}),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						elseif neogen.jumpable(true) then
							neogen.jump_prev()
						else
							fallback()
						end
					end, {
						"i",
						"s",
						"c",
					}),
				}),
				sources = cmp.config.sources({
					{ name = "copilot", group_index = 2 },
					{ name = "gh_issues", group_index = 2 },
					{ name = "nvim_lsp_signature_help", group_index = 2 },
					{ name = "nvim_lua", group_index = 2 },
					{ name = "nvim_lsp", group_index = 2 },
					{ name = "luasnip", group_index = 2 },
					{ name = "buffer", group_index = 2, keyword_length = 5 },
					{ name = "path", group_index = 2 },
				}),
				sorting = {
					priority_weight = 2,
					comparators = {
						require("copilot_cmp.comparators").prioritize,
						-- Below is the default comparitor list and order for nvim-cmp
						cmp.config.compare.offset,
						-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
						cmp.config.compare.exact,
						cmp.config.compare.score,
						require("cmp-under-comparator").under,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					experimental = {
						-- I like the new menu better! Nice work hrsh7th
						native_menu = false,

						-- Let's play with this for a day or two
						ghost_text = false,
					},
					format = lspkind.cmp_format({
						mode = "symbol", -- show only symbol annotations
						maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
						symbol_map = { copilot = "" },
						-- deduplicate the entries before sending to the cmp
						before = function(entry, item)
							local max_width = 0
							local source_names = {
								copilot = "",
								nvim_lsp = "(LSP)",
								nvim_lsp_signature_help = "(Signature)",
								path = "(Path)",
								nvim_lua = "(vim)",
								luasnip = "(Snippet)",
								buffer = "(Buffer)",
								gh_issues = "(Issue)",
							}

							local duplicates = {
								buffer = 1,
								path = 1,
								nvim_lsp = 0,
								luasnip = 1,
							}
							local duplicates_default = 0
							if max_width ~= 0 and #item.abbr > max_width then
								item.abbr = string.sub(item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
							end
							item.kind = icons.kind[item.kind]
							item.menu = source_names[entry.source.name]
							item.dup = duplicates[entry.source.name] or duplicates_default
							return item
						end,
					}),
				},
			})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			-- Auto pairs
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		build = "make install_jsregexp",
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
        -- stylua: ignore
        keys = {
            {
                "<C-j>",
                function()
                    return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<C-j>"
                end,
                expr = true,
                remap = true,
                silent = true,
                mode = "i",
            },
            { "<C-j>", function() require("luasnip").jump(1) end,  mode = "s" },
            { "<C-k>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
        },
	},
}
