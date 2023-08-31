" vim: set fdm=marker fmr={{{,}}} fdl=0:

" Plugin directory for vim-plug
call plug#begin('~/.vim/plugged')

" Command-line tools
" Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug '~/Developer/Vim/toggleterm.nvim/'

" Syntax highlighting
Plug 'sainnhe/sonokai'

" Comments
" Plug 'scrooloose/nerdcommenter'
Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Multi-cursor editing
Plug 'mg979/vim-visual-multi', { 'branch': 'master' }

" Native LSP {{{

" Native LSP support
Plug 'neovim/nvim-lspconfig'
" Plug 'williamboman/nvim-lsp-installer' -- migrated to mason.nvim
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'

" Native LSP visual enchancements
Plug 'onsails/lspkind.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'j-hui/fidget.nvim', { 'tag': 'legacy'}
Plug 'folke/trouble.nvim'

" Support non-LSP sources (i.e. for formatting)
Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'

" Non-spec LSP additions
Plug 'simrat39/rust-tools.nvim'
Plug 'mfussenegger/nvim-jdtls'

" Native LSP completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'lukas-reineke/cmp-under-comparator'  " For putting dunder methods lower in list in Python
Plug 'hrsh7th/nvim-cmp'

" For nvim Lua API
Plug 'folke/neodev.nvim'

" Snippets
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Telescope
Plug 'nvim-telescope/telescope.nvim'

" }}}

" Running code
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
" Plug 'vim-test/vim-test'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Auto-detect tabs/spaces
Plug 'tpope/vim-sleuth'  " Auto detects file tabs/spaces

" Aligning text
Plug 'junegunn/vim-easy-align'

" External integrations
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }  " Nvim in the browser
Plug 'edkolev/tmuxline.vim'

" Rainbow CSV and querying
Plug 'mechatroner/rainbow_csv'

" Database explorer
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-completion'
Plug 'kristijanhusak/vim-dadbod-ui'

" Resize mode using natural directions
Plug 'mrjones2014/smart-splits.nvim'

call plug#end()

" Speed up loading of lua modules (like what impatient.nvim did)
lua vim.loader.enable()

" Pull configuration from every file (the names explain the contents of each
" file pretty well sooo...)
source $HOME/.config/nvim/general.vim
lua require("general")
source $HOME/.config/nvim/colorscheme.vim
source $HOME/.config/nvim/neovide.vim

" Load vim-and lua-based plugins
source $HOME/.config/nvim/plugins.vim
lua require("lua-plugins")

" LSP setup (either CoC or native)
" source $HOME/.config/nvim/coc-setup.vim
lua require("lsp-setup")

" Project-specific configurations
lua require("projects")

lua require("new-init")

