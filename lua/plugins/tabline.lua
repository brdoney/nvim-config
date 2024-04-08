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
    },
    init = function()
      -- Lazy will set it up for us
      vim.g.barbar_auto_setup = false

      local function barbarmap(key, command, desc)
        local opts = { silent = true, noremap = true, desc = desc }
        vim.keymap.set("n", key, command, opts)
      end

      -- Barbar operations
      barbarmap("<leader>p", ":BufferPick<CR>", "Pick buffer")
      barbarmap("<leader>[", ":BufferPrevious<CR>", "Previous buffer")
      barbarmap("<leader>]", ":BufferNext<CR>", "Next buffer")
      barbarmap("<leader>{", ":BufferMovePrevious<CR>", "Move buffer left")
      barbarmap("<leader>}", ":BufferMoveNext<CR>", "Move buffer right")
      barbarmap("<leader>\\", ":BufferClose<CR>", "Close buffer")

      -- Tabpage operations
      barbarmap("<leader>tt", ":tabnew<CR>", "Open new tab")
      barbarmap("<leader>t[", ":tabprevious<CR>", "Previous tab")
      barbarmap("<leader>t]", ":tabnext<CR>", "Next tab")
      barbarmap("<leader>|", function()
        -- ":tabclose<CR>"
        vim.cmd.tabclose()
        -- Reload nvim tree for git updates
        require('nvim-tree.api').tree.reload()
        -- Refresh gitgutter for updates
        vim.cmd("GitGutterAll")
      end, "Close tab")
    end,
    opts = {
      auto_hide = 1,
      focus_on_close = "previous",
      insert_at_end = true,
      icons = {
        button = "",
        modified = {
          button = ""
        }
      }
    },
  },
}
