local constants = require("import.core.constants")
local utils = require("import.core.utils")

-- Returns a string that rg uses to filter filetypes (rg -t)
local function create_file_types_flag(strings)
  local result = ""
  for i, ext in ipairs(strings) do
    result = result .. "-t " .. ext
    if i < #strings then
      result = result .. " "
    end
  end
  return result
end

local function find_imports(config, file_path)
  local types = create_file_types_flag(config.extensions)
  local flags = table.concat(constants.rg_flags, " ")
  local find_command = table.concat({
    "rg",
    types,
    flags,
    vim.fn.shellescape(config.regex),
  }, " ")

  if file_path then
    find_command = find_command .. " " .. vim.fn.shellescape(file_path)
  end

  return vim.fn.systemlist(find_command)
end

local function get_project_imports(config)
  if config == nil then
    return nil
  end

  local current_file_path = vim.api.nvim_buf_get_name(0)

  local imports = find_imports(config)
  local local_results = find_imports(config, current_file_path)
  local current_buffer_imports = utils.get_current_buffer_imports(config)

  imports = utils.sort_by_frequency(imports)
  imports = utils.remove_entries(imports, local_results)
  imports = utils.remove_entries(imports, current_buffer_imports)

  return imports
end

return get_project_imports
