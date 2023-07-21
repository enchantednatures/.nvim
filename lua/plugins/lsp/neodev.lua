local neodev_loaded, neodev = pcall(require, "neodev")
if not neodev_loaded then
  return
end

neodev.setup {
  lspconfig = {
    settings = {
      Lua = {
        completion = {
          globals = { "vim", "custom_nvim" },
          -- callSnippet = "Replace"
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false
          -- library = "~/.config/nvim"
        },
        hint = { enable = true },
        telemetry = { enable = false },
      },
    },
  },
  library = {
    vimruntime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    -- plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    plugins = { "plenary.nvim" },
  },
}
