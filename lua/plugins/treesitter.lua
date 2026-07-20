local installed = {
  -- Vim
  "vim",
  "vimdoc",
  "lua",
  -- C/C++
  "c",
  "cpp",
  "make",
  -- Rust
  "rust",
  -- Go
  "go",
  -- Git
  "diff",
  "gitcommit",
  "gitignore",
  -- Shell
  "bash",
  -- Web-dev
  "html",
  "css",
  "javascript",
  "typescript",
  "tsx",
  "json",
  "svelte",
  "vue",
  -- Java
  "java",
  -- C# (also used for Razor C# injections)
  "c_sharp",
  -- Markdown
  "markdown",
  "markdown_inline",
  -- Python
  "python",
  -- Regex (injected into C# `new Regex(...)` / `[GeneratedRegex(...)]`)
  "regex",
}

local ignore_install = {
  -- Use rainbow CSV instead
  "csv", "tsv",
}

-- Local parser forks we prefer over the registry grammar when present on disk.
-- Populated by `prioritize_local`; loaded in the plugin config (see the loop in
-- config()) from `~/Documents/tree-sitter/{dir}/{language}.so`, with queries
-- resolved from the `queries/{language}` symlink.
local local_parsers = {}


-- Settings for tree-sitter
vim.opt.foldmethod = "expr"
-- Native treesitter foldexpr. The old `nvim_treesitter#foldexpr()` is a
-- legacy (master-branch) vimscript function that does NOT exist on the
-- `main` branch — it errored (E117) on every fold evaluation.
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- Start at 99 so everything isn't folded up at the start
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 10
-- Remove folds since treesitter will regenerate them each time anyway
-- (and sessions will preserve manual folding from past otherwise)
vim.opt.sessionoptions = "buffers,curdir,help,tabpages,winsize,terminal"


--- Whether a local copy of the given parser exists on disk
---@param dir_name string name of the parser's folder (e.g. "tree-sitter-sql")
---@return boolean `true` if the parser exists on disk, `false` otherwise
local function has_local_parser(dir_name)
  return vim.uv.fs_stat(vim.fn.expand("~/Documents/tree-sitter/" .. dir_name)) ~= nil
end

--- If a copy of the parser exists locally in
--- `~/Documents/tree-sitter/{dir_name}`, prefer it: blacklist the registry
--- grammar from install and record the local parser so config() can load it
--- from its build dir. Otherwise, fall back to installing the registry parser.
---@param dir_name string name of the parser's folder (e.g. "tree-sitter-sql")
---@param language_name string the name of the language (e.g. "sql")
local function prioritize_local(dir_name, language_name)
  if has_local_parser(dir_name) then
    table.insert(ignore_install, language_name)
    table.insert(local_parsers, { dir = dir_name, lang = language_name })
  else
    table.insert(installed, language_name)
  end
end


-- If we have our T-SQL fork locally, we'll use that. Otherwise, fall back to the
-- base SQL fork. The registry grammar can't parse SQL-Server square-bracket
-- identifiers (`[Column]`, `[schema].table`) or `TOP`, which wrecks highlighting
-- of the SQL we inject into C# (see after/queries/c_sharp/injections.scm).
prioritize_local("tree-sitter-sql", "sql")
-- The regular razor parser isn't nearly robust enough on edge cases to stand up
-- to a real Razor codebase. Note: `.cshtml` is also filetype `razor`, so this
-- (Blazor-focused) grammar parses it too; MVC-only constructs may show minor
-- parse noise — that dialect is out of scope.
prioritize_local("tree-sitter-razor-claude", "razor")


-- Load our local parser forks (see `prioritize_local`) straight from their
-- build dirs rather than the registry, which is why they're blacklisted in
-- `ignore_install` — that keeps the registry grammar from clobbering them.
-- Because the language name matches the filetype (`razor`, `sql`), no
-- explicit `language.register` is needed, and queries resolve from the
-- `queries/{lang}` symlink -> <grammar>/queries (so the fork's queries
-- apply, not the registry's). Rebuild a parser with
-- `tree-sitter build -o {lang}.so`.
for _, p in ipairs(local_parsers) do
  pcall(vim.treesitter.language.add, p.lang, {
    path = vim.fn.expand('~/Documents/tree-sitter/' .. p.dir .. '/' .. p.lang .. '.so'),
  })
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    -- Enable treesitter highlighting and disable regex syntax
    pcall(vim.treesitter.start)
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {},
    config = function()
      -- There's a weird `module` missing issue, so just ignoring this for now
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/5297
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter').setup({
        auto_install = true,
        sync_install = false,
        ignore_install = ignore_install,
      })

      local alreadyInstalled = require('nvim-treesitter.config').get_installed()
      local parsersToInstall = vim.iter(installed)
          :filter(function(parser)
            return not vim.tbl_contains(alreadyInstalled, parser)
          end)
          :totable()
      require('nvim-treesitter').install(parsersToInstall)
    end
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      -- We don't need the autocmd since we're using the Comment.nvim integration
      enable_autocmd = false,
      languages      = {
        -- Use line comments, ignoring vim's default of block comments everywhere
        c = { __default = '// %s', __multiline = '/* %s */' },

        -- Razor (our local `razor` parser fork). Keys are TREESITTER node types,
        -- and the lookup walks up from the cursor node (first match wins, else
        -- __default). Context-aware comments:
        --   * markup            -> Razor comment `@* *@`. This is the SAFE
        --       default: an HTML `<!-- -->` does NOT disable embedded
        --       `@`-expressions in Razor, so commented-out markup would still
        --       execute its C#. (Swap to '<!-- %s -->' for HTML-style if preferred.)
        --   * @code / @( ) / conditions -> C# `//`. These are NATIVE c_sharp
        --       nodes composed into the razor tree (not an injected layer), so
        --       they report language `razor` and need these overrides;
        --       code_directive/member_block reliably enclose @code members.
        -- Injected layers resolve via the plugin's built-in configs (no entry
        -- needed here): @{ } / control bodies / implicit expressions -> `c_sharp`
        -- (`//`), <style> -> `css` (`/* */`), <script> -> `javascript` (`//`).
        razor = {
          __default = '@* %s *@',
          __multiline = '@* %s *@',
          code_directive = { __default = '// %s', __multiline = '/* %s */' },
          member_block = { __default = '// %s', __multiline = '/* %s */' },
          explicit_expression = { __default = '// %s', __multiline = '/* %s */' },
          condition = { __default = '// %s', __multiline = '/* %s */' },
        },
      }
    },
    init = function()
      -- Skip backwards compatability to speed up loading
      -- I don't know if it's actually necessary anymore?
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
