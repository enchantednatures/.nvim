return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        lazy = true,
        config = function()
            -- This is where you modify the settings for lsp-zero
            -- Note: autocompletion settings will not take effect

            require('lsp-zero.settings').preset({})
        end
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            -- The arguments for .extend() have the same shape as `manage_nvim_cmp`:
            -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#manage_nvim_cmp

            require('lsp-zero.cmp').extend()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local cmp_action = require('lsp-zero.cmp').action()


            cmp.setup({
                sources = {
                    { name = 'copilot' },
                    { name = 'nvim_lsp' },
                },
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({
                        -- documentation says this is important.
                        -- I don't know why.
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                }
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = 'LspInfo',
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
            {
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
        },
        config = function()
            -- This is where all the LSP shenanigans will live

            local lsp = require('lsp-zero')

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
                if client.server_capabilities.documentSymbolProvider then
                    require('nvim-navic').attach(client, bufnr)
                end
            end)

            -- (Optional) Configure lua language server for neovim
            require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

            lsp.format_mapping('gq', {
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ['null-ls'] = { 'javascript', 'typescript', 'lua' },
                }
            })

            lsp.format_on_save({
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ['null-ls'] = { 'javascript', 'typescript', 'lua' },
                }
            })


            lsp.setup()
            local null_ls = require('null-ls')

            null_ls.setup({
                sources = {
                    -- Replace these with the tools you have installed
                    null_ls.builtins.formatting.prettier,
                    null_ls.builtins.diagnostics.eslint,
                    null_ls.builtins.formatting.stylua,
                }
            })
            require('mason-null-ls').setup({
                ensure_installed = nil,
                automatic_installation = true,
            })
        end
    }
}
-- return {
--
--     {

-- 	"williamboman/mason.nvim",
--     },
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		event = "BufReadPre",
-- 		dependencies = {
-- 			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
-- 			{
-- 				"folke/neodev.nvim",
-- 				opts = {
-- 					library = { plugins = { "neotest", "nvim-dap-ui" }, types = true },
-- 				},
-- 			},
-- 			{ "j-hui/fidget.nvim", config = true },
-- 			{ "smjonas/inc-rename.nvim", config = true },
-- 			"williamboman/mason.nvim",
-- 			"williamboman/mason-lspconfig.nvim",
-- 			"hrsh7th/cmp-nvim-lsp",

-- 			"hrsh7th/cmp-nvim-lsp-signature-help",
-- 			{
-- 				"SmiteshP/nvim-navbuddy",
-- 				dependencies = {
-- 					"SmiteshP/nvim-navic",
-- 					"MunifTanjim/nui.nvim",
-- 				},
-- 				opts = { lsp = { auto_attach = true } },
-- 			},
-- 		},
-- 		opts = {
-- 			servers = {
-- 				lua_ls = {
-- 					settings = {
-- 						Lua = {
-- 							workspace = {
-- 								checkThirdParty = false,
-- 							},
-- 							completion = { callSnippet = "Replace" },
-- 							telemetry = { enable = false },
-- 							hint = {
-- 								enable = false,
-- 							},
-- 						},
-- 					},
-- 				},
-- 			},
-- 			setup = {
-- 				lua_ls = function(_, _)
-- 					local lsp_utils = require("plugins.lsp.utils")
-- 					lsp_utils.on_attach(function(client, buffer)
--                         -- stylua: ignore
--                         if client.name == "lua_ls" then
--                             vim.keymap.set("n", "<leader>dX", function() require("osv").run_this() end,
--                                 { buffer = buffer, desc = "OSV Run" })
--                             vim.keymap.set("n", "<leader>dL", function() require("osv").launch({ port = 8086 }) end,
--                                 { buffer = buffer, desc = "OSV Launch" })
--                         end
-- 					end)
-- 				end,
-- 			},
-- 		},
-- 		config = function(plugin, opts)
-- 			require("plugins.lsp.servers").setup(plugin, opts)
-- 		end,
-- 	},
-- 	{
-- 		"glepnir/lspsaga.nvim",
-- 		event = "VeryLazy",
-- 		config = true,
-- 	},
-- }
