" vim: set fdm=marker fmr={{{,}}} fdl=0:

" Visual-Multi {{{
let g:VM_mouse_mappings   = 1
let g:VM_maps = {}
let g:VM_maps["Undo"]     = 'u'
let g:VM_maps["Redo"]     = '<C-r>'
let g:VM_leader = '<Space><Space>'
" }}}

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

" IndentBlankline {{{
let g:indentLine_char = '│'
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_filetype_exclude = [ "lspinfo", "packer", "checkhealth", "help", "man", "text", "startify", "NvimTree", "mason" ]                                                                         
let g:indent_blankline_buftype_exclude = [ "terminal", "nofile", "quickfix", "prompt" ]         
" let g:indent_blankline_show_current_context = v:true
let g:indent_blankline_show_trailing_blankline_indent = v:false
nnoremap <silent> <leader>i :IndentBlanklineRefresh<CR>
" }}}

" MarkdownPreview {{{
" Don't close preview when changing away from the buffer
let g:mkdp_auto_close = 0
" }}}

" Surround.vim {{{
" Bold and italics for markdown
let g:surround_{char2nr('i')} = "*\r*"
let g:surround_{char2nr('I')} = "**\r**"

" Markdown word formatting
nnoremap <silent> <leader>wi <Plug>YsurroundiW*
vnoremap <silent> <leader>wi <Plug>VSurround*
nnoremap <silent> <leader>wb <Plug>YsurroundiW*<Plug>YsurroundiW*
vnoremap <silent> <leader>wb <Plug>VSurround*gv<Plug>VSurround*
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

" Firenvim {{{
" Never turn on by default and use neovim's cmdline instead of the custom one
let g:firenvim_config = { 'localSettings': { '.*': { 'takeover': 'never', 'cmdline': 'neovim' } } }

if exists('g:started_by_firenvim')
  " Runs when firenvim starts

  " Don't actually do anything (maybe they will in future?)
  set laststatus=0
  set showtabline=0

  set guifont=LigaMenlo\ Nerd\ Font:h18
  set nonumber
  set wrap

  augroup firenvim_changes
    " This will work instead to change laststatus and tabline
    autocmd BufRead,BufNewFile * set laststatus=0 showtabline=0 

    autocmd BufEnter github.com_*.txt,gitlab.com_*.txt set filetype=markdown

    autocmd FileType text,markdown set spell
  augroup END
endif
" }}}

" vsnip {{{
let g:vsnip_snippet_dir = "/Users/brendan-doney/Library/Application Support/Code/User/snippets"
" }}}

