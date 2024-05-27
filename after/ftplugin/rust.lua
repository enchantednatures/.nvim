vim.cmd("compiler cargo")

-- Make quickfix window show up automatically after compiling
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "[^l]*",
  command = "cwindow",
  nested = true,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "l*",
  command = "lwindow",
  nested = true,
})

vim.g.rustaceanvim = {
  dap = {},

  tools = {
    runnables = {
      use_telescope = true,
    },
    hover_actions = {
      auto_focus = true,
    },
    code_actions = {
      use_telescope = true,
    },
  },
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set(
        "n",
        "<leader>ca",
        function()
          vim.cmd.RustLsp("codeAction")
        end,
        { silent = true, buffer = bufnr }
      )

      vim.keymap.set(
        "n",
        "<leader>ch",
        function()
          vim.cmd.RustLsp { "hover", "actions" }
        end,
        { desc = "Hover action" },
        { buffer = bufnr }
      )

      vim.keymap.set(
        "n",
        "<leader>cb",
        function()
          vim.cmd.RustLsp { "runnables" }
        end,
        { desc = "[C]argo [B]uild" },
        { buffer = bufnr }
      )

      vim.lsp.inlay_hint.enable()
    end,
    settings = {
      ["rust-analyzer"] = {
        imports = {
          granularity = {
            group = "module",
          },
          prefix = "self",
        },
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        checkOnSave = {
          allFeatures = true,
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
            leptos_macro = {
              "component",
              "server"
            }
          }
        }
      },
    },
  },
}
