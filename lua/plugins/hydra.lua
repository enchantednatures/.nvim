local function quick_menu()
	local cmd = require("hydra.keymap-util").cmd
	return {
		name = "Quick Menu",
		mode = { "n" },
		hint = [[
        Quick Menu
^
_f_: Show Terminal (float)
_v_: Open Terminal (vertical)Commands
_h_: Open Terminal (horizontal)
_x_: Open Quickfix
_l_: Open Location List
_s_: Buffer Fuzzy Search
_o_: Open Symbols Outline
_t_: Show Help Tags
_k_: Show Keymaps
_c_: Show Vim Commands
_m_: Show Man Pages
^
^ ^  _q_/_<Esc>_: Exit Hydra
    ]],
		config = {
			color = "teal",
			invoke_on_body = true,
			hint = {
				type = "window",
				position = "bottom",
				border = "rounded",
				show_name = true,
			},
		},
		body = "<leader>qm",
		heads = {
			{ "t", cmd("Telescope help_tags"), { desc = "Open Help Tags", silent = true } },
			{ "k", ":lua require('telescope.builtin').keymaps()<CR>", { desc = "Open Neovim Keymaps", silent = true } },
			{
				"c",
				cmd("Telescope commands"),
				{ desc = "Open Available Telescope Commands", silent = true },
			},
			{ "m", cmd("Telescope man_pages"), { desc = "Opens Man Pages", silent = true } },

			{
				"s",
				cmd("Telescope current_buffer_fuzzy_find skip_empty_lines=true"),
				{ desc = "Fuzzy find in current buffer", silent = true },
			},
			{
				"o",
				cmd("Telescope aerial"),
				{ desc = "Opens Symbols Outline", exit = true, silent = true },
			},

			{ "x", cmd("TroubleToggle quickfix"), { desc = "Opens Quickfix", silent = true } },
			{ "l", cmd("TroubleToggle loclist"), { desc = "Opens Location List", silent = true } },
			{ "f", cmd("ToggleTerm direction=float"), { desc = "Floating Terminal", silent = true } },
			{ "v", cmd("ToggleTerm direction=vertical"), { desc = "Vertical Terminal", silent = true } },
			{ "h", cmd("ToggleTerm direction=horizontal"), { desc = "Horizontal Terminal", silent = true } },
			{ "q", nil, { desc = "quit", exit = true, nowait = true } },
			{ "<Esc>", nil, { desc = "quit", exit = true, nowait = true } },
		},
	}
end
local function gitsigns_menu()
	local gitsigns = require("gitsigns")

	local hint = [[
 _J_: Next hunk             _s_: Stage Hunk        _d_: Show Deleted   _b_: Blame Line
 _K_: Prev hunk             _u_: Undo Last Stage   _p_: Preview Hunk   _B_: Blame Show Full
 _c_: Conventional Commits  _S_: Stage Buffer      _P_: Git Push       _/_: Show Base File
 ^
 ^ ^              _<Enter>_: LazyGit              _q_: Exit
]]

	return {
		name = "Git",
		hint = hint,
		config = {
			color = "pink",
			invoke_on_body = true,
			hint = {
				border = "rounded",
				position = "bottom",
			},
			on_enter = function()
				vim.cmd("mkview")
				vim.cmd("silent! %foldopen!")
				vim.bo.modifiable = false
				gitsigns.toggle_signs(true)
				gitsigns.toggle_linehl(true)
			end,
			on_exit = function()
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				vim.cmd("loadview")
				vim.api.nvim_win_set_cursor(0, cursor_pos)
				vim.cmd("normal zv")
				gitsigns.toggle_signs(false)
				gitsigns.toggle_linehl(false)
				gitsigns.toggle_deleted(false)
			end,
		},
		body = "<M-g>",
		heads = {
			{
				"J",
				function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gitsigns.next_hunk()
					end)
					return "<Ignore>"
				end,
				{ expr = true, desc = "Next Hunk" },
			},
			{
				"K",
				function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gitsigns.prev_hunk()
					end)
					return "<Ignore>"
				end,
				{ expr = true, desc = "Prev Hunk" },
			},
			{ "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "Stage Hunk" } },
			{ "u", gitsigns.undo_stage_hunk, { desc = "Undo Last Stage" } },
			{ "S", gitsigns.stage_buffer, { desc = "Stage Buffer" } },
			{ "p", gitsigns.preview_hunk, { desc = "Preview Hunk" } },
			{ "d", gitsigns.toggle_deleted, { nowait = true, desc = "Toggle Deleted" } },
			{
				"c",
				function()
					require("telescope").extensions.conventional_commits.conventional_commits()
				end,
				{ desc = "Conventional Commit" },
			},
			{ "P", ":Git push<CR>", { desc = "Blame" } },
			{ "b", gitsigns.blame_line, { desc = "Blame" } },
			{
				"B",
				function()
					gitsigns.blame_line({ full = true })
				end,
				{ desc = "Blame Show Full" },
			},
			{ "/", gitsigns.show, { exit = true, desc = "Show Base File" } }, -- show the base of the file
			{ "<Enter>", "<Cmd>LazyGit<CR>", { exit = true, desc = "LazyGit" } },
			{ "q", nil, { exit = true, nowait = true, desc = "Exit" } },
		},
	}
end
local function dap_menu()
	local dap = require("dap")
	local dapui = require("dapui")
	local dap_widgets = require("dap.ui.widgets")

	local hint = [[
 _t_: Toggle Breakpoint             _R_: Run to Cursor
 _s_: Start                         _E_: Evaluate Input
 _c_: Continue                      _C_: Conditional Breakpoint
 _b_: Step Back                     _U_: Toggle UI
 _d_: Disconnect                    _S_: Scopes
 _e_: Evaluate                      _X_: Close
 _g_: Get Session                   _i_: Step Into
 _h_: Hover Variables               _o_: Step Over
 _r_: Toggle REPL                   _u_: Step Out
 _x_: Terminate                     _p_: Pause
 ^ ^               _q_: Quit
]]

	return {
		name = "Debug",
		hint = hint,
		config = {
			color = "pink",
			invoke_on_body = true,
			hint = {
				border = "rounded",
				position = "middle-right",
			},
		},
		mode = "n",
		body = "<leader>dd",
        -- stylua: ignore
        heads = {
            { "C", function() dap.set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
            { "E", function() dapui.eval(vim.fn.input "[Expression] > ") end,        desc = "Evaluate Input", },
            { "R", function() dap.run_to_cursor() end,                               desc = "Run to Cursor", },
            { "S", function() dap_widgets.scopes() end,                              desc = "Scopes", },
            { "U", function() dapui.toggle() end,                                    desc = "Toggle UI", },
            { "X", function() dap.close() end,                                       desc = "Quit", },
            { "b", function() dap.step_back() end,                                   desc = "Step Back", },
            { "c", function() dap.continue() end,                                    desc = "Continue", },
            { "d", function() dap.disconnect() end,                                  desc = "Disconnect", },
            {
                "e",
                function() dapui.eval() end,
                mode = { "n", "v" },
                desc =
                "Evaluate",
            },
            { "g", function() dap.session() end,           desc = "Get Session", },
            { "h", function() dap_widgets.hover() end,     desc = "Hover Variables", },
            { "i", function() dap.step_into() end,         desc = "Step Into", },
            { "o", function() dap.step_over() end,         desc = "Step Over", },
            { "p", function() dap.pause.toggle() end,      desc = "Pause", },
            { "r", function() dap.repl.toggle() end,       desc = "Toggle REPL", },
            { "s", function() dap.continue() end,          desc = "Start", },
            { "t", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint", },
            { "u", function() dap.step_out() end,          desc = "Step Out", },
            { "x", function() dap.terminate() end,         desc = "Terminate", },
            { "q", nil, {
                exit = true,
                nowait = true,
                desc = "Exit"
            } },
        },
	}
end

local function telescope_hydra()
	local cmd = require("hydra.keymap-util").cmd
	return {
		name = "Telescope",
		mode = { "n" },
		hint = [[
        Telescope
^
_f_: Find Files                 _c_: Common (FRecent)
_o_: Open Buffers               _g_: Git Repos
_h_: Help                       _p_: Projects
_w_: Workspace                  _r_: Recents
_b_: Buffer                     _a_: Aerial Code Outline
_z_: Colorscheme                _U_: Undo
_k_: Keymaps
^ ^                 _q_: Quit
    ]],
		config = {
			color = "blue",
			invoke_on_body = true,
			hint = {
				type = "window",
				position = "bottom",
				border = "rounded",
				show_name = true,
			},
		},
		body = "<leader>tt",
		heads = {
			{ "f", cmd("lua require('utils').find_files()"), { desc = "Find Files", silent = true } },
			{
				"c",
				cmd("Telescope frecency theme=dropdown previewer=false"),
				{ desc = "Common (FRecent)", silent = true },
			},
			{ "o", cmd("Telescope buffers"), { desc = "Open Buffers", silent = true } },
			{ "g", cmd("Telescope repo list"), { desc = "Git Repos", silent = true } },
			{ "k", ":lua require('telescope.builtin').keymaps()<CR>", { desc = "Open Neovim Keymaps", silent = true } },
			{ "h", cmd("Telescope help_tags"), { desc = "Help", silent = true } },
			{
				"p",
				cmd("lua require('telescope').extensions.project.project { display_type = 'minimal' }"),
				{ desc = "Projects", silent = true },
			},
			{
				"w",
				cmd("lua require('telescope').extensions.menufacture.live_grep()"),
				{ desc = "Workspace", silent = true },
			},
			{ "r", cmd("Telescope oldfiles"), { desc = "Recents", silent = true } },
			{
				"b",
				cmd("lua require('telescope.builtin').current_buffer_fuzzy_find()"),
				{ desc = "Buffer", silent = true },
			},
			{ "a", cmd("Telescope aerial"), { desc = "Aerial Code Outline", silent = true } },
			{
				"z",
				cmd("lua require('telescope.builtin').colorscheme({ enable_preview = true })"),
				{ desc = "Colorscheme", silent = true },
			},
			{ "U", cmd("Telescope undo"), { desc = "Undo", silent = true } },
			{ "q", nil, { desc = "Quit", exit = true, nowait = true } },
		},
	}
end
return {
	{
		"anuvyklack/hydra.nvim",
		event = "VeryLazy",
		config = function(_, _)
			local Hydra = require("hydra")
			Hydra(gitsigns_menu())
			Hydra(quick_menu())
			-- Hydra(dap_menu())
			-- Hydra(telekasten_hydra())
			Hydra(telescope_hydra())
		end,
	},
}
