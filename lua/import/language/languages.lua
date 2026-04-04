local regex = require("import.language.regex")

local languages = {
  {
    extensions = { "h", "c", "cpp" },
    filetypes = { "c", "cpp" },
    regex = regex.c,
  },
  {
    extensions = { "csharp" },
    filetypes = { "cs" },
    regex = regex.csharp,
  },
  {
    extensions = { "d" },
    filetypes = { "d" },
    regex = regex.d,
  },
  {
    extensions = { "dart" },
    filetypes = { "dart" },
    regex = regex.dart,
  },
  {
    extensions = { "elixir" },
    filetypes = { "elixir" },
    regex = regex.elixir,
  },
  {
    extensions = { "fsharp" },
    filetypes = { "fsharp" },
    regex = regex.fsharp,
  },
  {
    extensions = { "go" },
    filetypes = { "go" },
    regex = regex.go,
  },
  {
    extensions = { "haskell" },
    filetypes = { "haskell" },
    regex = regex.haskell,
  },
  {
    extensions = { "java" },
    filetypes = { "java" },
    regex = regex.java,
  },
  {
    extensions = { "js", "ts" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    regex = regex.javascript,
  },
  {
    extensions = { "vue" },
    filetypes = { "vue" },
    regex = regex.javascript,
    insert_at_line = function()
      return vim.fn.search("<script", "n") + 1
    end,
  },
  {
    extensions = { "js", "ts" },
    filetypes = { "svelte" },
    regex = regex.javascript,
    insert_at_line = function()
      return vim.fn.search("<script", "n") + 1
    end,
  },
  {
    extensions = { "julia" },
    filetypes = { "julia" },
    regex = regex.julia,
  },
  {
    extensions = { "kotlin" },
    filetypes = { "kotlin" },
    regex = regex.kotlin,
  },
  {
    extensions = { "lua" },
    filetypes = { "lua" },
    regex = regex.lua,
  },
  {
    extensions = { "matlab" },
    filetypes = { "matlab" },
    regex = regex.matlab,
  },
  {
    extensions = { "nim" },
    filetypes = { "nim" },
    regex = regex.nim,
  },
  {
    extensions = { "ocaml" },
    filetypes = { "ocaml" },
    regex = regex.ocaml,
  },
  {
    extensions = { "php" },
    filetypes = { "php" },
    regex = regex.php,
  },
  {
    extensions = { "py" },
    filetypes = { "python" },
    regex = regex.python,
  },
  {
    extensions = { "ruby" },
    filetypes = { "ruby" },
    regex = regex.ruby,
  },
  {
    extensions = { "rust" },
    filetypes = { "rust" },
    regex = regex.rust,
  },
  {
    extensions = { "scala" },
    filetypes = { "scala" },
    regex = regex.scala,
  },
  {
    extensions = { "sh", "zsh" },
    filetypes = { "sh", "zsh" },
    regex = regex.shell,
  },
  {
    extensions = { "swift" },
    filetypes = { "swift" },
    regex = regex.swift,
  },
  {
    extensions = { "zig" },
    filetypes = { "zig" },
    regex = regex.zig,
  },
}

return languages
