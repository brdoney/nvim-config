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

-- I and A shortcuts for visible lines
vim.keymap.set("n", "gA", "g$a", { desc = "Insert at end of visible line" })
vim.keymap.set("n", "gI", "g^i", { desc = "Insert at start of visible line" })

-- Better foldtext
vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) ]]
vim.opt.fillchars = "fold: "

-- Make vertical and horizontal scrolling the same amount
vim.opt.mousescroll = "ver:3,hor:3"

-- Set the indenting level to 2 spaces for the following file types.
local two_files = { 'markdown', 'typescript', 'javascript', 'jsx', 'tsx', 'css', 'html', 'ruby', 'elixir',
  'kotlin', 'vim', 'plantuml', 'c', 'cpp' }
local sleuth_group = vim.api.nvim_create_augroup('sleuth_settigs', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = two_files,
  group = sleuth_group,
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end
})

-- Defaults for all files, unless overriden with `autocmd` like above or by sleuth
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
