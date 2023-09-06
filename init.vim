" vim: set fdm=marker fmr={{{,}}} fdl=0:

" Plugin directory for vim-plug
call plug#begin('~/.vim/plugged')

" For various plugins
Plug 'nvim-lua/plenary.nvim'

" Native LSP support
Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer' -- migrated to mason.nvim
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'

" Native LSP visual enchancements
Plug 'stevearc/dressing.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'j-hui/fidget.nvim', { 'tag': 'legacy'}
Plug 'folke/trouble.nvim'

" Non-spec LSP additions
Plug 'simrat39/rust-tools.nvim'
Plug 'mfussenegger/nvim-jdtls'

" For nvim Lua API
Plug 'folke/neodev.nvim'

call plug#end()

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
lua require("lsp-setup")

" Project-specific configurations
lua require("projects")

lua require("new-init")
