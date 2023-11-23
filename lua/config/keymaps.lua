local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
-- Center Text on the Screen {{{
local remapList = {
  "p",
  "P",
  "<CR>",
  "gg",
  "H",
  "L",
  "n",
  "N",
  "%",
  "<c-o>",
  "<c-u>",
  "<c-d>",
  "<c-j>",
  "<c-n>",
  "<c-m>",
  "-",
  "+",
  "_",
  "{",
  "}",
  "[[",
  "[*",
  "[/",
  "]*",
  "]/",
  "]]",
  "[{",
  "]}",
  "g,",
  "g;"
}

for k in pairs(remapList) do
  keymap("n", remapList[k], remapList[k] .. "zz", opts)
  keymap("v", remapList[k], remapList[k] .. "zz", opts)
end
-- Better viewing
-- Better escape using jk in insert and terminal mode

local keymap = vim.keymap.set
keymap("t", "jk", "<C-\\><C-n>")
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h")
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j")
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k")
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l")
-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- Better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP')

-- Move Lines
-- keymap("n", "<A-j>", ":m .+1<CR>==")
-- keymap("v", "<A-j>", ":m '>+1<CR>gv=gv")
-- keymap("n", "<A-k>", ":m .-2<CR>==")
-- keymap("v", "<A-k>", ":m '<-2<CR>gv=gv")
-- keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
-- keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- Resize window using <shift> arrow keys
keymap("n", "<S-Up>", "<cmd>resize +2<CR>")
keymap("n", "<S-Down>", "<cmd>resize -2<CR>")
keymap("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
keymap("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

keymap("n", "J", "mzJ`z")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

keymap("n", "<Leader>wt", [[:%s/\s\+$//e<cr>]])
keymap("n", "<leader>wq", ":update<CR>:quit<CR>")
-- greatest remap ever
keymap("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
keymap({ "n", "v" }, "<leader>y", [["+y]])
keymap("n", "<leader>Y", [["+Y]])

keymap({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
keymap("i", "<C-c>", "<Esc>")

keymap("n", "Q", "<nop>")
-- keymap("n", "<leader>f", vim.lsp.buf.format)

keymap("n", "<C-k>", "<cmd>cnext<CR>zz")
keymap("n", "<C-j>", "<cmd>cprev<CR>zz")
keymap("n", "<leader>k", "<cmd>lnext<CR>zz")
keymap("n", "<leader>j", "<cmd>lprev<CR>zz")

keymap(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Search and replace word under cursor" }
)
keymap("n", "<M-x>", "<cmd>!chmod +x %<CR>", { silent = true })
-- keymap("n", "<leader>w", "<cmd>w <CR>")
keymap("n", "<leader>sv", ":source $MYVIMRC<CR>", { silent = true })
keymap("n", "<C-a>", "ggVG")
-- vim.keymap.set({ "n", "x" }, "<leader>ssr", function() require("ssr").open() end)
