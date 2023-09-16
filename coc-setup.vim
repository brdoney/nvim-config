" vim: set fdm=marker fmr={{{,}}} fdl=0:

" Coc-fzf {{{
" Default to the way fzf normally looks
let g:coc_fzf_preview = ''
let g:coc_fzf_opts = []
" }}}

" Coc-pairs {{{
autocmd FileType html,xhtml,phtml,jsx let b:coc_pairs_disabled = ['<']
" }}}

" Extensions {{{
" Required extensions
let g:coc_global_extensions = ['coc-snippets', 'coc-pyright', 'coc-java',
  \ 'coc-rust-analyzer', 'coc-go', 'coc-json', 'coc-html', 'coc-css',
  \ 'coc-vimlsp', 'coc-vetur', 'coc-tsserver', 'coc-pairs']
" Until pyright fully fixes their markdown rendering
" let g:coc_markdown_disabled_languages = ['python']

" Autoinsert missing imports on save for Go
autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

" Emulate jsonc by providing comments in json (doesn't work with NERDCommenter)
autocmd FileType json syntax match Comment +\/\/.\+$+

" Wrap text with Markdown
autocmd FileType markdown,text setlocal wrap
" Syntax highlighting in the code fences (but doesn't use treesitter)
" let g:markdown_fenced_languages = ['python', 'java', 'c']

" }}}

" Keybindings {{{
" Remap for do codeAction of current line
nmap <leader>qa  <Plug>(coc-codeaction-cursor)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)
" Choose codelens action (e.g. run java code)
nmap <leader>ql  <Plug>(coc-codelens-action)

" Switch focus to floating window
nmap <leader>q<Space> <Plug>(coc-float-jump)

" Open link under cursor https://nerdfonts.com
nmap <leader>qk <Plug>(coc-openlink)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <leader>qr <Plug>(coc-rename)
" Refactor options (not sure what this is?)
nmap <leader>qe <Plug>(coc-refactor)
" Formatting selected code.
nmap <leader>f <Plug>(coc-format)
xmap <leader>f <Plug>(coc-format-selected)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Show all diagnostics.
" nnoremap <silent><nowait> <leader>qd :<C-u>CocList diagnostics<cr>
nnoremap <silent> <leader>qd :<C-u>CocFzfList diagnostics<cr>
" Manage extensions.
" nnoremap <silent><nowait> <leader>qx :<C-u>CocList extensions<cr>
nnoremap <silent> <leader>qx :<C-u>CocFzfList extensions<cr>
" Show commands.
" nnoremap <silent><nowait> <leader>qc :<C-u>CocList commands<cr>
nnoremap <silent> <leader>qc :<C-u>CocFzfList commands<cr>
" Find symbol of current document.
" nnoremap <silent><nowait> <leader>qo :<C-u>CocList outline<cr>
nnoremap <silent> <leader>qo :<C-u>CocFzfList outline<cr>
" Search workspace symbols.
" nnoremap <silent><nowait> <leader>qs :<C-u>CocList -I symbols<cr>
nnoremap <silent> <leader>qs :<C-u>CocFzfList symbols<cr>
" Do default action for next item.
" nnoremap <silent><nowait> <leader>qn :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent><nowait> <leader>qp :<C-u>CocPrev<CR>
" Resume latest coc list.
" nnoremap <silent><nowait> <leader>qp :<C-u>CocListResume<CR>
nnoremap <silent> <leader>qp :<C-u>CocFzfListResume<CR>
" }}}

" Status in command line {{{

function! RemoveCocStatus(...)
  let spc = g:airline_symbols.space
  " Useful for Rust, which floods airline with stuff b/c of coc-rust-analyzer
  let w:airline_section_c = airline#section#create(['%<', 'file', spc, 'readonly', 'lsp_progress'])
endfunction
nnoremap <silent> <leader>as :call airline#remove_statusline_func('RemoveCocStatus')<CR>
nnoremap <silent> <leader>ah :call airline#add_statusline_func('RemoveCocStatus')<CR>

" }}}

