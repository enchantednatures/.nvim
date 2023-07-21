local augroups = require "config.augroups"

vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
  group = augroups.fileOpened,
  once = true,
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
    if not (vim.fn.expand "%" == "" or buftype == "nofile") then
      vim.cmd "do User FileOpened"
      require("plugins.lsp").setup()
      vim.cmd "LspStart"
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroups.general_settings,
  pattern = "*",
  desc = "Highlight text on yank",
  callback = function()
    vim.highlight.on_yank { higroup = "Search", timeout = 200 }
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = augroups.noNewLineComments,
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "qf",
    "help",
    "man",
    "floaterm",
    "lspinfo",
    "lir",
    "lsp-installer",
    "null-ls-info",
    "tsplayground",
    "DressingSelect",
    "Jaq",
  },
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
    vim.opt_local.buflisted = false
  end,
  group = augroups.quickClose,
})

vim.api.nvim_create_autocmd({ "VimLeave" }, {
  callback = function()
    local command = "silent! " .. "pkill -f " .. "prettierd"
    vim.cmd(command)
  end,
  group = augroups.closePrettier,
})
