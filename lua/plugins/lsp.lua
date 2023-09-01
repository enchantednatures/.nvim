return {
  { "simrat39/rust-tools.nvim" },
  "b0o/schemastore.nvim",
  {
    "simrat39/inlay-hints.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      highlight = "Comment",
      prefix = "     > ",
      aligned = false,
      only_current_line = false,
      enabled = { "ChainingHint", "TypeHint", "ParameterHint" },
      eol = {
        right_align = false,
      },
    },
    config = function(_, opts)
      require("inlay-hints").setup(opts)
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
      -- options
    },
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    lazy = true,
    config = function()
      -- This is where you modify the settings for lsp-zero
      -- Note: autocompletion settings will not take effect


      local lsp_zero = require("lsp-zero").preset({})

      local lspconfig = require("lspconfig")
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
        require("config.lsp_keymaps").on_attach(client, bufnr)
      end)

      -- todo: add keymaps

      -- lsp.lua_ls.setup(lsp.nvim_lua_ls())
      lspconfig.tsserver.setup({
        capabilities = lsp_capabilities,
        on_attach = function(client, bufnr)
          lsp_zero.default_keymaps({ buffer = bufnr })
        end,
      })
      lspconfig.jsonls.setup {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      }
      lspconfig.yamlls.setup {
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = false,
            },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      }

      lspconfig.spectral.setup {
        filetypes = { "spec.yaml", "spec.yml" },
        -- settings = {}
      }

      lsp_zero.skip_server_setup({ "rust_analyzer" })


      lsp_zero.setup()

      local rust_tools = require("rust-tools")

      rust_tools.setup({
        tools = {
          runnables = {
            use_telescope = true,
          },

          inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
          },
          hover_actions = {
            auto_focus = true
          }
        },
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<Leader>ca", rust_tools.code_action_group.code_action_group,
              { desc = "Code actions" }, { buffer = bufnr })
            vim.keymap.set("n", "<leader>ch", rust_tools.hover_actions.hover_actions,
              { desc = "Hover action" }, { buffer = bufnr })
          end,

          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        }
      })
    end,

  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    tag = "v0.3.0",
    opts = {},
    config = function(_, opts)
      require("crates").setup(opts)
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "saecki/crates.nvim",
      "hrsh7th/cmp-buffer",
      "lukas-reineke/cmp-under-comparator",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
    },
    config = function()
      require("lsp-zero.cmp").extend()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local neogen = require("neogen")
      local icons = require("config.icons")

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
          { name = "nvim_lsp_signature_help", group_index = 2 },
          { name = "nvim_lua",                group_index = 2 },
          { name = "nvim_lsp",                group_index = 2 },
          { name = "luasnip",                 group_index = 2 },
          { name = "buffer",                  group_index = 2, keyword_length = 5 },
          { name = "path",                    group_index = 2 },
          -- { name = "crates",                  group_index = 2 },
        }),
        sorting = {
          priority_weight = 2,
          comparators = {
            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
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
            mode = "symbol_text",  -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
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

  -- LSP
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "williamboman/mason-lspconfig.nvim" },
      {
        "SmiteshP/nvim-navbuddy",
        requires = {
          "neovim/nvim-lspconfig",
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
          "numToStr/Comment.nvim",        -- Optional
          "nvim-telescope/telescope.nvim" -- Optional
        },
        opts = { lsp = { auto_attach = true } }
      },
      {
        "williamboman/mason.nvim",
        build  = function()
          pcall(vim.api.nvim_command, "MasonUpdate")
        end,
        opts   = {
          ensure_installed = {
            "stylua",
            "rust-analyzer",
            "sqlls",
            "sqlfmt",
            "lua-language-server",
            "debugpy",
            "codelldb",
          },
          ui = {
            icons = {
              package_installed = "",
              package_pending = "",
              package_uninstalled = "",
            },
          }

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
    },
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
      { "<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics" },
      { "<leader>cD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
    },
  },
}
