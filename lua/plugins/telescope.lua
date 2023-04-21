return {
	{
		"lazytanuki/nvim-mapper",
		config = function()
			require("nvim-mapper").setup({})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-project.nvim",
			"olacin/telescope-cc.nvim",
			"ahmedkhalf/project.nvim",
			"cljoly/telescope-repo.nvim",
			"stevearc/aerial.nvim",
			"nvim-telescope/telescope-frecency.nvim",
			"debugloop/telescope-undo.nvim",
			"molecule-man/telescope-menufacture",
			"kkharji/sqlite.lua",
		},
		cmd = "Telescope",
        -- stylua: ignore
        keys = {
            { "<leader>tf", require("utils").find_files,                                                                 desc = "Find Files" },
            { "<leader>tc", "<cmd>Telescope frecency theme=dropdown previewer=false<cr>",                                desc = "Common (FRecent)" },
            { "<leader>to", "<cmd>Telescope buffers<cr>",                                                                desc = "Open Buffers" },
            { "<leader>tg", "<cmd>Telescope repo list<cr>",                                                              desc = "Git Repos" },
            { "<leader>th", "<cmd>Telescope help_tags<cr>",                                                              desc = "Help" },
            { "<leader>tp", function() require("telescope").extensions.project.project { display_type = "minimal" } end, desc = "Projects", },
            { "<leader>tw", function() require('telescope').extensions.menufacture.live_grep() end,                      desc = "Workspace" },
            { "<leader>tr", "<cmd>Telescope oldfiles<cr>",                                                               desc = "Recents" },
            { "<leader>tb", function() require("telescope.builtin").current_buffer_fuzzy_find() end,                     desc = "Buffer", },
            { "<leader>ta", "<cmd>Telescope aerial<cr>",                                                                 desc = "Aerial Code Outline" },
            { "<leader>zc", function() require("telescope.builtin").colorscheme({ enable_preview = true }) end,          desc = "Colorscheme", },
            { "<leader>U",  "<cmd>Telescope undo<cr>",                                                                   desc = "Undo" },
        },
		config = function(_, _)
			local telescope = require("telescope")
			local icons = require("config.icons")
			local actions = require("telescope.actions")
			local actions_layout = require("telescope.actions.layout")
			local mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["?"] = actions_layout.toggle_preview,
				},
			}

			local opts = {
				defaults = {
					prompt_prefix = icons.ui.Telescope .. " ",
					selection_caret = icons.ui.Forward .. " ",
					mappings = mappings,
					border = {},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
				},
				pickers = {
					find_files = {
						theme = "dropdown",
						previewer = false,
						hidden = true,
						find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
					},
					git_files = {
						theme = "dropdown",
						previewer = false,
					},
					buffers = {
						theme = "dropdown",
						previewer = false,
					},
				},
				extensions = {
					file_browser = {
						theme = "dropdown",
						previewer = false,
						hijack_netrw = true,
						mappings = mappings,
					},
					project = {
						hidden_files = false,
						theme = "dropdown",
					},
					menufacture = {
						mappings = {
							main_menu = { [{ "i", "n" }] = "<C-^>" },
						},
					},
					repo = {
						list = {
							search_dirs = {
								"~/projects/",
								"~/work/",
							},
						},
					},
					undo = {
						side_by_side = true,
						layout_strategy = "vertical",
						layout_config = {
							preview_height = 0.8,
						},
						mappings = {
							i = {
								-- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
								-- you want to replicate these defaults and use the following actions. This means
								-- installing as a dependency of telescope in it's `requirements` and loading this
								-- extension from there instead of having the separate plugin definition as outlined
								-- above.
								["<cr>"] = require("telescope-undo.actions").yank_additions,
								["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
								["<C-cr>"] = require("telescope-undo.actions").restore,
							},
						},
					},
					conventional_commits = {
						action = function(entry)
							-- entry = {
							--     display = "feat       A new feature",
							--     index = 7,
							--     ordinal = "feat",
							--     value = feat"
							-- }
							print(vim.inspect(entry))
						end,
					},
				},
			}
			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
			telescope.load_extension("mapper")

			telescope.load_extension("project")
			telescope.load_extension("projects")
			telescope.load_extension("aerial")
			telescope.load_extension("dap")
			telescope.load_extension("frecency")
			telescope.load_extension("menufacture")
			telescope.load_extension("conventional_commits")
		end,
	},
	{
		"stevearc/aerial.nvim",
		config = true,
	},
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				detection_methods = { "pattern", "lsp" },
				patterns = { ".git" },
				ignore_lsp = { "null-ls" },
			})
		end,
	},
}
