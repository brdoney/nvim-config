return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {},
    config = function()
      -- There's a weird `module` missing issue, so just ignoring this for now
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/5297
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "vim", "vimdoc", "lua", "c", "cpp", "make", "rust", "go", "diff", "bash", "html", "css", "javascript", "typescript", "tsx", "json", "svelte", "vue", "java", "markdown", "markdown_inline", "python", "sql", "csv" },
        auto_install = true,
        sync_install = false,
        ignore_install = {},
        highlight = {
          enable = true,
        }
      })

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      -- Start at 99 so everything isn't folded up at the start
      vim.opt.foldlevel = 99
      vim.opt.foldnestmax = 10
      -- Remove folds since treesitter will regenerate them each time anyway
      -- (and sessions will preserve manual folding from past otherwise)
      vim.opt.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,terminal"
    end
  },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
    config = function()
      -- Skip backwards compatability to speed up loading
      vim.g.skip_ts_context_commentstring_module = true
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
