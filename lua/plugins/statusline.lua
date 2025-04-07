local function get_short_cwd()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
end

local custom_nvimtree_lualine = {
  sections = { lualine_c = { get_short_cwd } },
  filetypes = { 'NvimTree' }
}

local wordcount_component = {
  function()
    -- visual, visual line, and visual-block modes
    if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "CTRL-V" then
      local count = vim.fn.wordcount()
      return count.words .. " words (" .. count.visual_words .. " selected)"
    else
      return vim.fn.wordcount().words .. " words"
    end
  end,
  cond = function()
    local ft = vim.opt_local.filetype:get()
    local count = {
      latex = true,
      tex = true,
      text = true,
      markdown = true,
    }
    return count[ft] ~= nil
  end,
}

local sleuth_symbols = {
  space = '󱁐 ',
  tab = '󰌒 ',
  textwidth = ' ',
  -- space = 'Spaces: ',
  -- tab = 'Tab Size: ',
  -- textwidth = 'Wrap: '
}

-- Based on https://github.com/tpope/vim-sleuth/blob/1cc4557420f215d02c4d2645a748a816c220e99b/plugin/sleuth.vim#L640
local function sleuth_component()
  local sw = vim.bo.shiftwidth > 0 and vim.bo.shiftwidth or vim.bo.tabstop

  -- Show shift/tab info
  local ind
  if vim.bo.expandtab then
    ind = sleuth_symbols.space .. sw
  elseif vim.bo.tabstop == sw then
    ind = sleuth_symbols.tab .. vim.bo.tabstop
  else
    ind = sleuth_symbols.space .. sw .. ' ' .. sleuth_symbols.tab .. vim.bo.tabstop
  end

  -- Show text wrapping info
  if vim.bo.textwidth > 0 then
    ind = ind .. ' ' .. sleuth_symbols.textwidth .. vim.bo.textwidth
  end

  -- Show end of line info
  if not vim.bo.fixendofline and not vim.bo.endofline then
    ind = ind .. ' noeol'
  end

  return ind
end

return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cond = not vim.g.started_by_firenvim,
    opts = {
      options = {
        theme = require("minimalist"),
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          {
            'filename',
            path = 1, -- show relative path
            symbols = {
              modified = '',
              readonly = '-',
            }
          },
          'diagnostics'
        },
        lualine_x = { wordcount_component, 'encoding', 'fileformat', { 'filetype', colored = false } },
        lualine_y = { sleuth_component },
        lualine_z = {
          { 'location', padding = { left = 1, right = 1 } },
          { 'progress', padding = { left = 0, right = 1 } }
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      extensions = {
        'fugitive',
        'quickfix',
        custom_nvimtree_lualine
      }
    }
  },
}
