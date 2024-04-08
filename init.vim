" vim: set fdm=marker fmr={{{,}}} fdl=0:

" Speed up loading of lua modules (like what impatient.nvim did)
lua vim.loader.enable()

" Only use neovide settings if we're in neovide
if exists('g:neovide')
  source $HOME/.config/nvim/neovide.vim
endif

" LSP setup (either CoC or native)
" source $HOME/.config/nvim/coc-setup.vim

lua require("new-init")
