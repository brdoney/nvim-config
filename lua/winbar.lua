local M = {}

-- Don't do anything if we're in firenvim
if vim.g.started_by_firenvim then
  return M
end

-- From https://github.com/b0o/incline.nvim/blob/fdd7e08a6e3d0dd8d9aa02428861fa30c37ba306/lua/incline/util.lua

local config = {
  ignore = {
    buftypes = "special",
    filetypes = {},
    floating_wins = true,
    unlisted_buffers = true,
    wintypes = "special"
  },
}

local function is_ignored_filetype(filetype)
  local ignore = config.ignore
  return ignore.filetypes and vim.tbl_contains(ignore.filetypes, filetype)
end

local function is_ignored_buf(bufnr)
  bufnr = bufnr or 0
  local ignore = config.ignore
  if ignore.unlisted_buffers and not vim.api.nvim_buf_get_option(bufnr, 'buflisted') then
    return true
  end
  if ignore.buftypes then
    local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
    if ignore.buftypes == 'special' and buftype ~= '' then
      return true
    elseif type(ignore.buftypes) == 'table' then
      if vim.tbl_contains(ignore.buftypes, buftype) then
        return true
      end
    elseif type(ignore.buftypes) == 'function' then
      if ignore.buftypes(bufnr, buftype) then
        return true
      end
    end
  end
  if ignore.filetypes then
    local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    if is_ignored_filetype(filetype) then
      return true
    end
  end
  return false
end

local function is_floating_win(winid)
  return vim.api.nvim_win_get_config(winid or 0).relative ~= ''
end

local function is_ignored_win(winid)
  winid = winid or 0
  local bufnr = vim.api.nvim_win_get_buf(winid)
  if is_ignored_buf(bufnr) then
    return true
  end
  local ignore = config.ignore
  if ignore.floating_wins and is_floating_win(winid) then
    return true
  end
  if ignore.wintypes then
    local wintype = vim.fn.win_gettype(winid)
    if ignore.wintypes == 'special' and wintype ~= '' then
      return true
    elseif type(ignore.wintypes) == 'table' then
      if vim.tbl_contains(ignore.wintypes, wintype) then
        return true
      end
    elseif type(ignore.wintypes) == 'function' then
      if ignore.wintypes(winid, wintype) then
        return true
      end
    end
  end
  return false
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
      if not is_ignored_win() then
        -- Right aligned file type
        vim.opt_local.winbar =
        "%{%v:lua.require'nvim-navic'.get_location()%} %= %{%v:lua.require'winbar'.get_filename()%}"
        -- Left aligned file type (before breadcrumbs)
        -- vim.opt_local.winbar =
        -- "%{%v:lua.require'winbar'.get_filename()%}  %{%v:lua.require'nvim-navic'.get_location()%} "
      end
    end)
  end
})

return M
