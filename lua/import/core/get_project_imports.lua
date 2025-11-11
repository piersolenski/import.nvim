local constants = require("import.core.constants")
local utils = require("import.core.utils")

local function find_imports(config, file_path)
  -- Build ripgrep command as array of arguments
  local args = {}

  -- Add file type flags
  for _, ext in ipairs(config.extensions) do
    table.insert(args, "-t")
    table.insert(args, ext)
  end

  -- Add ripgrep flags
  for _, flag in ipairs(constants.rg_flags) do
    table.insert(args, flag)
  end

  -- Add regex pattern (no quotes needed - passed as separate argument)
  table.insert(args, config.regex)

  -- Add optional file path
  if file_path then
    table.insert(args, file_path)
  end

  -- Execute ripgrep using vim.system()
  local result = vim.system({ "rg", unpack(args) }, { text = true }):wait()

  -- Handle errors
  if result.code ~= 0 and result.code ~= 1 then
    -- Exit code 1 means no matches found (normal), anything else is an error
    local error_msg = "ripgrep failed"
    if result.stderr and result.stderr ~= "" then
      error_msg = error_msg .. ": " .. result.stderr
    end
    vim.notify(error_msg, vim.log.levels.ERROR)
    return {}
  end

  -- Split stdout into lines (similar to systemlist behavior)
  if result.stdout and result.stdout ~= "" then
    local lines = vim.split(result.stdout, "\n", { plain = true, trimempty = true })
    return lines
  end

  return {}
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
  imports = utils.remove_duplicates(imports)
  imports = utils.remove_entries(imports, local_results)
  imports = utils.remove_entries(imports, current_buffer_imports)

  return imports
end

return get_project_imports
