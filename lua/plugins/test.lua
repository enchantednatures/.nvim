return {
	{
		"vim-test/vim-test",
		keys = {
			{ "<leader>Tc", "<cmd>TestClass<cr>", desc = "Class" },
			{ "<leader>Tf", "<cmd>TestFile<cr>", desc = "File" },
			{ "<leader>Tl", "<cmd>TestLast<cr>", desc = "Last" },
			{ "<leader>Tn", "<cmd>TestNearest<cr>", desc = "Nearest" },
			{ "<leader>Ts", "<cmd>TestSuite<cr>", desc = "Suite" },
			{ "<leader>Tv", "<cmd>TestVisit<cr>", desc = "Visit" },
		},
		config = function()
			vim.g["test#strategy"] = "neovim"
			vim.g["test#neovim#term_position"] = "belowright"
			vim.g["test#neovim#preserve_screen"] = 1
			vim.g["test#python#runner"] = "pyunit" -- pytest
		end,
	},
	{
		"nvim-neotest/neotest",
		keys = {
			{
				"<leader>TNF",
				"<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
				desc = "Debug File",
			},
			{ "<leader>TNL", "<cmd>lua require('neotest').run.run_last({strategy = 'dap'})<cr>", desc = "Debug Last" },
			{ "<leader>TNa", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach" },
			{ "<leader>TNf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "File" },
			{ "<leader>TNl", "<cmd>lua require('neotest').run.run_last()<cr>", desc = "Last" },
			{ "<leader>TNn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Nearest" },
			{ "<leader>TNN", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug Nearest" },
			{ "<leader>TNo", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", desc = "Output" },
			{ "<leader>TNs", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop" },
			{ "<leader>TNS", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Summary" },
		},
		dependencies = {
			"vim-test/vim-test",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-plenary",
			"nvim-neotest/neotest-vim-test",
			"rouge8/neotest-rust",
		},
		config = function()
			local opts = {
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						runner = "unittest",
					}),
					require("neotest-plenary"),
					require("neotest-vim-test")({
						ignore_file_types = { "python", "vim", "lua" },
					}),
					require("neotest-rust"),
				},
				-- overseer.nvim
				consumers = {
					overseer = require("neotest.consumers.overseer"),
				},
				overseer = {
					enabled = true,
					force_default = true,
				},
			}
			require("neotest").setup(opts)
		end,
	},
	{
		"stevearc/overseer.nvim",
		keys = {
			{ "<leader>ToR", "<cmd>OverseerRunCmd<cr>", desc = "Run Command" },
			{ "<leader>Toa", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
			{ "<leader>Tob", "<cmd>OverseerBuild<cr>", desc = "Build" },
			{ "<leader>Toc", "<cmd>OverseerClose<cr>", desc = "Close" },
			{ "<leader>Tod", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
			{ "<leader>Tol", "<cmd>OverseerLoadBundle<cr>", desc = "Load Bundle" },
			{ "<leader>Too", "<cmd>OverseerOpen<cr>", desc = "Open" },
			{ "<leader>Toq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
			{ "<leader>Tor", "<cmd>OverseerRun<cr>", desc = "Run" },
			{ "<leader>Tos", "<cmd>OverseerSaveBundle<cr>", desc = "Save Bundle" },
			{ "<leader>Tot", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
		},
		config = true,
	},
	-- {
	--   "andythigpen/nvim-coverage",
	--   cmd = { "Coverage" },
	--   config = true,
	-- },
}
