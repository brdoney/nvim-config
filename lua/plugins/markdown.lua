return {
  {
    -- Ties neovim together with an in-browser preview
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown"
  }
}
