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
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local os = vim.uv.os_uname().sysname

--- @type string|nil
local dev_path = ""
if os == "Windows_NT" then
  dev_path = nil
elseif os == "macOS" then
  dev_path = "~/Developer/nvim-plugins"
else
  dev_path = "~/Documents/Tools/nvim-plugins"
end

-- require("lazy").setup("plugins")
require("lazy").setup("plugins", {
  dev = { path = dev_path }
})

-- Window bar setup
require("winbar")

-- Project-specific configurations
require("projects")

-- Only use neovide settings if we're in neovide
if vim.g.neovide ~= nil then
  vim.cmd([[source $HOME/.config/nvim/neovide.vim]])
end
