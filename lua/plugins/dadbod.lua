return {
  {
  -- Database explorer
    'tpope/vim-dadbod',
    ft = { "sql", "mysql", "plsql" },
    init = function()
      vim.g.db_ui_save_location = vim.fn.stdpath "config" .. require("plenary.path").path.sep .. "db_ui"
    end
  },
  {
    -- UI for dadbod, similar to the sqlite VSCode extension
    'kristijanhusak/vim-dadbod-ui',
    dependencies = 'tpope/vim-dadbod',
    ft = { "sql", "mysql", "plsql" }
  },
  {
    -- cmp completion support for SQL tables, columns, etc.
    'kristijanhusak/vim-dadbod-completion',
    dependencies = 'tpope/vim-dadbod',
    ft = { "sql", "mysql", "plsql" },
    config = function()
      local function db_completion()
        require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "sql",
          "mysql",
          "plsql",
        },
        callback = function()
          vim.schedule(db_completion)
        end,
      })
    end,
  }
}
