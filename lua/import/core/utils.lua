local M = {}

M.get_filetype = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  return filetype
end

M.remove_entries = function(source_table, table_to_remove)
  local lookup = {}
  for _, value in ipairs(table_to_remove) do
    lookup[value] = true
  end
  local new_table = {}
  for _, value in ipairs(source_table) do
    if not lookup[value] then
      table.insert(new_table, value)
    end
  end
  return new_table
end

M.sort_by_frequency = function(inputTable)
  local frequencies = {}

  for _, value in ipairs(inputTable) do
    frequencies[value] = (frequencies[value] or 0) + 1
  end

  local unique = {}
  for element, frequency in pairs(frequencies) do
    table.insert(unique, { element = element, frequency = frequency })
  end

  table.sort(unique, function(a, b)
    return a.frequency > b.frequency
  end)

  local sorted = {}
  for _, pair in ipairs(unique) do
    table.insert(sorted, pair.element)
  end

  return sorted
end

M.concat_tables = function(t1, t2)
  local result = {}
  -- Copy first table
  for i = 1, #t1 do
    result[i] = t1[i]
  end
  -- Append second table
  for i = 1, #t2 do
    result[#result + 1] = t2[i]
  end
  return result
end

M.get_current_buffer_imports = function(config)
  if config == nil or config.regex == nil then
    return {}
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, "\n")

  -- Build ripgrep command as array of arguments
  local constants = require("import.core.constants")
  local args = {}

  -- Add ripgrep flags
  for _, flag in ipairs(constants.rg_flags) do
    table.insert(args, flag)
  end

  -- Add regex pattern
  table.insert(args, config.regex)

  -- Execute ripgrep using vim.system() with stdin
  local result = vim.system({ "rg", unpack(args) }, { text = true, stdin = content }):wait()

  -- Handle errors
  if result.code ~= 0 and result.code ~= 1 then
    -- Exit code 1 means no matches found (normal), anything else is an error
    return {}
  end

  -- Split stdout into lines
  if result.stdout and result.stdout ~= "" then
    local import_lines = vim.split(result.stdout, "\n", { plain = true, trimempty = true })
    return import_lines
  end

  return {}
end

return M
