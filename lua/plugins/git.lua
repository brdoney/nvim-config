return {
  {
    -- Shows git status icons in the gutter
    'airblade/vim-gitgutter',
    init = function()
      vim.g.gitgutter_sign_added                   = '┃'
      vim.g.gitgutter_sign_modified                = '┃'
      vim.g.gitgutter_sign_removed                 = '┃'
      vim.g.gitgutter_sign_removed_first_line      = '╹'
      vim.g.gitgutter_sign_removed_above_and_below = '┇'
      vim.g.gitgutter_sign_modified_removed        = '┇'
      vim.keymap.set("n", "<leader>hh", "<Plug>(GitGutterPreviewHunk)")
    end
  },
  {
    -- Vim fugitive does literally everything git related
    'tpope/vim-fugitive',
    keys = {
      {
        "<leader>G",
        function()
          vim.cmd("tab :G")
          vim.o.winheight = 10
          vim.o.winminheight = 10
        end,
        desc = "Open Fugitive"
      },
      {
        "<leader>hp", ":G push<CR>", desc = "Git push"
      }
    }
  },
  {
    -- Highlight git conflicts and navigate between them in one buffer
    -- Isn't super great b/c it's kinda buggy and doesn't highlight conflicts
    -- unless they're entirely on screen - should try conflict-markers.vim
    'akinsho/git-conflict.nvim',
    tag = '*',
    opts = {
      default_mappings = false,
      disable_diagnostics = true,
      highlights = {
        -- They must have background color, otherwise the default color will be used
        incoming = 'DiffDelete',
        current = 'DiffAdd',
      }
    },
    init = function()
      vim.keymap.set('n', '<leader>co', '<Plug>(git-conflict-ours)')
      vim.keymap.set('n', '<leader>ct', '<Plug>(git-conflict-theirs)')
      vim.keymap.set('n', '<leader>cb', '<Plug>(git-conflict-both)')
      vim.keymap.set('n', '<leader>c0', '<Plug>(git-conflict-none)')
      vim.keymap.set('n', '[x', '<Plug>(git-conflict-prev-conflict)')
      vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)')
    end
  }
  -- Plug 'nvim-lua/plenary.nvim'  " For gitsigns below
  -- Plug 'lewis6991/gitsigns.nvim'  " Lua gitgutter with blame messages
}
