return {
  {
    -- cmp completion support for SQL tables, columns, etc.
    'kristijanhusak/vim-dadbod-completion',
    dependencies = { 'tpope/vim-dadbod' },
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
  },
  {
    -- UI for dadbod, similar to the sqlite VSCode extension
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      'tpope/vim-dadbod',
      'kristijanhusak/vim-dadbod-completion',
    },
    ft = { "sql", "mysql", "plsql" },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    keys = {
      {
        "<leader>D",
        function()
          vim.cmd("tab :DBUI")
          vim.g.dbui_tab = vim.api.nvim_tabpage_get_number(0)
        end,
        desc = "Open DBUI"
      }
    },
    init = function()
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_use_nerd_fonts     = 1
      vim.g.db_ui_use_nvim_notify    = 1

      vim.g.db_ui_table_helpers      = {
        sqlite = {
          Schema = ".schema {optional_schema}{table}",
        }
      }
    end
  }
}
