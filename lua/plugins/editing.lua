return {
  {
    -- Adds extra targets, like vi|
    'wellle/targets.vim',
    init = function()
      -- Use n and N for next and previous instead of n and l
      vim.g.targets_nl = 'nN'
    end
  },
  {
    'windwp/nvim-autopairs',
    opts = {
      enable_check_bracket_line = false
    },
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      require("cmp").event:on('confirm_done', cmp_autopairs.on_confirm_done({ tex = false }))
    end
  },
  -- Surround with things using keyboard shortcuts
  {
    'tpope/vim-surround',
    init = function()
      -- Bold and italics for markdown
      vim.g['surround_' .. vim.fn.char2nr('i')] = "*\r*"
      vim.g['surround_' .. vim.fn.char2nr('I')] = "**\r**"

      -- Markdown word formatting
      vim.keymap.set('n', '<leader>wi', '<Plug>YsurroundiWi', { silent = true, desc = 'Italicize' })
      vim.keymap.set('v', '<leader>wi', '<Plug>VsurroundiWi', { silent = true, desc = 'Italicize' })
      vim.keymap.set('n', '<leader>wb', '<Plug>YsurroundiWI', { silent = true, desc = 'Bold' })
      vim.keymap.set('v', '<leader>wb', '<Plug>VsurroundiWI', { silent = true, desc = 'Bold' })
    end
  },
  -- Auto-closes and auto-renames tags
  'windwp/nvim-ts-autotag'
}
