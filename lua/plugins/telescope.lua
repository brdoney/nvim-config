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
    cmd = "Telescope",
    keys = {
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
