return {
  -- Syntax highlighting
  {
    'sainnhe/sonokai',
    priority = 1000,
    init = function()
      -- The configuration options should be placed before `colorscheme sonokai`.
      vim.g.sonokai_style = "maia"
      -- Enable italics
      vim.g.sonokai_enable_italic = 1
      -- Show more markers for lines with diagnostics
      vim.g.sonokai_diagnostic_text_highlight = 1
      -- Make the sign column the same background as normal text
      vim.g.sonokai_sign_column_background = 'none'
      -- Normally, colour is based on the type of diagonstic (hint, into, error, etc.)
      vim.g.sonokai_diagnostic_virtual_text = 'grey'
      -- Make autocomplete green instead of blue
      vim.g.sonokai_menu_selection_background = 'green'
      -- Don't show the end of buffer `~`s
      vim.g.sonokai_show_eob = 0
      -- Disable terminal colors
      vim.g.sonokai_disable_terminal_colors = 1
    end,
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme sonokai]])
    end,
  },
}
