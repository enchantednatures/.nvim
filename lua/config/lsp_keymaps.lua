local M = {}

function M.on_attach(client, buffer)
  local self = M.new(client, buffer)

  self:map("gd", "Telescope lsp_definitions", { desc = "[G]oto [D]efinition" })
  self:map("gr", "Telescope lsp_references", { desc = "[G]oto [R]eferences" })
  self:map("gD", "Telescope lsp_declarations", { desc = "[G]oto [D]eclaration" })
  self:map("gI", "Telescope lsp_implementations", { desc = "[G]oto [I]mplementation" })
  self:map("gb", "Telescope lsp_type_definitions", { desc = "Goto Type Definition" })
  self:map("K", "lua vim.lsp.buf.hover()", { desc = "Hover" })
  self:map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
  self:map("[d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
  self:map("]d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
  self:map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  self:map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  self:map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
  self:map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })
  self:map("<leader>ca", "Lspsaga code_action", { desc = "Code Action" })
  self:map("gi", "Lspsaga finder imp", { desc = "[G]oto [I]mplementation" })

  self:map("]s", "Lspsaga show_workspace_diagnostics", { desc = "Workspace diagnostics" })
  self:map("[s", "Telescope diagnostics", { desc = "Workspace diagnostics(Telescope)" })



  local format = require("config.format").format
  self:map("<leader>f", format, { desc = "Format Document", has = "documentFormatting" })
  self:map("<leader>f", format,
    { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })
  self:map("<leader>cr", M.rename, { expr = true, desc = "Rename", has = "rename" })

  self:map("<leader>cs", require("telescope.builtin").lsp_document_symbols,
    { desc = "Document Symbols" })
  self:map("<leader>cS", require("telescope.builtin").lsp_dynamic_workspace_symbols,
    { desc = "Workspace Symbols" })
end

function M.new(client, buffer)
  return setmetatable({ client = client, buffer = buffer }, { __index = M })
end

function M:has(cap)
  return self.client.server_capabilities[cap .. "Provider"]
end

function M:map(lhs, rhs, opts)
  opts = opts or {}
  if opts.has and not self:has(opts.has) then
    return
  end
  vim.keymap.set(
    opts.mode or "n",
    lhs,
    type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
    ---@diagnostic disable-next-line: no-unknown
    { silent = true, buffer = self.buffer, expr = opts.expr, desc = opts.desc }
  )
end

function M.rename()
  if pcall(require, "inc_rename") then
    return ":IncRename " .. vim.fn.expand("<cword>")
  else
    vim.lsp.buf.rename()
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
