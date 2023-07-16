return {
	"nvim-tree/nvim-tree.lua",
	cmd = { "NvimTreeToggle" },
	keys = {
		{ "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
	},
	opts = {
		disable_netrw = false,
		hijack_netrw = true,
		respect_buf_cwd = true,
		view = {
			side = "right",
			width = 36,
			number = true,
			relativenumber = true,
		},
		filters = {
			custom = { ".git" },
		},
		sync_root_with_cwd = true,
		update_focused_file = {
			enable = true,
			update_root = true,
		},
		actions = {
			open_file = {
				quit_on_open = true,
			},
		},
		renderer = {
			highlight_git = true,
			root_folder_label = function(path)
				local project = vim.fn.fnamemodify(path, ":t")
				return string.upper(project)
			end,
			indent_markers = {
				enable = true,
			},
			icons = {
				glyphs = {
					default = "󰦨",
					symlink = "󰦨",
					bookmark = "󰦨",
					git = {
						unstaged = "",
						staged = "",
						unmerged = "",
						renamed = "",
						deleted = "",
						untracked = "",
						ignored = "",
					},
					folder = {
						default = "",
						open = "",
						symlink = "",
						arrow_closed = "", -- arrow when folder is closed
						arrow_open = "", -- arrow when folder is open
					},
				},
			},
			special_files = { "README.md" },
		},
	},
}
