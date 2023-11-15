return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      local components = require "plugins.statusline.components"
      -- local copilot_cfg = {
      --   function()
      --     local icon = require("config.icons").kind.Copilot
      --     local status = require("copilot.api").status.data
      --     return icon .. (status.message or "")
      --   end,
      --   cond = function()
      --     local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
      --     return ok and #clients > 0
      --   end,
      -- }

      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "auto",
           
          component_separators = {},
          section_separators = {},
          disabled_filetypes = {
            statusline = { "alpha", "lazy" },
            winbar = {
              "help",
              "alpha",
              "lazy",
            },
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { components.git_repo, "branch" },
          lualine_c = {
            components.diff,
            components.diagnostics,
            components.noice_command,
            components.noice_mode,
            components.separator,
            components.lsp_client,
          },
          lualine_x = {
            "filename",
            -- copilot_cfg,
            components.spaces,
            "encoding",
            "fileformat",
            "filetype",
            "progress" },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "nvim-tree", "toggleterm", "quickfix" },
      }
    end,
  },
}
