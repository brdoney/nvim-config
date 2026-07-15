return {
  -- Scope to make buffers window-specific
  {
    "tiagovla/scope.nvim",
    opts = {
      hooks = {
        -- Barbar integration: preserve order while switching tabs
        pre_tab_leave = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabLeavePre' })
        end,
        post_tab_enter = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabEnterPost' })
        end,
      },
    }
  },
  -- Tabline plugin
  {
    'romgrk/barbar.nvim',
    cond = not vim.g.started_by_firenvim,
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    },
    init = function()
      -- Lazy will set it up for us
      vim.g.barbar_auto_setup = false
    end,
    keys = {
      -- Buffer operations
      -- { "<leader>p", "<Cmd>BufferPick<CR>", desc = "Pick buffer" },
      { "<leader>[", "<Cmd>BufferPrevious<CR>", desc = "Previous buffer" },
      { "<leader>]", "<Cmd>BufferNext<CR>", desc = "Next buffer" },
      { "<leader>{", "<Cmd>BufferMovePrevious<CR>", desc = "Move buffer left" },
      { "<leader>}", "<Cmd>BufferMoveNext<CR>", desc = "Move buffer right" },
      { "<leader>\\", "<Cmd>BufferClose<CR>", desc = "Close buffer" },

      -- Tabpage operations
      { "<leader>tt", "<Cmd>tabnew<CR>", desc = "Open new tab" },
      { "<leader>t[", "<Cmd>tabprevious<CR>", desc = "Previous tab" },
      { "<leader>t]", "<Cmd>tabnext<CR>", desc = "Next tab" },
      {
        "<leader>|",
        function()
          if vim.g.dbui_tab ~= nil and vim.api.nvim_get_current_tabpage() == vim.g.dbui_tab then
            -- If we're currently in dbee, close it. Otherwise, it blocks tabclose
            require("dbee").close()
            vim.g.dbui_tab = nil
          end

          -- ":tabclose<CR>"
          vim.cmd.tabclose()
          -- Reload nvim tree for git updates
          require('nvim-tree.api').tree.reload()
          -- Refresh gitgutter for updates
          -- vim.cmd("GitGutterAll")
          require('gitsigns').refresh()
        end,
        desc = "Close tab",
      },
    },
    opts = {
      auto_hide = 1,
      focus_on_close = "previous",
      insert_at_end = true,
      icons = {
        button = "",
        modified = {
          button = ""
        }
      }
    },
  },
}
