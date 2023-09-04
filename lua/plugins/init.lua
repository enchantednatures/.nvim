return {
  {
    "rose-pine/neovim",
    lazy = false,
    config = function(_, opts)
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
    },
    opts = {
      disable_netrw = false,
      hijack_netrw = true,
      respect_buf_cwd = true,
      view = {
        number = true,
        relativenumber = true,
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
  { "nacro90/numb.nvim",       event = "BufReadPre", config = true }, -- TODO: remove?
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = true,
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
  { "tpope/vim-surround",           event = "BufReadPre" },
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
  { "m4xshen/smartcolumn.nvim",     opts = { colorcolumn = "80", }, },
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
    lazy = false,
    dependencies = {
      "tpope/vim-dadbod"
    }
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
  --   event = { "BufReadPre /Users/hcasten/Library/Mobile Documents/iCloud~md~obsidian/Documents/**.md" },
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand':
  --   -- event = { "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md" },
  --   dependencies = {
  --     -- Required.
  --     "nvim-lua/plenary.nvim",

  --     -- see below for full list of optional dependencies 👇
  --   },
  --   opts = {
  --     dir = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/ObsidianVault/", -- no need to call 'vim.fn.expand' here
  --     daily_notes = {
  --       -- Optional, if you keep daily notes in a separate directory.
  --       folder = "calendar",
  --       -- Optional, if you want to change the date format for daily notes.
  --       date_format = "%Y-%m-%d"
  --     },
  --     -- see below for full list of options 👇
  --   },
  -- },
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
