local ok, lsp = pcall(require, "lsp-zero")
if not ok then
  return
end
local schemastore_ok, schemastore = pcall(require, "schemastore")
if not schemastore_ok then
  return
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp.configure("jsonls", {
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  },
})
