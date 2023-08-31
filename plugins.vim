" vim: set fdm=marker fmr={{{,}}} fdl=0:

" AsyncRun and vim-terminal-help {{{
function! s:my_runner(opts)
  execute "1TermExec cmd='" .. a:opts.cmd .. "'"
endfunction
let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
let g:asyncrun_runner.send_toggleterm = function('s:my_runner')

let g:asynctasks_term_pos = 'send_toggleterm'  " Use the term-help plugin
let g:asyncrun_save = 2  " Save all files on run

" From vim-terminal-help
function! Terminal_view(mode)
  if a:mode == 0
    let w:__terminal_view__ = winsaveview()
  elseif exists('w:__terminal_view__')
    call winrestview(w:__terminal_view__)
    unlet w:__terminal_view__
  endif
endfunc

nnoremap <silent> <leader>r :AsyncTask file-run<cr>
nnoremap <silent> <leader>b :AsyncTask file-build<cr>
nnoremap <silent> <leader>T :AsyncTask test<cr>
" nnoremap <silent> <leader>R :H !!<CR>:H<CR>
" }}}

" MarkdownPreview {{{
" Don't close preview when changing away from the buffer
let g:mkdp_auto_close = 0
" }}}

" vim-closetag {{{
 " filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>' 
" }}}

" vsnip {{{
let g:vsnip_snippet_dir = "/Users/brendan-doney/Library/Application Support/Code/User/snippets"
" }}}

