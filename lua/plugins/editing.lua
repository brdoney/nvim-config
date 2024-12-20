return {
  {
    -- Adds extra targets, like vi|
    'wellle/targets.vim',
    event = "VeryLazy",
    init = function()
      -- Use n and N for next and previous instead of n and l
      vim.g.targets_nl = 'nN'
    end
  },
  {
    'windwp/nvim-autopairs',
    event = "VeryLazy",
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
    event = "VeryLazy",
    init = function()
      -- Bold and italics for markdown
      vim.g['surround_' .. vim.fn.char2nr('i')] = "*\r*"
      vim.g['surround_' .. vim.fn.char2nr('I')] = "**\r**"

      -- Docstrings for Python
      vim.g['surround_' .. vim.fn.char2nr('d')] = '"""\r"""'

      -- Markdown word formatting
      vim.keymap.set('n', '<leader>wi', '<Plug>YsurroundiWi', { silent = true, desc = 'Italicize' })
      vim.keymap.set('n', '<D-i>', '<Plug>YsurroundiWi', { silent = true, desc = 'Italicize' })
      vim.keymap.set('v', '<leader>wi', '<Plug>VSurroundi', { silent = true, desc = 'Italicize' })
      vim.keymap.set('v', '<D-i>', '<Plug>VSurroundi', { silent = true, desc = 'Italicize' })
      vim.keymap.set('n', '<leader>wb', '<Plug>YsurroundiWI', { silent = true, desc = 'Bold' })
      vim.keymap.set('n', '<D-b>', '<Plug>YsurroundiWI', { silent = true, desc = 'Bold' })
      vim.keymap.set('v', '<leader>wb', '<Plug>VSurroundI', { silent = true, desc = 'Bold' })
      vim.keymap.set('v', '<D-b>', '<Plug>VSurroundI', { silent = true, desc = 'Bold' })
    end
  },
  {
    -- Multi-cursor editing
    'mg979/vim-visual-multi',
    event = "VeryLazy",
    init = function()
      -- Enable the experimental undo and redo in visual mode (just for actions done in visual mode)
      vim.g.VM_maps   = { Undo = 'u', Redo = '<C-r>' }
      vim.g.VM_leader = '<Space><Space>'
    end
  },
  -- Auto-detect tabs/spaces
  'tpope/vim-sleuth',
  {
    -- Aligning text to specific characters (like formatting tables in markdown)
    'junegunn/vim-easy-align',
    config = function()
      local eagroup = vim.api.nvim_create_augroup('EasyAlignMappings', {})
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        group = eagroup,
        callback = function()
          -- vim.keymap.set('n', '<leader>f', ':%EasyAlign*<Bar><Enter>', { desc = 'Format tables' })
          vim.keymap.set('x', '<leader>f', ':EasyAlign*<Bar><Enter>gv', { desc = 'Format tables' })
          vim.wo.wrap = true
        end
      })
    end,
    keys = {
      { 'ga', '<Plug>(EasyAlign)', mode = 'n', { remap = true, desc = 'Easy align' } },
      { 'ga', '<Plug>(EasyAlign)', mode = 'x', { remap = true, desc = 'Easy align' } }
    },
    cmd = "EasyAlign"
  }
}
