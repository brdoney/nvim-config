-- vim.opt.fillchars = {
--   horiz     = '━',
--   horizup   = '┻',
--   horizdown = '┳',
--   vert      = '┃',
--   vertleft  = '┫',
--   vertright = '┣',
--   verthoriz = '╋',
-- }

vim.opt.laststatus = 3

-- Persist undos across loads by saving to a file
vim.opt.undofile = true

-- Fall back to the keywordprg for providing definitions
vim.keymap.set('n', 'gd', function()
  local cw = vim.fn.expand('<cword>')
  vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
end, { silent = true, desc = "Go to definition" })

-- For vim help pages, specifically use :help to provide definition
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'help',
  callback = function()
    vim.keymap.set('n', 'gd', function()
      local cw = vim.fn.expand('<cword>')
      vim.api.nvim_command('h ' .. cw)
    end, { silent = true, buffer = 0, desc = "Go to vim help" })
  end
})
