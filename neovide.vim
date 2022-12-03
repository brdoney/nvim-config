" vim: set fdm=marker fmr={{{,}}}:

set guifont=LigaMenlo\ Nerd\ Font:h13

" Don't try to restore the size of the window
let g:neovide_remember_window_size = v:false

" Use alt as meta to avoid having to redefine keybindings
let g:neovide_input_macos_alt_is_meta=v:true

" Map alt+bs 

" Command-c/v to copy/paste from system clipboard
noremap <D-v> "+p<CR>
noremap! <D-v> <C-R>+
tnoremap <D-v> <C-R>+
vnoremap <D-c> "+y<CR>

" Command-/ into Ctrl-/ for toggling comments
map <D-/> <C-_>
map! <D-/> <C-_>

" Command-p into ctrl-p for fzf/telescope bindings
map <D-p> <C-p>
map! <D-p> <C-p>

" Command-r into <leader>r to run code
map <D-r> <leader>r
map! <D-r> <leader>r

" Alt+shift+f into <leader>f to format code
nmap <M-F> <leader>f

" Command+shift+o into <leader>qo to look at objects/symbols
" Neovide doesn't pass through Command+shift, so <D-o> has to work
nmap <D-o> <leader>qo

" Save with Command-s
nnoremap <silent> <D-s> :w<CR>
inoremap <silent> <D-s> x<BS><C-o>:w<CR>
tnoremap <silent> <D-s> <C-\><C-n>:w<CR>i

" Create a new neovide window with Command-n
nnoremap <silent> <D-n> :!neovide<CR><CR>

" Text editing shortcuts
imap <M-BS> <C-W>
imap <D-BS> <C-U>

" Command-a to select everything in the current buffer
nnoremap <D-a> ggVG
inoremap <D-a> <Esc>ggVG

" Markdown shortcuts
inoremap <silent> <D-i> **<C-o>i
nnoremap <silent> <D-i> <Plug>YsurroundiW*
vnoremap <silent> <D-i> <Plug>VSurround*
inoremap <silent> <D-b> ****<C-o>h
nnoremap <silent> <D-b> <Plug>YsurroundiW*<Plug>YsurroundiW*
vnoremap <silent> <D-b> <Plug>VSurround*gv<Plug>VSurround*

" Toggle fullscreen using Command-Ctrl-f
command -nargs=0 NeovideToggleFullscreen :let g:neovide_fullscreen = !g:neovide_fullscreen
nnoremap <silent> <C-D-f> :NeovideToggleFullscreen<CR>
inoremap <silent> <C-D-f> x<BS><C-o>:NeovideToggleFullscreen<CR>
tnoremap <silent> <C-D-f> <C-\><C-n>:NeovideToggleFullscreen<CR>i

" Change font size keyboard shortcuts {{{
" keep default value
let s:current_font = &guifont

" command
command! -narg=0 ZoomIn    :call s:ZoomIn()
command! -narg=0 ZoomOut   :call s:ZoomOut()
command! -narg=0 ZoomReset :call s:ZoomReset()

" map
nmap <silent> <D-=> :ZoomIn<CR>
nmap <silent> <D--> :ZoomOut<CR>

" guifont size + 1
function! s:ZoomIn()
  let l:fsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
  let l:fsize += 1
  let l:guifont = substitute(&guifont, ':h\([^:]*\)', ':h' . l:fsize, '')
  let &guifont = l:guifont
endfunction

" guifont size - 1
function! s:ZoomOut()
  let l:fsize = substitute(&guifont, '^.*:h\([^:]*\).*$', '\1', '')
  let l:fsize -= 1
  let l:guifont = substitute(&guifont, ':h\([^:]*\)', ':h' . l:fsize, '')
  let &guifont = l:guifont
endfunction

" reset guifont size
function! s:ZoomReset()
  let &guifont = l:current_font
endfunction
" }}}

