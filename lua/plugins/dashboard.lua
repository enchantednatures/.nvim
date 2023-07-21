return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local dashboard = require("alpha.themes.dashboard")
        local icons = require("config.icons")
        
		dashboard.section.buttons.val = {
			dashboard.button("e", icons.dashboard.Explorer  .. " Explorer", ":NvimTreeToggle <CR>"),
			dashboard.button("f", icons.dashboard.File  .. " Find file", ":Telescope find_files <CR>"),
			dashboard.button("n", icons.dashboard.NewFile  .. " New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("r", icons.dashboard.RecentFiles  .. " Recent files", ":Telescope oldfiles <CR>"),
			dashboard.button("w", icons.dashboard.FindText  .. " Find text", ":Telescope live_grep <CR>"),
			dashboard.button("g", icons.dashboard.Git  .. " Git", ":LazyGit <CR>"),
			dashboard.button("c", icons.dashboard.Config  .. " Config", ":e $MYVIMRC <CR>"),
			dashboard.button("s", icons.dashboard.RestoreSession  .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
			dashboard.button("l", icons.dashboard.Lazy  .. " Lazy", ":Lazy<CR>"),
			dashboard.button("q", icons.dashboard.Quit  .. " Quit", ":qa<CR>"),
			dashboard.button("h", icons.dashboard.Marks  .. " Harpoon Marks", [[:lua require("harpoon.ui").toggle_quick_menu() <cr>]]),
		}
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end
		dashboard.section.footer.opts.hl = "Constant"
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.opts.layout[1].val = 0

		-- close Lazy and re-open when the dashboard is ready
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		require("alpha").setup(dashboard.opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

				-- local now = os.date "%d-%m-%Y %H:%M:%S"
				local version = "   v"
					.. vim.version().major
					.. "."
					.. vim.version().minor
					.. "."
					.. vim.version().patch
				local fortune = require("alpha.fortune")
				local quote = table.concat(fortune(), "\n")
				local plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
				local footer = "\t" .. version .. "\t" .. plugins .. "\n" .. quote
				dashboard.section.footer.val = footer
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
