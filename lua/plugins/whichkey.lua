return {
  {
    "mrjones2014/legendary.nvim",
    keys = {
      -- { "<S-CR>", "<cmd>Legendary<cr>", desc = "Command Palette" },
      { "<C-P", "<cmd>Legendary<cr>", desc = "Command Palette" },
      -- { "<leader>hc", "<cmd>Legendary<cr>", desc = "Command Palette" },
    },
    opts = {
      which_key = { auto_register = true },
    },
  },
  {
    "folke/which-key.nvim",
    dependencies = {
      "mrjones2014/legendary.nvim",
    },
    event = "VeryLazy",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
      local wk = require("which-key")
      wk.setup({
        show_help = true,
        plugins = {
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          marks = true,
          registers = true,
          presets = {
            operators = true, -- adds help for operators like d, y, ...
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true,    -- misc bindings to work with windows
            z = true,      -- bindings for folds, spelling and others prefixed with z
            g = true,      -- bindings for prefixed with g
          },
        },
        key_labels = { ["<leader>"] = "SPC" },
        triggers = "auto",
      })
      --		wk.register({
      --			["<leader>"] = {
      --				mode = { "n" },
      --				name = "Leader",

      --				k = { "<cmd>lnext<CR>zz" },
      --				j = { "<cmd>lprev<CR>zz" },

      --				s = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]] },
      --				x = { "<cmd>!chmod +x %<CR>", { silent = true } },
      --			},
      --		})
      wk.register({
        mode = { "n", "v" },
        ["m"] = {
          name = "Marks",
          [","] = { desc = "Set next alpa" },
          [";"] = { desc = "Toggle next alpa" },
          ["]"] = { desc = "Move to next mark" },
          ["["] = { desc = "Move to previous mark" },
        },
        ["<leader>"] = {
          name = "Leader",
          w = { "<cmd>update!<CR>", "Save" },
          [";"] = { "<cmd>Alpha<CR>", "Dashboard" },
          --
          -- stylua: ignore
          q = {
            name = "Quit",
            q = { function() require("utils").quit() end, "Quit", },
            t = { "<cmd>tabclose<cr>", "Close Tab" },
          },
          b = { name = "+Buffer" },
          d = { name = "+Debug" }, -- move to hydra except breakpoints and run
          f = { name = "+File" },
          h = { name = "+Help" },
          g = { name = "+Git" },
          p = { name = "+Project" },
          t = { name = "+Telescope" },
          T = { name = "+Test", N = { name = "Neotest" }, o = { "Overseer" } },
          v = { name = "+View" },
          z = { name = "+System" },
          -- move to a hydra
          D = {
            name = "+Database",
            u = { "<Cmd>DBUIToggle<Cr>", "Toggle UI" },
            f = { "<Cmd>DBUIFindBuffer<Cr>", "Find buffer" },
            r = { "<Cmd>DBUIRenameBuffer<Cr>", "Rename buffer" },
            q = { "<Cmd>DBUILastQueryInfo<Cr>", "Last query info" },
          },
          -- stylua: ignore
          s = {
            name = "+Search",
            c = { function() require("utils.coding").cht() end, "Cheatsheets", },
            s = { function() require("utils.coding").stack_overflow() end, "Stack Overflow", },
            -- n = { name = "+Noice" },
          },
          c = {
            name = "+Code",
            g = { name = "Annotation" },
            x = {
              name = "Swap Next",
              f = "Function",
              p = "Parameter",
              c = "Class",
            },
            X = {
              name = "Swap Previous",
              f = "Function",
              p = "Parameter",
              c = "Class",
            },
          },
        },
      })
      -- wk.register({
      -- 	mode = { "n" },
      -- 	["<leader>"] = {
      -- 		[";"] = { "<cmd>Alpha<CR>", "Dashboard" },
      -- 		w = { "<cmd>update!<CR>", "Save" },

      -- 		-- c = { "<cmd>enew<cr>", "New File" },

      -- 	},
      -- })
    end,
  },
}
