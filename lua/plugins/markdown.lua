return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ft = "markdown",
    opts = {
      heading = {
        -- Also render them in insert mode, just to make things look better
        render_modes = { 'i' },
        -- Don't show a sign in the gutter
        sign = false,
        -- Custom backgrounds (defined in colorscheme.lua)
        backgrounds = { 'MarkdownBg1', 'MarkdownBg2', 'MarkdownBg3', 'MarkdownBg4', 'MarkdownBg5', 'MarkdownBg6' }
      },
      code = {
        -- Don't show sign in the gutter
        sign = false,
      },
      bullet = {
        -- Also render them in insert mode, just to make things look better
        render_modes = { 'i' },
        -- Custom icons
        icons = { '•', '◦', '⬩', '⁃' },
      },
      -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
      -- There are two special states for unchecked & checked defined in the markdown grammar
      checkbox = {
        -- Also render them in insert mode, just to make things look better
        render_modes = { 'i' },
        -- Turn on / off checkbox state rendering
        enabled = true,
        unchecked = {
          -- icon = '• 󰄱 ',
          icon = '󰄱',
          -- Highlight for the unchecked icon
          highlight = '@markup.list.unchecked',
        },
        checked = {
          -- icon = '• 󰱒 ',
          icon = '󰱒',
          -- Highligh for the checked icon
          highlight = '@markup.list.checked',
        },
        custom = {
          todo = { raw = '[-]', rendered = '󰡖', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
          closed = { raw = '[/]', rendered = '󱋭', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
        },
      },
      callout = {
        -- Custom highlight groups, defined in colorscheme.lua
        note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'CalloutInfo' },
        tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'CalloutTip' },
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'CalloutImportant' },
        warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'CalloutWarning' },
        caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'CalloutCaution' }
      }
    }
  },
  {
    -- Ties neovim together with an in-browser preview
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    init = function()
      -- Don't close preview when changing away from the buffer
      vim.g.mkdp_auto_close = 0
    end,
  }
}
