return {
  {
    'MeanderingProgrammer/markdown.nvim',
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ft = "markdown",
    -- name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    -- config = function()
    --     require('render-markdown').setup({})
    -- end,
    -- I don't, so this is fine instead:
    opts = {
      heading = {
        sign = false,
        backgrounds = { 'MarkdownBg1', 'MarkdownBg2', 'MarkdownBg3', 'MarkdownBg4', 'MarkdownBg5', 'MarkdownBg6' }
      },
      code = {
        sign = false,
      },
      bullet = {
        icons = { '•', '◦', '⬩', '⁃' },
      },
      -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
      -- There are two special states for unchecked & checked defined in the markdown grammar
      checkbox = {
        -- Turn on / off checkbox state rendering
        enabled = true,
        unchecked = {
          -- icon = '• 󰄱 ',
          -- Highlight for the unchecked icon
          highlight = '@markup.list.unchecked',
        },
        checked = {
          -- icon = '• 󰱒 ',
          -- Highligh for the checked icon
          highlight = '@markup.list.checked',
        },
      },
      callout = {
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
