# 🚢 import.nvim

> [!WARNING]
> This plugin was renamed from `telescope-import.nvim` to `import.nvim` as it now supports multiple pickers.
> Old GitHub URLs will still redirect, but please update your plugin spec to use:
>
> ```lua
> { "piersolenski/import.nvim" }
> ```
>
> The previous setup method of registering the plugin as a Telescope extension is still supported, but the new method is recommended for access to latest features.

Often we find ourselves importing the same modules over and over again in an existing project. `import.nvim` helps you add import statements faster by searching your project for existing imports and presenting them in a picker. Instead of typing out imports from scratch or yanking them from other files, you get a searchable list of all imports already used in your project, sorted by frequency of use.

Think of it as "import autocomplete" based on your project's actual usage patterns. It's particularly useful when:

- Your LSP doesn't support auto-imports
- Multiple LSP symbols share the same name
- You prefer typing your imports upfront rather than importing missing ones
- You're working in a large codebase with consistent import patterns

<https://github.com/user-attachments/assets/b5c2d7bd-ced7-44d1-abd2-d96de37a05e8>

## ✨ Features

- **Multiple picker support**: Works with Telescope, Snacks, or fzf-lua
- **Frequency-based sorting**: Most used imports appear first for faster selection
- **Smart insertion**: Automatically places imports in the correct location for frameworks like Vue and Svelte (inside `<script>` tags)
- **Multi-select**: Select multiple imports using <kbd>tab</kbd>
- **Duplicate prevention**: Automatically excludes imports that are already present in the current file
- **Extensible**: Add support for new languages or customize existing ones

## 🤖 Supported languages

- Bash
- C/C++
- C#
- Dart
- Elixir
- F#
- Go
- Haskell
- Java
- JavaScript
- Julia
- Kotlin
- Lua
- MATLAB
- Nim
- OCaml
- PHP
- Python
- R
- Ruby
- Rust
- Scala
- Svelte
- Swift
- TypeScript
- Vue
- Zig
- Zsh

## 🔩 Installation

Install [ripgrep](https://github.com/BurntSushi/ripgrep).

```lua
-- Lazy
{
  'piersolenski/import.nvim',
  dependencies = {
    -- One of the following pickers is required:
    'nvim-telescope/telescope.nvim',
 -- 'folke/snacks.nvim',
 -- 'ibhagwan/fzf-lua',
  },
  opts = {
 picker = "telescope",
  },
  keys = {
    {
      "<leader>i",
      function()
        require("import").pick()
      end,
      desc = "Import",
    },
  },
}
```

## ⚙️ Configuration

`import.nvim` requires no configuration out of the box, but you can tweak it in the following ways:

```lua
{
  -- The picker to use
  picker = "telescope" | "snacks" | "fzf-lua",
  -- Imports can be added at a specified line whilst keeping the cursor in place
  insert_at_top = true,
  -- Optionally support additional languages or modify existing languages...
  custom_languages = {}
}
```

<details>

<summary>Adding custom languages</summary>

### Custom Languages

The `custom_languages` configuration allows you to add support for new languages or customize existing ones.

#### Required Fields by Use Case

**To add a new language:** All fields are required

- **`extensions`**: File extensions that ripgrep will search (use `rg --type-list` to see supported types)
- **`filetypes`**: Neovim filetypes where this configuration applies  
- **`regex`**: Regular expression pattern to match import statements in the language
- **`insert_at_line`** (optional): Line number where imports should be inserted (defaults to 1)

**To customize an existing language:** Only specify the fields you want to override

- **`filetypes`**: Must match the existing language's filetypes exactly
- Other fields are only needed if you want to change them

#### Examples

**Add support for a new language:**

```lua
custom_languages = {
  {
    extensions = { "elm" },
    filetypes = { "elm" },
    regex = [[^import\s+([\w.]+)(?:\s+as\s+\w+)?(?:\s+exposing\s+.+)?]],
  }
}
```

**Override just the insertion behavior for Vue.js:**

```lua
custom_languages = {
  {
    filetypes = { "vue" },
    insert_at_line = function() 
      -- Insert before closing <script> tag instead of after the opening tag
      return vim.fn.search("</script>", "n") + 1
    end,
  }
}
```

**Override multiple aspects of an existing language:**

```lua
custom_languages = {
  {
    filetypes = { "vue" },
    regex = [[^import\s+.*from\s+['\"](.+)['\"];?]], -- Custom regex
    insert_at_line = 2, -- Fixed line number
  }
}
```

Custom languages are merged with built-in language support, with your configurations taking precedence over defaults.

#### Contributing Languages

If you created a custom language configuration that works well, please consider contributing it to make it a default supported language! Here's how:

1. Fork the repository on GitHub
2. Create a feature branch named `feature/add-<language>-support` (e.g., `feature/add-elm-support`)
3. Add the regex pattern to `lua/import/language/regex.lua`
4. Add the language config to `lua/import/language/languages.lua`
5. Add comprehensive tests for different import formats to `tests/import/core/regex_spec.lua`
6. Run checks with `make check` to ensure everything works
7. Submit a pull request with your changes

Your contribution will help other users of the same language!

</details>

## 🚀 Usage

```
:Import
```

```lua
require("import").pick()
```

## 🤓 About the author

As well as a passionate Vim enthusiast, I am a Full Stack Developer and Technical Lead from London, UK.

Whether it's to discuss a project, talk shop or just say hi, I'd love to hear from you!

- [Website](https://www.piersolenski.com/)
- [CodePen](https://codepen.io/piers)
- [LinkedIn](https://www.linkedin.com/in/piersolenski/)

<a href='https://ko-fi.com/piersolenski' target='_blank'>
  <img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee at ko-fi.com' />
</a>
