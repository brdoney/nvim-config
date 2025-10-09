return {
  {
    "kndndrj/nvim-dbee",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require("dbee").install()
    end,
    config = function()
      require("dbee").setup({
        extra_helpers = {
          sqlserver = {
            ["List"] = "SELECT TOP 200 * FROM [{{ .Schema}}].[{{ .Table }}]"
          },
        },
        drawer = {
          mappings = {
            -- manually refresh drawer
            { key = "r",         mode = "n", action = "refresh" },
            -- actions perform different stuff depending on the node:
            -- action_1 opens a note or executes a helper
            { key = "<CR>",      mode = "n", action = "toggle_or_action_1" },
            { key = "<S-CR>",    mode = "n", action = "action_1" },
            -- action_2 renames a note or sets the connection as active manually
            { key = "cw",        mode = "n", action = "action_2" },
            -- action_3 deletes a note or connection (removes connection from the file if you configured it like so)
            { key = "dd",        mode = "n", action = "action_3" },
            -- these are self-explanatory:
            -- { key = "c", mode = "n", action = "collapse" },
            -- { key = "e", mode = "n", action = "expand" },
            { key = "o",         mode = "n", action = "toggle" },
            -- mappings for menu popups:
            { key = "<CR>",      mode = "n", action = "menu_confirm" },
            { key = "y",         mode = "n", action = "menu_yank" },
            { key = "<Esc>",     mode = "n", action = "menu_close" },
            { key = "q",         mode = "n", action = "menu_close" },
            -- Toggle sidebar
            { key = "<leader>e", mode = "n", action = require("dbee").sidebar_toggle },
          },
          candies = {
            node_expanded = {
              icon = "▾",
              icon_highlight = "NonText",
              text_highlight = "",
            },
            node_closed = {
              icon = "▸",
              icon_highlight = "NonText",
              text_highlight = "",
            },
          },
        },
        result = {
          -- mappings for the buffer
          mappings = {
            -- next/previous page
            { key = "L",         mode = "",  action = "page_next" },
            { key = "H",         mode = "",  action = "page_prev" },
            { key = "E",         mode = "",  action = "page_last" },
            { key = "F",         mode = "",  action = "page_first" },
            -- yank rows as csv/json
            { key = "yaj",       mode = "n", action = "yank_current_json" },
            { key = "yaj",       mode = "v", action = "yank_selection_json" },
            { key = "yaJ",       mode = "",  action = "yank_all_json" },
            { key = "yac",       mode = "n", action = "yank_current_csv" },
            { key = "yac",       mode = "v", action = "yank_selection_csv" },
            { key = "yaC",       mode = "",  action = "yank_all_csv" },
            -- cancel current call execution
            { key = "<C-c>",     mode = "",  action = "cancel_call" },
            -- Toggle sidebar
            { key = "<leader>e", mode = "n", action = require("dbee").sidebar_toggle },
          },
        },
        editor = {
          -- mappings for the buffer
          mappings = {
            -- run what's currently selected on the active connection
            { key = "BB",        mode = "v", action = "run_selection" },
            -- run the whole file on the active connection
            { key = "BB",        mode = "n", action = "run_file" },
            -- run what's under the cursor to the next newline
            { key = "<CR>",      mode = "n", action = "run_under_cursor" },
            -- Toggle sidebar
            { key = "<leader>e", mode = "n", action = require("dbee").sidebar_toggle },
          },
        },

        call_log = {
          -- mappings for the buffer
          mappings = {
            -- show the result of the currently selected call record
            { key = "<CR>",      mode = "",  action = "show_result" },
            -- cancel the currently selected call (if its still executing)
            { key = "<C-c>",     mode = "",  action = "cancel_call" },
            -- Toggle sidebar
            { key = "<leader>e", mode = "n", action = require("dbee").sidebar_toggle },
          },
        },
        window_layout = require("dbee.layouts").Default:new({
          -- Close dbee and switch to the buffer on ctrl-p
          on_switch = "close",
          -- Make the call log super small by default
          call_log_height = 1
        })
      })
      -- })
    end,
    keys = {
      -- { "<leader>B", function() require("dbee").toggle() end, desc = "Toggle DBee" },
      {
        "<leader>D",
        function()
          if vim.g.dbui_tab == nil then
            vim.cmd("tabnew")
            vim.g.dbui_tab = vim.api.nvim_get_current_tabpage()
            require("dbee").open()
          else
            vim.api.nvim_set_current_tabpage(vim.g.dbui_tab)
          end
        end,
        desc = "Open Dbee"
      }
    }
  },
  -- {
  --   -- cmp completion support for SQL tables, columns, etc.
  --   'kristijanhusak/vim-dadbod-completion',
  --   dependencies = { 'tpope/vim-dadbod' },
  --   ft = { "sql", "mysql", "plsql" },
  --   config = function()
  --     -- local function db_completion()
  --     --   require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
  --     -- end
  --     --
  --     -- vim.api.nvim_create_autocmd("FileType", {
  --     --   pattern = {
  --     --     "sql",
  --     --     "mysql",
  --     --     "plsql",
  --     --   },
  --     --   callback = function()
  --     --     vim.schedule(db_completion)
  --     --   end,
  --     -- })
  --   end,
  -- },
  -- {
  --   -- UI for dadbod, similar to the sqlite VSCode extension
  --   'kristijanhusak/vim-dadbod-ui',
  --   dependencies = {
  --     'tpope/vim-dadbod',
  --     'kristijanhusak/vim-dadbod-completion',
  --   },
  --   ft = { "sql", "mysql", "plsql" },
  --   cmd = {
  --     'DBUI',
  --     'DBUIToggle',
  --     'DBUIAddConnection',
  --     'DBUIFindBuffer',
  --   },
  --   keys = {
  --     {
  --       "<leader>D",
  --       function()
  --         vim.cmd("tab :DBUI")
  --         vim.g.dbui_tab = vim.api.nvim_tabpage_get_number(0)
  --       end,
  --       desc = "Open DBUI"
  --     }
  --   },
  --   init = function()
  --     vim.g.db_ui_show_database_icon = 1
  --     vim.g.db_ui_use_nerd_fonts     = 1
  --     vim.g.db_ui_use_nvim_notify    = 1
  --
  --     vim.g.db_ui_table_helpers      = {
  --       sqlite = {
  --         Schema = ".schema {optional_schema}{table}",
  --       }
  --     }
  --   end
  -- }
}
