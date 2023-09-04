local M = {}

function M.get()
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local first_line = string.sub(lines[1], start_col)
  local last_line = string.sub(lines[#lines], 1, end_col)
  lines[1], lines[#lines] = first_line, last_line
  return table.concat(lines, "\n")
end

function M.replace(replacement)
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
  vim.api.nvim_exec(
    [[
        normal! gv"xy
    ]],
    false
  )
  local replacement_lines = vim.split(replacement, "\n", true)
  vim.api.nvim_buf_set_text(0, start_row - 1, start_col - 1, end_row - 1, tonumber(end_col),
    replacement_lines)
end

return M
