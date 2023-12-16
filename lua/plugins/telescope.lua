return {
  {
    "lazytanuki/nvim-mapper",
    config = function()
      require("nvim-mapper").setup({})
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
          {
            "nvim-tree/nvim-web-devicons",
            dependencies = { "DaikyXendo/nvim-material-icon" },
            config = function()
              require("nvim-web-devicons").setup({
                override = require("nvim-material-icon").get_icons(),
              })
            end,
          },
        }
      },
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "olacin/telescope-cc.nvim",

      { "ThePrimeagen/git-worktree.nvim",           lazy = false },
      "ahmedkhalf/project.nvim",
      -- { "ANGkeith/telescope-terraform-doc.nvim" },
      "cljoly/telescope-repo.nvim",
      "camgraff/telescope-tmux.nvim",
      -- "fhill2/telescope-ultisnips.nvim",
      "debugloop/telescope-undo.nvim",
      { "nvim-telescope/telescope-github.nvim" },
      {
        "ThePrimeagen/harpoon",
        dependencies = {
          "nvim-lua/plenary.nvim"
        },
        keys = {
          {
            "<leader>m",
            function(_)
              require("harpoon.mark").add_file()
            end,
            desc = "Harpoon [M]ark File"
          },
          {
            "<leader>hc2",
            function(_)
              require("harpoon.tmux").gotoTerminal(1)          -- goes to the first tmux window
              require("harpoon.tmux").sendCommand(1, "ls -La") -- sends ls -La to tmux window 1
              require("harpoon.tmux").sendCommand(1, 1)
            end,
            desc = "[H]arpoon [C]ommand 2"
          }
        }
      },
      "stevearc/aerial.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      {
        "lpoto/telescope-docker.nvim",
        opts = {},
        config = function(_, opts)
          require("telescope").load_extension "docker"
        end,
        keys = {
          { "<leader>td", "<Cmd>Telescope docker<CR>", desc = "Docker" },
        },
      },
      "molecule-man/telescope-menufacture",
      "kkharji/sqlite.lua",
    },
    cmd = "Telescope",
    -- stylua: ignore
    keys = {
      {
        "<leader>hm",
        "<Cmd>Telescope harpoon marks<cr>",
        desc = "Harpoon Menu"
      },
      {
        "<leader>s",
        function(curr)
          require("telescope.builtin").grep_string(curr)
        end,
        desc = "[S]earch word under cursor"
      },
      {
        "<leader>/",
        function()
          -- You can pass additional configuration to telescope to change theme, layout, etc.
          require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes")
            .get_dropdown {
              winblend = 10,
              previewer = false,
            })
        end,
        desc = "[/] Fuzzily search in current buffer]"

      },
      {
        "<leader>tf",
        require("utils").find_files,
        desc =
        "Find Files"
      },
      {
        "<leader>tt",
        "<cmd>Telescope git_worktree git_worktrees <cr>",
        desc =
        "Git Work[t]ree"
      },
      {
        "<leader>te",
        "<cmd>Telescope frecency theme=dropdown previewer=false<cr>",
        desc = "Common (FRecent)"
      },
      {
        "<leader><tab>",
        "<Cmd>lua require('telescope.builtin').commands()<CR>",
        desc = "Telescope Commands"
      },
      {
        "<leader>th",
        "<Cmd>Telescope help_tags<cr>",
        desc = "[T]elescope [H]elp"
      },
      {
        "<leader>tk",
        ":lua require('telescope.builtin').keymaps()<CR>",
        desc = "[T]elescope [K]eys"
      },
      {
        "<leader>to",
        "<cmd>Telescope buffers<cr>",
        desc = "Open Buffers"
      },
      {
        "<leader>tg",
        "<cmd>Telescope repo list<cr>",
        desc = "Git Repos"
      },
      {
        "<leader>cd",
        "<cmd>Telescope diagnostics<cr>",
        desc = "Document Diagnostics",
      },
      {
        "<leader>tD",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Workspace Diagnostics"
      },
      {
        "<leader>th",
        "<cmd>Telescope help_tags<cr>",
        desc = "Help"
      },
      {
        "<leader>ts",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end,
        desc = "[W]orkspace [S]ymbols"
      },
      {
        "<leader>tp",
        function()
          require("telescope").extensions.project.project { display_type = "minimal" }
        end,
        desc = "Projects",
      },
      {
        "<leader>tw",
        function() require("telescope").extensions.menufacture.live_grep() end,
        desc = "Workspace"
      },
      {
        "<leader>tr",
        "<cmd>Telescope oldfiles<cr>",
        desc = "Recents"
      },
      {
        "<leader>tb",
        function() require("telescope.builtin").current_buffer_fuzzy_find() end,
        desc = "Buffer",
      },
      {
        "<leader>ta",
        "<cmd>Telescope aerial<cr>",
        desc = "Aerial Code Outline"
      },
      {
        "<leader>zc",
        function() require("telescope.builtin").colorscheme({ enable_preview = true }) end,
        desc = "Colorscheme",
      },
      {
        "<leader>U",
        "<cmd>Telescope undo<cr>",
        desc = "Undo"
      },
      {
        "<leader>gc",
        function()
          require("telescope").extensions.conventional_commits.conventional_commits()
        end,
        desc = "Conventional Commit"
      },
      -- {
      --   "<leader>te",
      --   function() require("telescope").extensions.terraform_doc() end,
      --   desc = "[T]elescope T[e]rraform"
      -- },
    },
    config = function(_, _)
      local telescope = require("telescope")
      local icons = require("config.icons")
      local actions = require("telescope.actions")
      local actions_layout = require("telescope.actions.layout")
      local trouble = require("trouble.providers.telescope")
      local cc_actions = require("telescope._extensions.conventional_commits.actions")


      local mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<c-t>"] = trouble.open_with_trouble,
          ["?"] = actions_layout.toggle_preview,
        },
        n = {
          ["<c-t>"] = trouble.open_with_trouble,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      }

      local opts = {
        defaults = {
          prompt_prefix = icons.ui.Telescope .. " ",
          selection_caret = icons.ui.Forward .. " ",
          mappings = mappings,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            previewer = false,
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
          },
          git_files = {
            theme = "dropdown",
            previewer = false,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
          },
        },
        extensions = {
          conventional_commits = {
            action = cc_actions.prompt,
            include_body_and_footer = true,
          },
          file_browser = {
            theme = "dropdown",
            previewer = true,
            hijack_netrw = false,
            mappings = mappings,
          },
          project = {
            hidden_files = false,
            theme = "dropdown",
          },
          menufacture = {
            mappings = {
              main_menu = { [{ "i", "n" }] = "<C-^>" },
            },
          },
          repo = {
            list = {
              search_dirs = {
                "~/projects/",
                "~/work/",
              },
            },
          },
          -- ["ui-select"] = {
          --   require("telescope.themes").get_dropdown {
          --     codeactions = true
          --     -- even more opts
          --   } },
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
            layout_config = {
              preview_height = 0.8,
            },
            mappings = {
              i = {
                -- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
                -- you want to replicate these defaults and use the following actions. This means
                -- installing as a dependency of telescope in it's `requirements` and loading this
                -- extension from there instead of having the separate plugin definition as outlined
                -- above.
                ["<cr>"] = require("telescope-undo.actions").yank_additions,
                ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
                ["<C-cr>"] = require("telescope-undo.actions").restore,
              },
            },
          },

        },
      }
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
      telescope.load_extension("mapper")

      telescope.load_extension("project")
      telescope.load_extension("projects")
      telescope.load_extension("aerial")
      telescope.load_extension("dap")
      telescope.load_extension("frecency")
      telescope.load_extension("menufacture")
      telescope.load_extension("conventional_commits")
      telescope.load_extension("undo")
      telescope.load_extension("harpoon")
      telescope.load_extension("git_worktree")
      telescope.load_extension("gh")
      telescope.load_extension("tmux")
      telescope.load_extension("ui-select")
      -- telescope.load_extension("terraform_doc")
      -- telescope.load_extension("ultisnips")
    end,
  },
  {
    "stevearc/aerial.nvim",
    config = true,
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git" },
      })
    end,
  },
}
