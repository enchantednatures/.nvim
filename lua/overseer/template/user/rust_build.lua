return {
  name = "cargo build with args",
  builder = function()
    -- Full path to current file (see :help expand())
    local args = vim.ui.input({
      prompt = "args?",
    })
    return {
      cmd = { "cargo build" },
      args = { args },
      components = { { "on_output_quickfix", open = true }, "default" },
    }
  end,
  condition = {
    filetype = { "rs" },
  },
}
