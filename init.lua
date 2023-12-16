vim.g.mapleader = " "

require("config.options")
require("config.lazy")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.autocommands")
    require("config.keymaps")
  end,
})

-- LSP Diagnostics Options Setup
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ""
  })
end

sign({ name = "DiagnosticSignError", text = "" })
sign({ name = "DiagnosticSignWarn", text = "" })
sign({ name = "DiagnosticSignHint", text = "" })
sign({ name = "DiagnosticSignInfo", text = "" })

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

