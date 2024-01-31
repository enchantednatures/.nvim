return {
  {
    "mrcjkb/rustaceanvim",
    version = "^3", -- Recommended
    ft = { "rust" },
  },
  {
    "nvimtools/none-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          -- nls.builtins.formatting.stylua,
          nls.builtins.formatting.black,
          nls.builtins.formatting.shfmt,
          -- nls.builtins.formatting.pg_format,
          nls.builtins.formatting.sqlfluff.with({
            extra_args = { "--dialect", "postgres" }, -- change to your dialect
          }),
          nls.builtins.diagnostics.sqlfluff.with({
            extra_args = { "--dialect", "postgres" }, -- change to your dialect
          }),
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.htmlbeautifier,
          nls.builtins.code_actions.gomodifytags,
          nls.builtins.code_actions.impl,
          nls.builtins.formatting.yamlfmt,
          nls.builtins.formatting.fixjson,
          nls.builtins.formatting.rustfmt.with({
            extra_args = { "--edition=2021" }
          }),
          nls.builtins.formatting.leptosfmt,
          -- nls.builtins.diagnostics.ruff.with { extra_args = { "--max-line-length=180" } },
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false, -- disable built-in keymapping
        },
      })

      -- hide copilot suggestions when cmp menu is open
      -- to prevent odd behavior/garbled up suggestions
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if cmp_status_ok then
        cmp.event:on("menu_opened", function()
          vim.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on("menu_closed", function()
          vim.b.copilot_suggestion_hidden = false
        end)
      end
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    lazy = false,
    keys = {
      { "<M-CR>", ":Lspsaga code_action code_action <CR>", "code_action" }

    },
    config = function()
      require("lspsaga").setup({
        -- vim.keymap.set({ "n", "t", "<A-d>", "<cmd>Lspsaga term_toggle" })
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons",     -- optional
    }
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    lazy = false,
    dependencies = {
      "b0o/schemastore.nvim",
      {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
          notification = {
            window = {
              winblend = 0,
              relative = "editor"
            }
          },
        },
      },
    },
    config = function()
      -- This is where you modify the settings for lsp-zero
      -- Note: autocompletion settings will not take effect

      local lsp_zero = require("lsp-zero").preset({})

      local lspconfig = require("lspconfig")
      local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
        require("config.lsp_keymaps").on_attach(client, bufnr)

        vim.api.nvim_create_autocmd({ "BufEnter" }, {
          pattern = { "Cargo.toml" },
          callback = function(event)
            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(
                mode,
                lhs,
                rhs,
                { silent = true, desc = desc, buffer = event.buf, noremap = true }
              )
            end
            map("n", "<leader>lc", function() end, "+Crates")
            map(
              "n",
              "<leader>lcy",
              "<cmd>lua require'crates'.open_repository()<cr>",
              "Open Repository"
            )
            map("n", "<leader>lcp", "<cmd>lua require'crates'.show_popup()<cr>", "Show Popup")
            map("n", "<leader>lci", "<cmd>lua require'crates'.show_crate_popup()<cr>", "Show Info")
            map(
              "n",
              "<leader>lcf",
              "<cmd>lua require'crates'.show_features_popup()<cr>",
              "Show Features"
            )
            map(
              "n",
              "<leader>lcd",
              "<cmd>lua require'crates'.show_dependencies_popup()<cr>",
              "Show Dependencies"
            )
          end,
        })
      end)

      -- todo: add keymaps

      -- lsp.lua_ls.setup(lsp.nvim_lua_ls())
      lspconfig.tsserver.setup({
        capabilities = lsp_capabilities,
        on_attach = function(client, bufnr)
          lsp_zero.default_keymaps({ buffer = bufnr })
        end,
      })
      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            schemaStore = {
              -- You must disable built-in schemaStore support if you want to use
              -- this plugin and its advanced options like `ignore`.
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
              -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
              -- url = "",
            },
            -- schemas = require("schemastore").yaml.schemas(),
            schemas = {
              kubernetes = "*.yaml",
              ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
              ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
              ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
              ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
              ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
              ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
              ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
              ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
              ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
              "*api*.{yml,yaml}",
              ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
              "*docker-compose*.{yml,yaml}",
              ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
              "*flow*.{yml,yaml}",
            },
            format = { enabled = false },
            validate = false,
            completion = true,
            hover = true,
          },
        },
      })

      lspconfig.spectral.setup({
        filetypes = { "spec.yaml", "spec.yml" },
        -- settings = {}
      })

      lspconfig.clangd.setup({
        filetypes = { "c", "objc", "objcpp", "cuda" },
      })

      lsp_zero.skip_server_setup({ "rust_analyzer" })


      lsp_zero.setup()
    end,
  },
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    after = "nvim-lspconfig",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      {
        "saecki/crates.nvim",
        lazy = true,
        event = { "BufRead Cargo.toml" },
        dependencies = { "nvim-lua/plenary.nvim" },
        tag = "v0.3.0",
        opts = {},
        config = function(_, opts)
          require("crates").setup(opts)
        end,
      },
      "hrsh7th/cmp-buffer",
      "lukas-reineke/cmp-under-comparator",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "dbout" },
        dependencies = {
          "tpope/vim-dadbod",
        },
      }

    },
    config = function()
      require("lsp-zero.cmp").extend()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local icons = require("config.icons")

      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
            and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$")
            == nil
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
          ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
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
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif cmp.visible() then
              cmp.select_next_item()
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
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            elseif cmp.visible() then
              cmp.select_prev_item()
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
          { name = "crates",                  group_index = 2 },
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
                ["vim-dadbod-completion"] = "(DB)",
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
        sources = cmp.config.sources(
        -- {
        --   { name = "path" },
        -- },
          {
            {
              name = "cmdline",
              option = {
                ignore_cmds = { "Man", "!" },
              },
            },
          }),
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    after = "nvim-cmp",
    dependencies = {
      "rafamadriz/friendly-snippets"
    },
    config = function(_, _)
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
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
          "numToStr/Comment.nvim",         -- Optional
          "nvim-telescope/telescope.nvim", -- Optional
        },
        opts = { lsp = { auto_attach = true } },
      },
      {
        "williamboman/mason.nvim",
        build = function()
          pcall(vim.api.nvim_command, "MasonUpdate")
        end,
        opts = {
          ensure_installed = {
            "sqlls",
            "sqlfmt",
            "lua-language-server",
            "debugpy",
            "typescript-language-server",
            "codelldb",
            "stylua",
            "impl",
          },
          ui = {
            icons = {
              package_installed = "",
              package_pending = "",
              package_uninstalled = "",
            },
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
  }

}
