" vim: set fdm=marker fmr={{{,}}}:

" Plugin directory for vim-plug
call plug#begin('~/.vim/plugged')

" Speed up startup
Plug 'lewis6991/impatient.nvim'

" Distant for remote editing
" Plug 'chipsenkbeil/distant.nvim'

" Profiling
" Plug 'dstein64/vim-startuptime'

" Status and tablines
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'romgrk/barbar.nvim'
Plug 'b0o/incline.nvim'

" Colored icons in a ton of stuff
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'  " Depends on vim-devicons

" Explorer
Plug 'kyazdani42/nvim-tree.lua'

" Indent highlights
Plug 'lukas-reineke/indent-blankline.nvim'

" Misc UI
Plug 'mhinz/vim-startify'
Plug 'junegunn/goyo.vim'  " Basic zen mode
" Plug 'junegunn/limelight.vim'  " Dim everything other than the current section
" Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }  " Colors in the sign column
" let g:Hexokinase_highlighters = ['backgroundfull']
Plug 'petertriho/nvim-scrollbar'  " Scrollbar which shows diagnostics and such
Plug 'kevinhwang91/nvim-bqf'  " Improvements to the quickfix window

" Git
Plug 'airblade/vim-gitgutter'
" Plug 'nvim-lua/plenary.nvim'  " For gitsigns below
" Plug 'lewis6991/gitsigns.nvim'  " Lua gitgutter with blame messages
Plug 'tpope/vim-fugitive'
Plug 'akinsho/git-conflict.nvim'

" Command-line tools
" VSCode-like terminal (toggle, AsyncRun support, and more)
Plug 'skywind3000/vim-terminal-help'

" Keybindings
" Plug 'liuchengxu/vim-which-key'
Plug 'folke/which-key.nvim'
Plug 'wellle/targets.vim'

" Syntax highlighting
Plug 'sainnhe/sonokai'
" Plug 'folke/tokyonight.nvim'  " Nice theme, but only supports LSP and NvimTree
" Kinda slow and not as good as TreeSitter, but support more languages
"Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'  " For debugging themes

" Comments
" Plug 'scrooloose/nerdcommenter'
Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Multi-cursor editing
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Pairs and surround
Plug 'windwp/nvim-autopairs'
Plug 'tpope/vim-surround'
Plug 'alvan/vim-closetag'

" COC.nvim {{{
" Plug '/usr/local/opt/fzf'
" Plug 'junegunn/fzf.vim'

" (external LSP support based on VSCode extensions)
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'antoinemadec/coc-fzf'
" }}}

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
Plug 'j-hui/fidget.nvim'
Plug 'folke/trouble.nvim'

" Support non-LSP sources (i.e. for formatting)
Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'

" Non-spec LSP additions
Plug 'simrat39/rust-tools.nvim'

" Native LSP completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
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
Plug 'skywind3000/asyncrun.extra'  " For terminal-help support
" Plug 'vim-test/vim-test'

" Markdown
" Plug 'dkarter/bullets.vim', { 'for': 'markdown' }
Plug 'gaoDean/autolist.nvim'
Plug 'jbyuki/nabla.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Auto-detect tabs/spaces
Plug 'tpope/vim-sleuth'  " Auto detects file tabs/spaces

" Weird file types that don't have LSP support
Plug 'vim-scripts/applescript.vim'

" Aligning text
Plug 'junegunn/vim-easy-align'

" External integrations
Plug 'editorconfig/editorconfig-vim'
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }  " Nvim in the browser
Plug 'edkolev/tmuxline.vim'

call plug#end()

lua require('impatient')

" Pull configuration from every file (the names explain the contents of each
" file pretty well sooo...)
source $HOME/.config/nvim/general.vim
lua require("general")
source $HOME/.config/nvim/colorscheme.vim
source $HOME/.config/nvim/statusline.vim
source $HOME/.config/nvim/neovide.vim

" Load vim-and lua-based plugins
source $HOME/.config/nvim/plugins.vim
lua require("plugins")

" LSP setup (either CoC or native)
" source $HOME/.config/nvim/coc-setup.vim
lua require("lsp-setup")

