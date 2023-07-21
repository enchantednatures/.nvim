local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
	return
end

local lspkind_ok, lspkind = pcall(require, "lspkind")
if not lspkind_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping.scroll_docs(-1),
		["<C-f>"] = cmp.mapping.scroll_docs(1),
		["<C-Space>"] = cmp.mapping.complete({}),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = cmp.mapping(function(fallback)
			-- if cmp.visible() then
			--   cmp.select_next_item()
			if luasnip.expandable() then
				luasnip.expand({})
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			-- elseif check_backspace() then
			--   fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			-- if cmp.visible() then
			--   cmp.select_prev_item()
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	}),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = lspkind.cmp_format({
			mode = "symbol", -- show only symbol annotations
			maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
			preset = "codicons",
			-- wirth_text = false,

			-- The function below will be called before any actual modifications from lspkind
			-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
			-- TODO: Add tailwind_colorizer
			-- before = function(entry, vim_item)
			-- local ok, tailwind_colorizer = pcall(require, "tailwindcss-colorizer-cmp")
			-- if not ok then
			--   return vim_item
			-- end
			-- return tailwind_colorizer.formatter(entry, vim_item)
			-- end,
		}),
		-- format = function(entry, vim_item)
		--   -- Kind icons
		--   vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
		--   -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
		--   vim_item.menu = ({
		--     nvim_lsp = "(LSP)",
		--     luasnip = "(Snippet)",
		--     buffer = "(Buffer)",
		--     path = "(Path)",
		--   })[entry.source.name]
		--   return vim_item
		-- end,
	},
	sources = {
{ name = "nvim_lsp_signature_help", group_index = 2 },
					{ name = "nvim_lua", group_index = 2 },
					{ name = "nvim_lsp", group_index = 2 },
					{ name = "luasnip", group_index = 2 },
					{ name = "buffer", group_index = 2, keyword_length = 5 },
					{ name = "path", group_index = 2 },
					{ name = "crates", group_index = 2 },
	},
    sorting = {
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
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	view = {
		natives = true,
	},
	experimental = {
		-- ghost_text = { hl_group = "Comment" },
		ghost_text = false,
	},
})
