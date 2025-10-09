return {
  {
    'numToStr/Comment.nvim',
    dependencies = {
      { 'JoosepAlviste/nvim-ts-context-commentstring', dependencies = { "nvim-treesitter/nvim-treesitter" } }
    },
    -- Technically there are more keymappings, but I don't use them soooo....
    -- Doesn't actually trigger unless you do <C-v><C-_> in insert mode for some reason
    -- keys = "<C-_>",
    event = "VeryLazy",
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("Comment").setup({
        -- Integrate with nvim-ts-context-commentstring
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })

      -- vim.keymap.set('i', '<C-_>', function()
      --   require("Comment.api").toggle.linewise.current()
      --   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>A", true, false, true), "m", true)
      -- end, { desc = 'Toggle comment' })

      -- Modeled after insert mode command under NERDCommenter
      local comapi = require("Comment.api")
      local function imode_comment()
        local curr_line = vim.api.nvim_get_current_line()
        -- vim.pretty_print(curr_line)
        if curr_line ~= nil and curr_line:match('^%s*$') then
          -- Empty line (potentially including spaces)
          -- Make the comment (doesn't move cursor), then move to the end of it
          comapi.toggle.linewise.current()
          vim.cmd("startinsert!")
        else
          -- Not empty
          local pos = vim.api.nvim_win_get_cursor(0)
          local prevlen = curr_line:len()

          comapi.toggle.linewise.current()

          curr_line = vim.api.nvim_get_current_line()
          local newlen = curr_line:len()

          if curr_line ~= nil and curr_line:match('^%s*$') then
            -- It's empty, so re-indent using `S`
            vim.cmd.stopinsert()
            vim.api.nvim_feedkeys("S", "m", false)
          else
            -- It's not empty, so just use I to get back to the beginning
            local diff = prevlen - newlen

            -- vim.api.nvim_win_set_cursor(0, {row - diff, col})
            pos[2] = pos[2] - diff
            vim.api.nvim_win_set_cursor(0, pos)
          end
        end
      end
      -- vim.keymap.set('i', '<C-_>', '<Esc>gcA', { remap = true, desc = 'Toggle comment' })
      vim.keymap.set('i', '<C-_>', imode_comment, { remap = true, desc = 'Toggle comment' })
      vim.keymap.set('i', '<C-/>', imode_comment, { remap = true, desc = 'Toggle comment' })
      vim.keymap.set('i', '<D-/>', imode_comment, { remap = true, desc = 'Toggle comment' })

      -- Stay in visual mode after the toggle
      vim.keymap.set('v', '<C-_>', 'gcgv', { remap = true, desc = 'Toggle comment' })
      vim.keymap.set('v', '<C-/>', 'gcgv', { remap = true, desc = 'Toggle comment' })
      vim.keymap.set('v', '<D-/>', 'gcgv', { remap = true, desc = 'Toggle comment' })

      -- Standard normal mode mappings
      vim.keymap.set('n', '<C-_>', comapi.toggle.linewise.current, { desc = 'Toggle comment' })
      vim.keymap.set('n', '<C-/>', comapi.toggle.linewise.current, { desc = 'Toggle comment' })
      vim.keymap.set('n', '<D-/>', comapi.toggle.linewise.current, { desc = 'Toggle comment' })
    end
  }
}
