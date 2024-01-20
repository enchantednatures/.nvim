return {
  {
    "rose-pine/neovim",
    lazy = false,
    config = function(_, _)
      require("rose-pine").setup({
        --- @usage 'auto'|'main'|'moon'|'dawn'
        variant = "moon",

      })
    end,
    priority = 1000,
    name = "rose-pine"
  },
  "nvim-lua/plenary.nvim",
  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  "MunifTanjim/nui.nvim",
  "nvim-tree/nvim-web-devicons",
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = { "NvimTreeToggle" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
      { "<esc>",     "<cmd>NvimTreeClose<cr>",  desc = "Explorer" },
      { "ga", function()
        local api = require("nvim-tree.api")

        local node = api.tree.get_node_under_cursor()
        local gs = node.git_status.file

        -- If the current node is a directory get children status
        if gs == nil then
          gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1])
              or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
        end

        -- If the file is untracked, unstaged or partially staged, we stage it
        if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
          vim.cmd("silent !git add " .. node.absolute_path)

          -- If the file is staged, we unstage
        elseif gs == "M " or gs == "A " then
          vim.cmd("silent !git restore --staged " .. node.absolute_path)
        end

        api.tree.reload()
        -- code
      end, "Toggle Git" }
    },
    opts = {
      disable_netrw = false,
      hijack_netrw = true,
      respect_buf_cwd = true,
      view = {
        number = true,
        relativenumber = true,
        float = {
          enable = true,
          open_win_config = function()
            local HEIGHT_RATIO = 0.8 -- You can change this
            local WIDTH_RATIO = 0.5  -- You can change this too
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * WIDTH_RATIO
            local window_h = screen_h * HEIGHT_RATIO
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2)
                - vim.opt.cmdheight:get()
            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          local WIDTH_RATIO = 0.5 -- You can change this too
          return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
      },
      filters = {
        custom = { ".git" },
      },
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    },
  },
  { "f-person/git-blame.nvim", event = "BufReadPost" },
  { "tpope/vim-abolish",       lazy = true },
  { "tpope/vim-repeat",        event = "VeryLazy" },
  { "tpope/vim-surround",      event = "BufReadPre" },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    opts = {}
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { relative = "editor" },
      select = {
        backend = { "telescope", "fzf", "builtin" },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      background_colour = "#000000",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },
  {
    "andymass/vim-matchup",
    event = { "BufReadPost" },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    dependencies = { "DaikyXendo/nvim-material-icon" },
    config = function()
      require("nvim-web-devicons").setup({
        override = require("nvim-material-icon").get_icons(),
      })
    end,
  },
  { "andweeb/presence.nvim",        lazy = false },
  { "editorconfig/editorconfig-vim" },
  {
    "m4xshen/smartcolumn.nvim",
    lazy = false,
    opts = {
      colorcolumn = "80",
      scope = "line",
      disabled_filetypes = { "help", "text", "markdown", "alpha", "Telescope" },
    },
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    lazy = false,
    config = function()
      require("lsp_lines").setup()
    end,
  },
  {
    "windwp/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
  {
    "abecodes/tabout.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    config = true,
  },

  {
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tabs", -- tabs or buffers
        numbers = "buffer_id",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        separator_style = "slant" or "padded_slant",
        show_tab_indicators = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        enforce_regular_tabs = false,
        custom_filter = function(buf_number, _)
          local tab_num = 0
          for _ in pairs(vim.api.nvim_list_tabpages()) do
            tab_num = tab_num + 1
          end

          if tab_num > 1 then
            if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
              return true
            end
          else
            return true
          end
        end,
        sort_by = function(buffer_a, buffer_b)
          local mod_a = ((vim.loop.fs_stat(buffer_a.path) or {}).mtime or {}).sec or 0
          local mod_b = ((vim.loop.fs_stat(buffer_b.path) or {}).mtime or {}).sec or 0
          return mod_a > mod_b
        end,
      },
    },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    config = function(_, _)
      vim.g.db_ui_show_help = 0
      vim.g.db_ui_win_position = "right"
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 45
      vim.g.db_ui_save_location = "~/.config/nvim/db_ui_history"
      vim.g.db_ui_table_helpers = {
        postgres = {
          primary_key = "id",
          foreign_key = "id",
          join_string = "->",
          delete_cascade = "CASCADE",
          delete_restrict = "RESTRICT",
          delete_set_null = "SET NULL",
          delete_set_default = "SET DEFAULT",
        },
      }
      vim.g.db_ui_save_location = vim.fn.stdpath "config" ..
          require("plenary.path").path.sep .. "db_ui"
    end,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    lazy = false,
    keys = { "gc", "gcc", "gbc" },
    config = function(_, _)
      local opts = {
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        opleader = {
          line = "gc",
          block = "gb",
        },
        mappings = {
          basic = true,
          extra = true,
        },
      }
      require("Comment").setup(opts)
    end,
  },
  {
    "chentoast/marks.nvim",
    event = { "VeryLazy" },
    config = function()
      local marks = require("marks")
      marks.setup({
        default_mappings = true,
        builtin_marks = { ".", "<", ">", "^" },
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 150,
        sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
        excluded_filetypes = {},
        bookmark_0 = {
          sign = "⚑",
          virt_text = "hello world",
          -- explicitly prompt for a virtual line annotation when setting a bookmark from this group.
          -- defaults to false.
          annotate = false,
        },
      })
    end,
    mappings = {},
  },
  -- {
  --   "kevinhwang91/nvim-ufo",
  --   lazy = true,
  --   dependencies = {
  --     "kevinhwang91/promise-async"
  --   },
  --   config = function(_, opts)
  --     vim.o.foldcolumn = "1" -- '0' is not bad
  --     vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
  --     vim.o.foldlevelstart = 99
  --     vim.o.foldenable = true

  --     -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
  --     vim.keymap.set("n", "zR", require("ufo").openAllFolds)
  --     vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

  --     local capabilities = vim.lsp.protocol.make_client_capabilities()
  --     capabilities.textDocument.foldingRange = {
  --       dynamicRegistration = false,
  --       lineFoldingOnly = true
  --     }
  --     local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
  --     for _, ls in ipairs(language_servers) do
  --       require("lspconfig")[ls].setup({
  --         capabilities = capabilities
  --         -- you can add other fields for setting up lsp server in this table
  --       })
  --     end
  --     require("ufo").setup()
  --   end

  -- },
  -- {
  --   "epwalsh/obsidian.nvim",
  --   lazy = false,
  --   event = { "bufreadpre /users/hcasten/library/mobile documents/icloud~md~obsidian/documents/**.md" },
  --   -- if you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
  --   -- event = { "bufreadpre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
  --   dependencies = {
  --     -- required.
  --     "nvim-lua/plenary.nvim",

  --     -- see below for full list of optional dependencies 👇
  --   },
  --   opts = {
  --     dir = "~/library/mobile documents/icloud~md~obsidian/documents/obsidianvault/", -- no need to call 'vim.fn.expand' here
  --     daily_notes = {
  --       -- optional, if you keep daily notes in a separate directory.
  --       folder = "calendar",
  --       -- optional, if you want to change the date format for daily notes.
  --       date_format = "%y-%m-%d"
  --     },
  --     -- see below for full list of options 👇
  --   },
  -- }
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" },
  {
    "AndrewRadev/exercism.vim",
    cmd = "Exercism"
  },
  {
    "topaxi/gh-actions.nvim",
    cmd = "GhActions",
    keys = {
      { "<leader>gha", "<cmd>GhActions<cr>", desc = "Open Github Actions" },
    },
    -- optional, you can also install and use `yq` instead.
    build = "make",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    opts = {},
    config = function(_, opts)
      require("gh-actions").setup(opts)
    end,
  },
  {
    "jinh0/eyeliner.nvim",
    lazy = false,
    config = function()
      require "eyeliner".setup {
        highlight_on_key = true, -- show highlights only after keypress
        dim = false              -- dim all other characters if set to true (recommended!)
      }
    end,
  },
  {
    "folke/neoconf.nvim"
  },
  {
    "jtdowney/vimux-cargo",
    lazy = false,
    dependencies =
    {
      "preservim/vimux",
    }
  },
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    dependencies = { { "ggandor/flit.nvim", opts = { labeled_modes = "nv" } } },
    config = function(_, opts)
      local leap = require "leap"
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
    end,
  }

}
