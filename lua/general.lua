-- vim.opt.fillchars = {
--   horiz     = '━',
--   horizup   = '┻',
--   horizdown = '┳',
--   vert      = '┃',
--   vertleft  = '┫',
--   vertright = '┣',
--   verthoriz = '╋',
-- }

-- Will be disabled for firenvim
if vim.g.started_by_firenvim then
  vim.o.laststatus = 0
  vim.o.showtabline = 0
end

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
local sleuth_group = vim.api.nvim_create_augroup('sleuth_settings', {})
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

-- Open URL - used because netrw is disabled, so we can't rely on its `gx` mapping
local function setGx(cmd)
  vim.keymap.set('', 'gx', cmd, { desc = 'Open link', silent = true })
end
if vim.fn.has("mac") == 1 then
  setGx('<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>')
elseif vim.fn.has("unix") == 1 then
  setGx('<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>')
else
  setGx('<Cmd>lua print("Error: gx is not supported on this OS!")<CR>')
end
