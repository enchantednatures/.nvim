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

-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- LSP Diagnostics Options Setup
-- local sign = function(opts)
--   vim.fn.sign_define(opts.name, {
--     texthl = opts.name,
--     text = opts.text,
--     numhl = ""
--   })
-- end

-- sign({ name = "DiagnosticSignError", text = "" })
-- sign({ name = "DiagnosticSignWarn", text = "" })
-- sign({ name = "DiagnosticSignHint", text = "󰌵" })
-- sign({ name = "DiagnosticSignInfo", text = "" })
-- local signs = {
--   ERROR = "",
--   WARN = "",
--   HINT = "󰌵",
--   INFO = "",
-- }

-- vim.diagnostic.config({
--   virtual_text = {
--     prefix = function(diagnostic)
--       return signs[vim.diagnostic.severity[diagnostic.severity]]
--     end,
--   },
--   signs = true,
--   update_in_insert = true,
--   underline = true,
--   severity_sort = false,
--   float = {
--     border = "rounded",
--     source = "always",
--     header = "",
--     prefix = "",
--   },
-- })


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
  virtual_text = false,
  virtual_lines = true,
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
-- vim.cmd([[
-- set signcolumn=yes
-- autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
-- ]])

local groups = {
  "BufferLine",
  "Comment",
  "Conditional",
  "Constant",
  "CursorLine",
  "CursorLineNr",
  "EndOfBuffer",
  "Function",
  "Identifier",
  "LineNr",
  "NonText",
  "Normal",
  "NormalFloat",
  "NormalNC",
  "NormalSB",
  "Operator",
  "PreProc",
  "Repeat",
  "SignColumn",
  "Special",
  "Statement",
  "StatusLine",
  "StatusLineNC",
  "String",
  "Structure",
  "TelescopeNormal",
  "Todo",
  "Type",
  "Underlined",
}

for _, v in ipairs(groups) do
  local ok, prev_attrs = pcall(vim.api.nvim_get_hl_by_name, v, true)
  if ok and (prev_attrs.background or prev_attrs.bg or prev_attrs.ctermbg) then
    local attrs = vim.tbl_extend("force", prev_attrs, { bg = "NONE", ctermbg = "NONE" })
    attrs[true] = nil
    vim.api.nvim_set_hl(0, v, attrs)
  end
end
