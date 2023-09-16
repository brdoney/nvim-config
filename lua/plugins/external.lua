return {
  {
    'edkolev/tmuxline.vim',
    event = "VeryLazy"
  },
  {
    'glacambre/firenvim',

    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function()
      vim.fn["firenvim#install"](0)
    end,
    init = function()
      -- Never turn on by default and use neovim's cmdline instead of the custom one
      vim.g.firenvim_config = { localSettings = { ['.*'] = { takeover = 'never', cmdline = 'neovim' } } }
    end,
    config = function()
      -- Runs when firenvim starts the neovim instance it saves

      -- Text editing shortcuts (taken from neovide config)
      vim.keymap.set("i", "<M-BS>", "<C-W>")
      vim.keymap.set("i", "<D-BS>", "<C-U>")

      vim.opt.guifont = { "LigaMenlo Nerd Font", "h18" }
      vim.opt.number = false

      local firenvim_group = vim.api.nvim_create_augroup('firenvim_settings', {})
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { 'github.com_*.txt', 'gitlab.com_*.txt' },
        group = firenvim_group,
        callback = function()
          vim.bo.filetype = 'markdown'
        end
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'text', 'markdown' },
        group = firenvim_group,
        callback = function()
          vim.wo.spell = true
          vim.opt.wrap = true
        end
      })
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        group = firenvim_group,
        callback = function()
          -- This is overriden elsewhere in my config and lazy nvim runs this pretty early, so it's easiest to just set this here now
          vim.opt.laststatus = 0
          vim.opt.showtabline = 0
        end
      })
    end
  }

}
