local M = {}

-- Don't do anything if we're in firenvim
if vim.g.started_by_firenvim then
  return
end

M.get_filename = function()
  local filename = vim.fn.expand("%:t")
  local extension = vim.fn.expand("%:e")

  if filename == nil or filename == '' then
    filename = '[No Name]'
    extension = ''
  end

  -- Piggyback on nvim-web-devicons for icon and highlight group
  local icon, hl_group = require("nvim-web-devicons").get_icon(filename, extension, { default = true })

  -- Add circle if modified
  if vim.api.nvim_buf_get_option(0, 'modified') then
    filename = filename .. ' '
  end

  return "%#" .. hl_group .. "#" .. icon .. " %*" .. filename
end

-- Only set winbar for real buffers
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('winbar_setup', {}),
  callback = function()
    -- Schedule so there's enough time for nobuflisted and other things to be processed for the current window
    vim.schedule(function()
      if not require('is-ignored').is_ignored_win() then
        vim.opt_local.winbar =
        "%{%v:lua.require'nvim-navic'.get_location()%} %= %{%v:lua.require'winbar'.get_filename()%}"
      end
    end)
  end
})

return M
