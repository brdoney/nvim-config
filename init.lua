-- Speed up loading of lua modules (like what impatient.nvim did)
vim.loader.enable()

-- General settings
require("general")

-- General keybinds
require("keybinds")

-- Install lazy if it's not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- Window bar setup
require("winbar")

-- Project-specific configurations
require("projects")

-- Only use neovide settings if we're in neovide
if vim.g.neovide ~= nil then
  vim.cmd([[source $HOME/.config/nvim/neovide.vim]])
end
