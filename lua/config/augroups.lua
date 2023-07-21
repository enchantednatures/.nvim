local M = {}

local augroup = vim.api.nvim_create_augroup

M.autoformat = augroup("AutoFormat", { clear = true })
M.autorun = augroup("AutoRun", { clear = true })
M.autotex = augroup("AutoTex", { clear = true })
M.general_settings = augroup("GeneralSettings", { clear = true })
M.lspDocumentHighlight = augroup("lsp_document_highlight", { clear = true })
M.noNewLineComments = augroup("NoNewLineComments", { clear = true })
M.winbar = augroup("_WinBar", { clear = true })
M.inlayHints = augroup("LspAttachInlayHints", { clear = true })
M.lspFeatures = augroup("LspAttachGeneralFeatures", { clear = true })
M.codelens = augroup("LspCodelens", { clear = true })
M.quickClose = augroup("QuickCloseQuickFix", { clear = true })
M.closePrettier = augroup("ClosePrettier", { clear = true })
M.fileOpened = augroup("FileOpened", { clear = true })

return M
