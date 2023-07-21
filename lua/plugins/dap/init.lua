return {
	"mfussenegger/nvim-dap",
	dependencies = {
		{ "rcarriga/nvim-dap-ui" },
		{ "theHamsta/nvim-dap-virtual-text" },
		{ "nvim-telescope/telescope-dap.nvim" },
		{ "jbyuki/one-small-step-for-vimkind" },
	},
	lazy = false,
    -- stylua: ignore
    keys = {
        { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
    },
	opts = {
		setup = {
			osv = function(_, _)
				require("plugins.dap.lua").setup()
			end,
			rust = function(_, _)
				require("plugins.dap.rust").config()
			end,
		},
	},
	config = function(plugin, opts)
		require("nvim-dap-virtual-text").setup({
			commented = true,
		})

		local dap, dapui = require("dap"), require("dapui")
		dapui.setup({})

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- set up debugger
		for k, _ in pairs(opts.setup) do
			opts.setup[k](plugin, opts)
		end
	end,
}
