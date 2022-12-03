" Update time
set updatetime=100

" Mouse support
set mouse=a

" Map leader to Space
let mapleader=" "

" Search
set ignorecase
set smartcase
nnoremap <silent> <leader>n :noh<CR>

" Gutter
" Show line numbers
set number
set numberwidth=4
" Always show sign column
set signcolumn=yes

" Splits
set splitbelow " Create new horizontal splits below instead of above
set splitright " Create new vertical splits to the right instead of to the left
" set fillchars+=vert:\  " Remove the separator between windows

" Text editing
set backspace=2 " make backspace work like most other programs
set nowrap " Don't wrap lines by default
set breakindent " On files that are indented (e.g. Markdown), indent wrapped lines
set linebreak " Break only at the end of words

let g:python3_host_prog = '/usr/local/bin/python3'

" Indenting defaults (does not override vim-sleuth's indenting detection) when
" there are no other files in a directory to use as reference - defaults to 4
" spaces for most filetypes
if get(g:, '_has_set_default_indent_settings', 0) == 0
  " Set the indenting level to 2 spaces for the following file types.
  autocmd FileType markdown,typescript,javascript,jsx,tsx,css,html,ruby,elixir,kotlin,vim,plantuml,c,cpp setlocal expandtab tabstop=2 shiftwidth=2
  
  " Defaults for all files, unless overriden with `autocmd` like above
  set expandtab
  set tabstop=4
  set shiftwidth=4

  " Tell sleuth that we now have default indent settings
  let g:_has_set_default_indent_settings = 1
endif

" Hide vertical split colour
" highlight VertSplit ctermfg=gray ctermbg=gray

" Highlight current line
set cursorline

" Lazy redraw to (maybe?) speed up scrolling and definitely speed up macros
set lazyredraw

" Hide the buffers instead of abandoning them when switching
set hidden

" Disable folds by default, until `zc` is pressed

" Keybindings text navigation
"=============================
" Most are commented out because they just emulate macOS shortcuts -> learn Vim instead!

" Bind fn+backspace to delete
inoremap <Char-0x4> <Del>

" Bind option+backspace to delete?
" inoremap <Char-0x1b><Char-0x7f> <C-o>db

" Cmd+Up is 0x02 and Cmd+Down is 0x03 through iTerm2 Neovim profile
" Bind to start and end of file respectively
" inoremap <Char-0x02> <C-o>:0<CR>
" inoremap <Char-0x03> <C-o>:$<CR>
" noremap <Char-0x02> :0<CR>
" noremap <Char-0x03> :$<CR>

" Cmd+Left is 0x01 and Cmd+Right is 0x05 through iTerm2 global bindings
" Bind to start and end of line respectively
" inoremap <Char-0x01> <C-o>0
" inoremap <Char-0x05> <C-o>$
" noremap <Char-0x01> 0
" noremap <Char-0x05> $

" M-b is option+left and M-f is option+right
" imap <M-b> <C-o>b
" map <M-b> b
" inoremap <M-f> <C-o>w
" noremap <M-f> w

" Map replacement since C-Down and C-Up are macOS hotkeys
nmap <C-S-Down> <C-Down>
nmap <C-S-Up> <C-Up>

" Tempfix gx until it is actually fixed https://github.com/vim/vim/issues/4738
" Not used anymore since netrw, which creates the `gx` binding, is disabled by
" nvimtree - look in plugins.lua for a `gx` replacement
" if has('macunix')
"   function! OpenURLUnderCursor()
"     let s:uri = expand('<cWORD>')
"     let s:uri = substitute(s:uri, '?', '\\?', '')
"     let s:uri = shellescape(s:uri, 1)
"     if s:uri != ''
"       silent exec "!open '".s:uri."'"
"       :redraw!
"     endif
"   endfunction
"   nnoremap gx :call OpenURLUnderCursor()<CR>
" endif

" Easier esc in terminal
" tnoremap <Esc> <C-\><C-n>
" tnoremap <C-w> <C-\><C-n>
tnoremap <C-w> <C-\><C-n><C-w>

" Make Y behave like any other capital letter
nnoremap Y y$

" Navigate lines visually when lines are wrapped
nnoremap j gj
nnoremap k gk

" Add semicolon to end of line without messing up cursor position
nnoremap <leader>; :normal! mqA;<Esc>`q

nnoremap <silent> ]q :cn<CR>
nnoremap <silent> [q :cp<CR>
nnoremap <silent> ]Q :cnf<CR>
nnoremap <silent> [Q :cpf<CR>
nnoremap <silent> <leader>qq :cclose<CR>

" Close current tab
nnoremap <silent> <leader>\| :tabclose<CR>

" Don't list quickfix windows in the buffer list
augroup qf
  autocmd FileType qf set nobuflisted
augroup END

" Maximise height/width of current window w/o using <C-w>_ or <C-w>| (awkward keybindings)
map <leader>m <C-w>_
map <leader>M <C-w>\|

" Disable automatic comment continuation when using `o`, or pressing enter,
" and don't wrap comments automatically
autocmd FileType * setlocal formatoptions-=cro

