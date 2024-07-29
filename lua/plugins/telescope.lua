return {
  {
    -- Fuzzy finder and selectors
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        scroll_strategy = "limit",
        -- path_display = "tail",
        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        sorting_strategy = "ascending",

        layout_config = {
          horizontal = {
            prompt_position = 'top'
          },
          vertical = {
            mirror = true,
            prompt_position = 'top'
          },
        },
        dynamic_preview_title = true,
        mappings = {
          i = {
            ["<esc>"] = "close",
            ['<C-S-p>'] = require('telescope.actions.layout').toggle_preview
          }
        },
        file_ignore_patterns = {
          "^.venv/", "^.git/", "__pycache__/"
        }
      }
    },
    config = function(_, opts)
      require("telescope").setup(opts)

      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      -- Telescope picker that lists sessions in descending order of access (most recenly used first)
      local sessionpicker = function(picker_opts)
        picker_opts = picker_opts or {}

        -- Use for unsorted (but startify-leveraging) items
        -- local sessions = vim.api.nvim_call_function('startify#session_list', {''})

        -- Use for
        local sessiondir = vim.fn.stdpath('data') .. '/session'
        if vim.g.startify_session_dir ~= nil then
          sessiondir = vim.g.startify_session_dir
        end

        local sessions_exa = vim.fn.system("exa -rs accessed " .. sessiondir)
        local sessions = {}
        for s in sessions_exa:gmatch('[^\n]+') do
          -- Have to filter '__LAST__ -> ...' string from output
          if s:match('__LAST__') == nil then
            table.insert(sessions, s)
          end
        end

        pickers.new(picker_opts {
          prompt_title = "Session Picker",
          finder = finders.new_table {
            results = sessions
          },
          sorter = conf.generic_sorter(picker_opts),
          ---@diagnostic disable-next-line: unused-local
          attach_mappings = function(prompt_bufnr, _map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              vim.cmd('SLoad ' .. selection[1])
              -- print(selection[1])
            end)
            return true
          end,
        }):find()
      end


      -- to execute our custom section picker
      vim.keymap.set('n', '<leader>PP', sessionpicker, { desc = 'Session picker' })
    end,
    cmd = "Telescope",
    keys = {
      '<leader>PP',
      { '<C-p>', function() require('telescope.builtin').find_files({ hidden = true }) end, desc = "File search" },
      { '<D-p>', function() require('telescope.builtin').find_files({ hidden = true }) end, desc = "File search" },
      {
        '<leader>sa',
        function() require('telescope.builtin').find_files({ no_ignore = true }) end,
        desc = "File search without gitignore"
      },
      {
        '<leader>sh',
        function() require('telescope.builtin').find_files({ no_ignore = true, hidden = true }) end,
        desc = "File search all files"
      },
      { '<leader>ss', function() require('telescope.builtin').live_grep() end, desc = "Live grep" }
    }
  },
}
