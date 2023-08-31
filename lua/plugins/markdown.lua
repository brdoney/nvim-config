return {
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
