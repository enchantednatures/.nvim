-- return {
-- 	"williamboman/mason.nvim",
-- 	cmd = "Mason",
-- 	keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
-- 	opts = {
-- 		ensure_installed = {
-- 			"stylua",
-- 			"rust-analyzer",
-- 			"sqlls",
-- 			"sqlfmt",
-- 			"lua-language-server",
-- 			"debugpy",
-- 			"codelldb",
-- 		},
-- 	},
-- 	config = function(_, opts)
-- 		require("mason").setup()
-- 		local mr = require("mason-registry")
-- 		for _, tool in ipairs(opts.ensure_installed) do
-- 			local p = mr.get_package(tool)
-- 			if not p:is_installed() then
-- 				p:install()
-- 			end
-- 		end
-- 	end,
-- }
local M = {}

function M.config()
    local mr = require("mason-registry")
    local mason = require("mason")
    mason.setup()
    for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
            p:install()
        end
    end
end

return M
