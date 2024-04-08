return {
  {
    -- Resize mode using natural directions
    'mrjones2014/smart-splits.nvim',
    opts = {},
    keys = { { "<C-w>r", function() require('smart-splits').start_resize_mode() end, desc = "Start buffer resize mode" } }
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        ["<space>"] = "spc",
        ["<cr>"] = "",
        ["<tab>"] = "",
      },
      window = {
        border = "single",        -- none, single, double, shadow
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      },
    },
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300

      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        c = {
          name = "conflict" -- optional group name
        },
        h = {
          name = "git"
        },
        q = {
          name = "lsp",
          w = {
            name = "workspace"
          },
          n = {
            name = "neogen"
          },
        },
        s = {
          name = "search"
        },
        P = {
          name = 'project'
        },
        ["<Space>"] = {
          name = "VM"
        },
        w = {
          name = "word"
        },
        [";"] = { "Add ; to end of line" },
        m = { "Max height" },
        M = { "Max width" }
      }, { prefix = "<leader>" })
      -- wk.register({
      --   D = { "Go to declaration" },
      --   d = { "Go to definition" },
      --   r = { "Go to references" },
      --   i = { "Go to implementation" },
      -- })

      wk.register({
        q = {
          name = "lsp",
        },
      }, { prefix = "<leader>", mode = "v" })
    end
  },
}
