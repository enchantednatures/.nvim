local bufnr = vim.api.nvim_get_current_buf()
-- vim.keymap.set("n", "<M-CR>", vim.lsp.buf.code_action, { buffer = bufnr })
-- vim.lsp.inlay_hint(0)

vim.keymap.set(
  "n",
  "<leader>ca",
  function()
    vim.cmd.RustLsp("codeAction")
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set("n", "<leader>cI", function()
    vim.lsp.inlay_hint(bufnr)
  end,

  { desc = "Inlay Hints" },
  { buffer = bufnr }
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

vim.g.rustaceanvim = {
  -- Plugin configuration
  -- LSP configuration
  -- DAP configuration
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
