local M = {}

local function augroup(name, opts)
  return vim.api.nvim_create_augroup("nde_" .. name, opts)
end

M.attachDadbodCompletion = augroup("AttachDadbodCompletion", { clear = true })
M.autoCreateDirectory = augroup("AutoCreateDirectory", { clear = true })
M.autoformat = augroup("AutoFormat", { clear = true })
M.autorun = augroup("AutoRun", { clear = true })
M.autotex = augroup("AutoTex", { clear = true })
M.closePrettier = augroup("ClosePrettier", { clear = true })
M.codelens = augroup("LspCodelens", { clear = true })
M.fileOpened = augroup("FileOpened", { clear = true })
M.general_settings = augroup("GeneralSettings", { clear = true })
M.inlayHints = augroup("LspAttachInlayHints", { clear = true })
M.lspDocumentHighlight = augroup("lsp_document_highlight", { clear = true })
M.lspFeatures = augroup("LspAttachGeneralFeatures", { clear = true })
M.noNewLineComments = augroup("NoNewLineComments", { clear = true })
M.openToLastLoc = augroup("OpenToLastLoc", { clear = true })
M.quickClose = augroup("QuickCloseQuickFix", { clear = true })
M.theme = augroup("Theme", { clear = true })
M.winbar = augroup("_WinBar", { clear = true })
M.cmpCargo = augroup("CmpSourceCargo", { clear = true })

return M
