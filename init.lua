-- Speed up loading of lua modules (like what impatient.nvim did)
vim.loader.enable()

-- General settings
require("general")

-- General keybinds
require("keybinds")

-- Install lazy if it's not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
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
