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
      win = {
        -- Prefer overlap over scrolling
        no_overlap = false,
        border = "single",  -- none, single, double, shadow
        padding = { 2, 2 }, -- extra window padding [top/bottom, right/left]
      },
      spec = {
        { "<leader>c", group = "conflict", icon = "" },
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
