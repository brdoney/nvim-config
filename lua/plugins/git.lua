local border = require("border")

return {
  -- {
  --   -- Shows git status icons in the gutter
  --   'airblade/vim-gitgutter',
  --   event = 'VeryLazy',
  --   init = function()
  --     vim.g.gitgutter_sign_added                   = '┃'
  --     vim.g.gitgutter_sign_modified                = '┃'
  --     vim.g.gitgutter_sign_removed                 = '┃'
  --     vim.g.gitgutter_sign_removed_first_line      = '╹'
  --     vim.g.gitgutter_sign_removed_above_and_below = '┇'
  --     vim.g.gitgutter_sign_modified_removed        = '┇'
  --     vim.keymap.set("n", "<leader>hh", "<Plug>(GitGutterPreviewHunk)")
  --   end
  -- },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '┃' },
        topdelete    = { text = '╹' },
        changedelete = { text = '┇' },
        untracked    = { text = '' },
      },
      signs_staged = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '┃' },
        topdelete    = { text = '╹' },
        changedelete = { text = '┇' },
        untracked    = { text = '' },
      },
      preview_config = {
        col = 1,
        relative = "cursor",
        row = 0,
        border = border.border,
        style = "minimal"
      },
      current_line_blame_opts = {
        virt_text_pos = "right_align"
      },
      trouble = false,
      gh = true,
    },
    keys = {
      { "<leader>hl", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle line blame" },
      { "<leader>hh", function() require("gitsigns").preview_hunk() end,              desc = "Preview hunk" },
      { "<leader>hi", function() require("gitsigns").preview_hunk_inline() end,       desc = "Preview hunk inline" },
      { "<leader>hs", function() require("gitsigns").stage_hunk() end,                desc = "Stage hunk" },
      { "<leader>hu", function() require("gitsigns").reset_hunk() end,                desc = "Unstage hunk" },
      { "<leader>hB", function() require("gitsigns").blame() end,                     desc = "Open buffer blame" },
      { "<leader>hb", function() require("gitsigns").blame_line() end,                desc = "Open line blame" },
      { "<leader>hq", function() require("gitsigns").setqflist() end,                 desc = "Open line blame" },
      { "<leader>hw", function() require("gitsigns").toggle_word_diff() end,          desc = "Toggle word diff" },
      { "]c",         function() require("gitsigns").nav_hunk("next") end,            desc = "Next hunk" },
      { "[c",         function() require("gitsigns").nav_hunk("prev") end,            desc = "Previous hunk" },
    }
  },
  {
    -- Vim fugitive does literally everything git related
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    keys = {
      {
        "<leader>G",
        function()
          vim.cmd("tab :G")
          vim.o.winheight = 10
          vim.o.winminheight = 10
          vim.g.fugitive_tab = vim.api.nvim_tabpage_get_number(0)
        end,
        desc = "Open Fugitive"
      },
      {
        "<leader>hp", "<cmd>G push<CR>", desc = "Git push"
      }
    }
  },
  {
    -- Highlight git conflicts and navigate between them in one buffer
    -- Isn't super great b/c it's kinda buggy and doesn't highlight conflicts
    -- unless they're entirely on screen - should try conflict-markers.vim
    'akinsho/git-conflict.nvim',
    version = '*',
    event = 'VeryLazy',
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
