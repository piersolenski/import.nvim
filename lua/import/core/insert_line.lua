local function insert_line(value, line_number)
  -- Capture the original line so that we can return to it if we insert the line
  -- elsewhere
  local original_position

  if line_number then
    if type(line_number) ~= "number" then
      error("Expected insert_at_line to return a number, but got " .. type(line_number))
    end

    original_position = vim.fn.getpos(".")

    local line_count = vim.api.nvim_buf_line_count(0)
    if line_number < 1 or line_number > line_count then
      error("Line number out of range!")
    end
    -- Set cursor to the desired line
    vim.api.nvim_win_set_cursor(0, { line_number, 0 })
  end

  -- Insert the line
  vim.api.nvim_put({ value }, "l", false, false)

  if line_number then
    -- Increment the line number to accommodate for extra line
    original_position[2] = original_position[2] + 1
    vim.fn.setpos(".", original_position)
  end
end

return insert_line
