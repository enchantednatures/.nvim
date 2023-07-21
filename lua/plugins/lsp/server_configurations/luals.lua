local lsp_ok, lsp = pcall(require, "lsp-zero")
if not lsp_ok then
  return
end

require "plugins.lsp.neodev"

lsp.configure("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "custom_nvim" },
      },
      library = vim.api.nvim_get_runtime_file("", true),
      checkThirdParty = false,
      hint = { enable = true },
      telemetry = { enable = false },
    },
  },
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
  end,
})
