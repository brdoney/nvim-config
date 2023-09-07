" vim: set fdm=marker fmr={{{,}}} fdl=0:

" Speed up loading of lua modules (like what impatient.nvim did)
lua vim.loader.enable()

" Pull configuration from every file (the names explain the contents of each
" file pretty well sooo...)
source $HOME/.config/nvim/general.vim
lua require("general")
source $HOME/.config/nvim/colorscheme.vim

" Only use neovide settings if we're in neovide
if exists('g:neovide')
  source $HOME/.config/nvim/neovide.vim
endif

" Load lua-based plugins
lua require("lua-plugins")

" LSP setup (either CoC or native)
" source $HOME/.config/nvim/coc-setup.vim

" Project-specific configurations
lua require("projects")

lua require("new-init")
