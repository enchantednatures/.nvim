vim.opt_local.textwidth  = 0
vim.opt_local.wrapmargin = 0
vim.opt_local.wrap       = true
vim.opt_local.linebreak  = true
vim.opt_local.columns    = 80

local opts               = { noremap = true, silent = true }
local keymap             = vim.api.nvim_set_keymap
local remapList          = {
  "j",
  "k,",
}

for k in pairs(remapList) do
  keymap("n", remapList[k], "g" .. remapList[k] .. "zz", opts)
end
