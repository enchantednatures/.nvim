return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")
    dashboard.section.buttons.val = {
      dashboard.button("e", "󰺾 " .. " Explorer", ":NvimTreeToggle <CR>"),
      dashboard.button("h", "󱡅 " .. " Harpoon Marks",
        [[:lua require("harpoon.ui").toggle_quick_menu() <cr>]]),
      dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
      dashboard.button("d", " " .. " Dad Bod", ":DBUI<CR>"),
      dashboard.button("p", "" .. " Pull Requests", ":Octo pr list <CR>"),
      dashboard.button("i", "" .. " Github Issues", ":Octo issue list <CR>"),
      dashboard.button("t", " " .. " Worktrees", ":Telescope git_worktree git_worktrees <CR>"),
      dashboard.button("b", " " .. " Create Worktree", ":Telescope git_worktree create_git_worktree <CR>"),
      dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
      dashboard.button("w", " " .. " Find text", ":Telescope live_grep <CR>"),
      dashboard.button("T", " " .. " Todo", ":TodoTelescope <CR>"),
      dashboard.button("g", "󰊢" .. " Git", ":Neogit <CR>"),
      dashboard.button("c", "󰊢" .. " GitHub Actions", ":GhActions <CR>"),
      dashboard.button(".", " " .. " Config", ":e $MYVIMRC <CR>"),
      dashboard.button("l", "󰒲" .. " Lazy", ":Lazy<CR>"),
      dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.footer.opts.hl = "Constant"
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.opts.layout[1].val = 0

    local lazy = require("lazy")
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          lazy.show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = lazy.stats()
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
