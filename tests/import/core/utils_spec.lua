---@module 'luassert'

local utils = require("import.core.utils")

describe("Utils", function()
  describe("get_current_buffer_imports", function()
    it("extracts JavaScript imports from buffer", function()
      -- Create a test buffer with some JavaScript imports
      local bufnr = vim.api.nvim_create_buf(false, true)
      local lines = {
        "import React from 'react'",
        "import { useState } from 'react'",
        "import axios from 'axios'",
        "console.log('not an import')",
        "import './styles.css'",
      }
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

      -- Switch to the test buffer
      vim.api.nvim_set_current_buf(bufnr)

      local config = {
        regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
      }

      local imports = utils.get_current_buffer_imports(config)

      -- Should extract all 4 import statements
      assert.equals(4, #imports)
      assert.truthy(vim.tbl_contains(imports, "import React from 'react'"))
      assert.truthy(vim.tbl_contains(imports, "import { useState } from 'react'"))
      assert.truthy(vim.tbl_contains(imports, "import axios from 'axios'"))
      assert.truthy(vim.tbl_contains(imports, "import './styles.css'"))

      -- Clean up
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)

    it("returns empty table for nil config", function()
      local imports = utils.get_current_buffer_imports(nil)
      assert.same({}, imports)
    end)

    it("returns empty table for config without regex", function()
      local imports = utils.get_current_buffer_imports({})
      assert.same({}, imports)
    end)
  end)

  describe("sort_by_frequency", function()
    it("returns unique elements ordered by descending count", function()
      local input = { "a", "b", "a", "c", "b", "a" }
      local result = utils.sort_by_frequency(input)
      assert.equals(3, #result)
      assert.equals("a", result[1])
      assert.equals("b", result[2])
      assert.equals("c", result[3])
    end)

    it("preserves all elements when all are unique", function()
      local input = { "x", "y", "z" }
      local result = utils.sort_by_frequency(input)
      assert.equals(3, #result)
      assert.truthy(vim.tbl_contains(result, "x"))
      assert.truthy(vim.tbl_contains(result, "y"))
      assert.truthy(vim.tbl_contains(result, "z"))
    end)

    it("returns empty table for empty input", function()
      assert.same({}, utils.sort_by_frequency({}))
    end)
  end)

  describe("remove_entries", function()
    it("removes matching entries", function()
      local result = utils.remove_entries({ "a", "b", "c", "d" }, { "b", "d" })
      assert.same({ "a", "c" }, result)
    end)

    it("returns original when no overlap", function()
      local result = utils.remove_entries({ "a", "b" }, { "x", "y" })
      assert.same({ "a", "b" }, result)
    end)

    it("returns original when removal table is empty", function()
      local result = utils.remove_entries({ "a", "b" }, {})
      assert.same({ "a", "b" }, result)
    end)
  end)

  describe("concat_tables", function()
    it("concatenates two tables", function()
      local result = utils.concat_tables({ "a", "b" }, { "c", "d" })
      assert.same({ "a", "b", "c", "d" }, result)
    end)

    it("handles empty first table", function()
      local result = utils.concat_tables({}, { "a", "b" })
      assert.same({ "a", "b" }, result)
    end)

    it("handles empty second table", function()
      local result = utils.concat_tables({ "a", "b" }, {})
      assert.same({ "a", "b" }, result)
    end)
  end)
end)
