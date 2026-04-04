---@module 'luassert'

local constants = require("import.core.constants")
local regex = require("import.language.regex")

describe("Regex with rg", function()
  local test_file = "test_imports.js"

  after_each(function()
    os.remove(test_file)
  end)

  local function run_rg(language, lines)
    local file = io.open(test_file, "w")
    if file then
      for _, line in ipairs(lines) do
        file:write(line .. "\n")
      end
      file:close()
    end

    local flags = table.concat(constants.rg_flags, " ")
    local find_command =
      string.format("rg %s %s %s", flags, vim.fn.shellescape(regex[language]), test_file)
    return vim.fn.systemlist(find_command)
  end

  local function test_language_imports(language, expected_lines)
    local result = run_rg(language, expected_lines)
    assert.are.same(expected_lines, result)
  end

  local language_tests = {
    {
      name = "c",
      description = "matches various include statements",
      lines = {
        '#include "package.h"',
        "#include <package.h>",
      },
    },
    {
      name = "go",
      description = "matches various import statements",
      lines = {
        '\t"package"',
        '\talias "package"',
        'import "package"',
        'import . "package"',
        'import alias "package"',
        'import mypackage "github.com/user/repo"',
      },
    },
    {
      name = "java",
      description = "matches various import statements",
      lines = {
        "import com.package.Class;",
        "import static com.package.Class.*;",
      },
    },
    {
      name = "javascript",
      description = "matches various import statements",
      lines = {
        "import package from 'package';",
        'import { method } from "package";',
        "import { method as myMethod } from 'package';",
        "import * as package from 'package';",
      },
    },
    {
      name = "lua",
      description = "matches various require statements",
      lines = {
        "local package = require('package')",
        'local package = require("package")',
      },
    },
    {
      name = "php",
      description = "matches various use statements",
      lines = {
        "use My\\Full\\Classname;",
        "use My\\Full\\Classname",
      },
    },
    {
      name = "python",
      description = "matches various import statements",
      lines = {
        "import package",
        "from package import method",
        "from package import method1, method2",
        "from package import method as myMethod",
      },
    },
    {
      name = "ruby",
      description = "matches various import statements",
      lines = {
        "require 'json'",
        "require 'net/http'",
        "require_relative '../models/user'",
        "require json",
      },
    },
    {
      name = "shell",
      description = "matches various source statements",
      lines = {
        "source file.sh",
      },
    },
    {
      name = "swift",
      description = "matches various import statements",
      lines = {
        "import Foundation",
      },
    },
    {
      name = "rust",
      description = "matches various use statements",
      lines = {
        "use std::collections::HashMap;",
        "use std::io::{self, Read, Write};",
        "use serde::{Deserialize, Serialize};",
        "use tokio::time::{sleep, Duration};",
      },
    },
    {
      name = "csharp",
      description = "matches various using statements",
      lines = {
        "using System;",
        "using System.Collections.Generic;",
        "using Microsoft.AspNetCore.Mvc;",
        "using Newtonsoft.Json;",
      },
    },
    {
      name = "d",
      description = "matches various import statements",
      lines = {
        "import std.stdio;",
        "import std.algorithm;",
        "import std.string;",
        "public import libweb.utils.conv;",
      },
    },
    {
      name = "kotlin",
      description = "matches various import statements",
      lines = {
        "import android.os.Bundle",
        "import androidx.appcompat.app.AppCompatActivity",
        "import kotlinx.coroutines.*",
        "import com.squareup.moshi.Moshi",
      },
    },
    {
      name = "haskell",
      description = "matches various import statements",
      lines = {
        "import Control.Monad",
        "import Data.Text (Text)",
        "import qualified Data.Text as T",
        "import qualified Data.Map as Map",
      },
    },
    {
      name = "elixir",
      description = "matches various import/alias/require/use statements",
      lines = {
        "import Ecto.Query",
        "alias MyApp.{User, Post, Comment}",
        "require Logger",
        "use GenServer",
      },
    },
    {
      name = "dart",
      description = "matches various import statements",
      lines = {
        "import 'package:flutter/material.dart';",
        "import 'dart:convert';",
        "import 'package:http/http.dart' as http;",
      },
    },
    {
      name = "fsharp",
      description = "matches various open statements",
      lines = {
        "open System",
        "open System.IO",
        '#load "script.fsx"',
      },
    },
    {
      name = "julia",
      description = "matches various import and using statements",
      lines = {
        "import JSON",
        "using LinearAlgebra",
        "import Base: +, -",
      },
    },
    {
      name = "matlab",
      description = "matches various addpath and import statements",
      lines = {
        "addpath /path/to/folder",
        "import matlab.unittest.TestCase",
      },
    },
    {
      name = "nim",
      description = "matches various import statements",
      lines = {
        "import strutils",
        "import os, times",
        "import json except JsonNode",
      },
    },
    {
      name = "ocaml",
      description = "matches various require and open statements",
      lines = {
        '#require "lwt";;',
        "open List",
        "open Printf",
      },
    },
    {
      name = "scala",
      description = "matches various import statements",
      lines = {
        "import scala.collection.mutable",
        "import java.util.{Date, HashMap}",
        "import akka.actor._",
      },
    },
    {
      name = "zig",
      description = "matches various import statements",
      lines = {
        'const std = @import("std");',
        'const print = @import("std").debug.print;',
        'const testing = @import("std").testing;',
      },
    },
  }

  for _, test_data in ipairs(language_tests) do
    describe(test_data.name, function()
      it(test_data.description, function()
        test_language_imports(test_data.name, test_data.lines)
      end)
    end)
  end

  describe("negative cases", function()
    it("javascript rejects non-import lines", function()
      local lines = {
        "const x = require('package')",
        "// import commented from 'out'",
        "console.log('import fake from test')",
        "export default function() {}",
      }
      local result = run_rg("javascript", lines)
      assert.same({}, result)
    end)

    it("python rejects non-import lines", function()
      local lines = {
        "# import commented",
        "x = importlib.import_module('foo')",
        "print('from x import y')",
      }
      local result = run_rg("python", lines)
      assert.same({}, result)
    end)

    it("lua rejects non-require lines", function()
      local lines = {
        "-- local x = require('commented')",
        "local x = 42",
        "require('global_require')",
      }
      local result = run_rg("lua", lines)
      assert.same({}, result)
    end)

    it("go rejects non-import lines", function()
      local lines = {
        "// import commented",
        "var x = 42",
        "func main() {}",
      }
      local result = run_rg("go", lines)
      assert.same({}, result)
    end)

    it("rust rejects non-use lines", function()
      local lines = {
        "// use commented;",
        "let x = 42;",
        "fn main() {}",
      }
      local result = run_rg("rust", lines)
      assert.same({}, result)
    end)
  end)
end)
