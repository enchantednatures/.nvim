local augroups = require("config.autocommands.augroups")

local ns = vim.api.nvim_create_namespace("toggle_hlsearch")
local function toggle_hlsearch(char)
  if vim.fn.mode() == "n" then
    local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end

vim.on_key(toggle_hlsearch, ns)

vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" })

vim.api.nvim_create_autocmd("FileType", {
  group = augroups.attachDadbodCompletion,
  pattern = { "*.sql", "*.mysql", "*.plsql" },
  callback = function(_)
    require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
  group = augroups.fileOpened,
  once = true,
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
    if not (vim.fn.expand("%") == "" or buftype == "nofile") then
      vim.cmd("do User FileOpened")
      -- todo:
      -- require("user.lsp").setup()
      vim.cmd("LspStart")
    end
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroups.openToLastLoc,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroups.autoCreateDirectory,
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroups.general_settings,
  pattern = "*",
  desc = "Highlight text on yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "Search", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = augroups.noNewLineComments,
  callback = function()
    vim.cmd("set formatoptions-=cro")
  end,
})


vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "DressingSelect",
    "Jaq",
    "OverseerForm",
    "OverseerList",
    "checkhealth",
    "floaterm",
    "floggraph",
    "fugitive",
    "git",
    "gitcommit",
    "help",
    "lir",
    "lsp-installer",
    "lspinfo",
    "man",
    "neoai-input",
    "neoai-output",
    "neotest-output",
    "neotest-summary",
    "octo",
    "qf",
    "dbout",
    "query",
    "spectre_panel",
    "startuptime",
    "toggleterm",
    "tsplayground",
    "vim",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
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
