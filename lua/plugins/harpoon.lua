return {
  "theprimeagen/harpoon",
  keys = {
    { "<leader>m", function() require("harpoon.mark").add_file() end, mode = { "n" },
      desc = "Mark File", },
    { "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end, mode = { "n" },
      desc = "Open Harpoon UI", },
    { "<leader>hc", function() require("harpoon.cmd-ui").toggle_quick_menu() end,
      desc = "Command Menu", },
    { "<leader>hm1", function() require("harpoon.ui").nav_file(1) end, desc = "File 1", },
    { "<leader>hm2", function() require("harpoon.ui").nav_file(2) end, desc = "File 2", },
    { "<leader>hm3", function() require("harpoon.ui").nav_file(3) end, desc = "File 3", },
    { "<leader>hm4", function() require("harpoon.ui").nav_file(4) end, desc = "File 4", },
    { "<leader>ht1", function() require("harpoon.term").gotoTerminal(1) end, desc = "Terminal 1", },
    { "<leader>ht2", function() require("harpoon.term").gotoTerminal(2) end, desc = "Terminal 2", },
    { "<leader>hc1", function() require("harpoon.term").sendCommand(1, 1) end, desc = "Command 1", },
    { "<leader>hc2", function() require("harpoon.term").sendCommand(1, 2) end, desc = "Command 2", },
  },
}
--[[
    local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>m", mark.add_file)
vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu)

vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)


]]
