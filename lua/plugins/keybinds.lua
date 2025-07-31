return {
  {
    'mrjones2014/smart-splits.nvim',
    event = 'VeryLazy',
    dependencies = {
      'pogyomo/submode.nvim',
    },
    config = function()
      -- Resize
      local submode = require 'submode'
      submode.create('WinResize', {
        mode = 'n',
        enter = '<C-w>r',
        leave = { '<Esc>', 'q', '<C-c>' },
        hook = {
          on_enter = function()
            vim.notify 'Use { h, j, k, l } or { <Left>, <Down>, <Up>, <Right> } to resize the window'
          end,
          on_leave = function()
            vim.notify ''
          end,
        },
        default = function(register)
          register('h', require('smart-splits').resize_left, { desc = 'Resize left' })
          register('j', require('smart-splits').resize_down, { desc = 'Resize down' })
          register('k', require('smart-splits').resize_up, { desc = 'Resize up' })
          register('l', require('smart-splits').resize_right, { desc = 'Resize right' })
          register('<Left>', require('smart-splits').resize_left, { desc = 'Resize left' })
          register('<Down>', require('smart-splits').resize_down, { desc = 'Resize down' })
          register('<Up>', require('smart-splits').resize_up, { desc = 'Resize up' })
          register('<Right>', require('smart-splits').resize_right, { desc = 'Resize right' })
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      win = {
        -- Prefer overlap over scrolling
        no_overlap = false,
        border = "single",  -- none, single, double, shadow
        padding = { 2, 2 }, -- extra window padding [top/bottom, right/left]
      },
      spec = {
        { "<leader>c", group = "conflict", icon = "" },
        { "<leader>d", group = "debug" },
        { "<leader>db", group = "breakpoint", icon = { icon = "", color = "red" } },
        { "<leader>t", group = "tabs" },
        { "<leader>h", group = "git" },
        { "<leader>q", group = "lsp", mode = { "n", "v" }, icon = { icon = "", color = "purple" } },
        { "<leader>qw", group = "workspace" },
        { "<leader>qn", group = "neogen" },
        { "<leader>s", group = "search", icon = { icon = "", color = "grey" } },
        { "<leader>P", group = "project", icon = { icon = "", color = "blue" } },
        { "<leader>w", group = "word", icon = { icon = "", color = "grey" } },
        { "<leader><Space>", group = "VM", icon = { icon = "󰗧", color = "grey" } },
        { "<leader>i", icon = "󰌒" },
        { "<leader>m", icon = "󰡏" },
        { "<leader>M", icon = "󰡎" },
        { "<leader>R", icon = { icon = "󰑐", color = "green" } },
        { "<leader>r", icon = { icon = "", color = "green" } },
        { "<leader>G", icon = { cat = "filetype", name = "git" } },
        { "<leader>T", icon = { icon = "󰙨", color = "green" } },
        { "<leader>n", icon = "󰉥" },
        { "<leader>;", icon = ";" },
      },
      -- icons = {
      --   mappings = false
      -- },
    },
  },
}
