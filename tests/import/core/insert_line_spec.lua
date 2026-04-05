---@module 'luassert'

local insert_line = require("import.core.insert_line")

describe("insert_line", function()
  local bufnr

  before_each(function()
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {
      "line 1",
      "line 2",
      "line 3",
    })
  end)

  after_each(function()
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end)

  it("inserts at specified line number", function()
    insert_line("new line", 1)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    assert.equals("new line", lines[1])
    assert.equals(4, #lines)
  end)

  it("inserts at cursor position when no line number given", function()
    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    insert_line("new line")
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    assert.equals(4, #lines)
    assert.truthy(vim.tbl_contains(lines, "new line"))
  end)

  it("restores cursor position after insertion", function()
    vim.api.nvim_win_set_cursor(0, { 3, 0 })
    insert_line("new line", 1)
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- Original line 3 is now line 4 after insertion above it
    assert.equals(4, cursor[1])
  end)

  it("errors on non-number line_number", function()
    assert.has_error(function()
      insert_line("new line", "bad")
    end, "Expected insert_at_line to return a number, but got string")
  end)

  it("errors when line_number is out of range", function()
    assert.has_error(function()
      insert_line("new line", 99)
    end, "Line number out of range!")
  end)
end)
