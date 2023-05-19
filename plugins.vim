" vim: set fdm=marker fmr={{{,}}} fdl=0:

" FZF {{{
" Keybindings terminal (conflicts with FZF, so special handling is needed)
" tnoremap <Esc> <C-\><C-n>
" tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"

" Normal FZF searches
" nmap <silent> <C-p> :Files<CR>
" nmap <silent> <leader>sg :GFiles<CR>
" nmap <silent> <leader>sG :GFiles?<CR>
" nmap <silent> <leader>sl :Lines<CR>
" nmap <silent> <leader>sL :BLines<CR>
" nmap <silent> <leader>sb :Buffers<CR>
" nmap <silent> <leader>sf :Filetypes<CR>
" nmap <silent> <leader>sm :Marks<CR>
" nmap <silent> <leader>sh :History:<CR>

" Search for a specific thing in every file in the current directory
" nmap <leader>sr :Rg 

" Session Picker {{{
" function! s:session_handler(lines)
"   call startify#session_load(0, a:lines[1])
" endfunction
" 
" function! s:fzf_sessions()
"   let dir = substitute(expand(startify#get_session_path()), '/*$', '/', '')
"   let wrapped = fzf#wrap('sessions', { 'source': startify#session_list(''), 'dir': dir }, 0)
"   let wrapped['sink*'] = function('s:session_handler')
"   return fzf#run(wrapped)
" endfunction
" 
" command! Sessions call <SID>fzf_sessions()
" nmap <silent> <leader>ss :Sessions<CR>
" }}}
" }}}

" Barbar {{{
" map <silent> <leader>cbp :bp<CR>
" map <silent> <leader>cbn :bn<CR>
" NOTE: If barbar's option dict isn't created yet, create it
" let bufferline = get(g:, 'bufferline', {})
" let bufferline.tabpages = v:true
"
" let g:bufferline.icon_close_tab_modified = ''

" nnoremap <silent> <Left> :BufferPrevious<CR>
" nnoremap <silent> <Right> :BufferNext<CR>
" nnoremap <silent> <S-Down> :BufferClose<CR>
" nnoremap <silent> <leader>p :BufferPick<CR>
" nnoremap <silent> <leader>[ :BufferPrevious<CR>
" nnoremap <silent> <leader>] :BufferNext<CR>
" nnoremap <silent> <leader>{ :BufferMovePrevious<CR>
" nnoremap <silent> <leader>} :BufferMoveNext<CR>
" nnoremap <silent> <leader>\ :BufferClose<CR>

" Close current tab
" nnoremap <silent> <leader>tt :tabnew<CR>
" nnoremap <silent> <leader>t[ :tabprevious<CR>
" nnoremap <silent> <leader>t] :tabnext<CR>
" nnoremap <silent> <leader>\| :tabclose<CR>
" nnoremap <silent> <leader>| :BufferClose!<CR>
" }}}

" Visual-Multi {{{
let g:VM_mouse_mappings   = 1
let g:VM_maps = {}
let g:VM_maps["Undo"]     = 'u'
let g:VM_maps["Redo"]     = '<C-r>'
let g:VM_leader = '<Space><Space>'
" }}}

" NERDTree -- Disabled {{{
" Show hidden files in tree
" let NERDTreeShowHidden=1
" " Hide the help label when starting the tree
" let NERDTreeMinimalUI=1
" " Show shortened name for directories with only one child
" let NERDTreeCascadeSingleChildDir=1
" " Autoexpand directories with only one child (useful for Java)
" let NERDTreeCascadeOpenSingleChildDir=1

" nnoremap <silent> <leader>e :NERDTreeToggle<CR>
" }}}

" NERDCommenter -- Disabled {{{
" Map Ctrl+/ to comment
" nnoremap <C-_> <Plug>NERDCommenterToggle
" xnoremap <C-_> <Plug>NERDCommenterToggle
" 
" function! InsertModeComment()
"   " echomsg '"'..getline('.')..'"'
"   if getline('.') =~ '^\s*$'
"     " echomsg 'Empty'
"     " execute "normal \<Plug>NERDCommenterInsert"
"     call feedkeys("\<Plug>NERDCommenterInsert")
"   else
"     " echomsg 'Not Empty'
"     " call feedkeys("\<Plug>NERDCommenterToggle")
"     execute "normal \<Plug>NERDCommenterToggle"
"   endif
" endfunc
" " x<BS> to keep autoindent from removing spaces on <C-o> for empty lines
" " Have to use <C-o> and call b/c <expr> can't modify buffer (just return text to modify),
" " which NERDCommenterToggle does
" inoremap <silent> <C-_> x<BS><C-o>:call InsertModeComment()<CR>
" " inoremap <C-_> <Plug>NERDCommenterInsert
" 
" " Add spaces after comment delimiters by default
" let g:NERDSpaceDelims = 1
" " Allow commenting and inverting empty lines (useful when commenting a region)
" let g:NERDCommentEmptyLines = 1
" " Align line-wise comment delimiters flush left instead of following code indentation
" let g:NERDDefaultAlign = 'left'
" " Python's default delimeter includes a space, which messed w/ SpaceDelims, so
" " change it here (it will still result in a space b/c of SpaceDelims)
" let g:NERDCustomDelimiters = {'python': {'left': '#'}}
" }}}

" Startify {{{
function s:courses()
  return [
    \ { 'line': 'CS 5754 Virtual Environments', 'cmd': 'SLoad virtualenvs'},
    \ { 'line': 'CS 5544 Compiler Optimisations', 'cmd': 'SLoad compileropts'},
    \ { 'line': 'CS 5614 Big Data Engineering', 'cmd': 'SLoad bigdata'},
    \ { 'line': 'CS 5944 Graduate Seminar', 'cmd': 'SLoad gradseminar'},
    \ { 'line': 'CS 5024 Ethics and Professionalism', 'cmd': 'SLoad cs5024notes'},
    \ { 'line': 'Research', 'cmd': 'SLoad csg-notes'},
    \ ]
endfunction

function s:research()
  return [
    \ { 'line': 'Notes', 'cmd': 'SLoad csg-notes'},
    \ { 'line': 'Backend', 'cmd': 'SLoad csgserver'},
    \ { 'line': 'Frontend', 'cmd': 'SLoad csgfrontend'},
    \ ]
endfunction

" if hostname()
if match(hostname(), "BrdMPro.local") >= 0
  let s:brdmpro_lists = [
      \ { 'type': function('s:courses'),  'header': ['   Courses']},
      \ { 'type': function('s:research'),  'header': ['   CSGenome']},
      \ ]
else
  let s:brdmpro_lists = []
endif

let g:startify_lists = s:brdmpro_lists + [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" Autoload Session.vim when found in a directory
let g:startify_session_autoload = 1
" Automatically save sessions when exiting editor
let g:startify_session_persistence = 1
" Sort sessions by modification time instead of alphabetically
let g:startify_session_sort = 1
" Close NERDTree before saving session because saving with it causes errors on
" session open
" let g:startify_session_before_save = [ 'silent! tabdo NERDTreeClose', 'silent! tabdo call TerminalClose()', 'silent! tabdo call CloseFugitiveIfOpen()' ]
let g:startify_session_before_save = [
\ 'silent! tabdo cclose',
\ 'silent! tabdo NvimTreeClose',
\ 'silent! tabdo call TerminalClose()',
\ 'silent! tabdo call CloseFugitiveIfOpen()',
\ 'silent! tabdo lua require("incline").disable()',
\ 'silent! tabdo TroubleClose',
\ 'silent! tabdo lua require("fidget").close()',
\ 'silent! tabdo CloseFloatingWindows'
\ ]
" Just to make cowsay look pretty
let g:startify_fortune_use_unicode = 1
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

" WhichKey {{{
" call which_key#register('<Space>', "g:which_key_map")
" nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
" vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
set timeoutlen=500
" let g:which_key_map = {
"       \ 'r': 'run',
"       \ 'b': 'build',
"       \ 'f': 'format',
"       \ }
" let g:which_key_map.c = { 'name' : '+comment' }
" let g:which_key_map.s = { 'name' : '+search'}
" let g:which_key_map.h = { 'name' : '+git' }
" let g:which_key_map.t = { 'name' : '+test' }
" let g:which_key_map.q = { 'name' : '+coc' }
" let g:which_key_map.q.l = { 'name' : '+list' }
" let g:which_key_map.m = { 'name' : '+minimap' }
" let g:which_key_map[' '] = { 'name' : '+multi' }
" }}}

" Minimap -- Disabled {{{
" map <leader>mt :MinimapToggle<CR>
" map <leader>mr :MinimapRefresh<CR>
" }}}

" Devicons {{{
let g:WebDevIconsOS = 'Darwin'
" }}}

" Gitgutter {{{
" g:gitgutter_highlight_linenrs  switch this when going into diff
let g:gitgutter_sign_added              = '┃'
let g:gitgutter_sign_modified           = '┃'
let g:gitgutter_sign_removed            = '┃'
let g:gitgutter_sign_removed_first_line = '╹'
let g:gitgutter_sign_removed_above_and_below = '║'
let g:gitgutter_sign_modified_removed   = '║'
nnoremap <leader>hh <Plug>(GitGutterPreviewHunk)
" }}}

" IndentBlankline {{{
let g:indentLine_char = '│'
let g:indent_blankline_use_treesitter = v:true
let g:indent_blankline_filetype_exclude = ['help', 'text', 'startify', 'NvimTree']
let g:indent_blankline_buftype_exclude = ['terminal']
" let g:indent_blankline_show_current_context = v:true
let g:indent_blankline_show_trailing_blankline_indent = v:false
nnoremap <silent> <leader>i :IndentBlanklineRefresh<CR>
" }}}

" EditorConfig {{{
" Required to work with fugitive
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
" }}}

" Fugitive {{{
" let g:fugitive_buf = 0
" let g:fugitive_win = 0
" function! FugitiveToggle(width)
"   if win_gotoid(g:fugitive_win)
"     " Window is already visible, so close it
"     quit
"   else
"     " Fugitive summary is not open, so create it
"     topleft Gvsplit :
"     exec "vertical resize " . a:width
"     let g:fugitive_buf = bufnr("")
"     setlocal nobuflisted
" 
"     " Disable everything except sign column (gives a little padding)
"     set wrap
"     set nonumber
"     set norelativenumber
"     " set signcolumn=no
" 
"     " Update the window id for closing later
"     let g:fugitive_win = win_getid()
"   endif
" endfunction
" 
" function! CloseFugitiveIfOpen()
"   if win_gotoid(g:fugitive_win)
"     quit
"   endif
" endfunction
" noremap <silent> <leader>G :call FugitiveToggle(31)<CR>

function! OpenFugitive()
  tab G
  set winheight=10
  set winminheight=10
endfunction

nnoremap <silent> <leader>G :call OpenFugitive()<CR>
" }}}

" MarkdownPreview -- Disabled {{{
" Don't close preview when changing away from the buffer
let g:mkdp_auto_close = 0
" }}}

" Goyo and Limelight {{{
let g:goyo_height = "100%"
" let g:goyo_width = 90
" Toggle Limelight and Goyo on keypress
nnoremap <silent> <leader>z :Goyo<CR>
" nmap <silent> <leader>l :Limelight!!<CR>
" }}}

" Bullets.vim -- Disabled {{{
" let g:bullets_enabled_file_types = ['markdown']
" " Don't add extra padding to align bullets
" let g:bullets_pad_right = 0
" " Don't have different items for each outline level
" let g:bullets_outline_levels = []
" " Disable default bindings, since they conflict with COC.nvim
" " This might be easier later, see https://github.com/dkarter/bullets.vim/issues/74
" let g:bullets_set_mappings = 0
" " See ./ftplugin/markdown_mappings.vim for more
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

" Targets.vim {{{
" Use n and N for next and previous instead of n and l
let g:targets_nl = 'nN'
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

" Terminal-help {{{
let g:terminal_pos="botright"
" let g:terminal_edit="tab drop"
" Open at current working directory instead of project root (which will find .git/)
let g:terminal_cwd=0
" }}}

" vsnip {{{
let g:vsnip_snippet_dir = "/Users/brendan-doney/Library/Application Support/Code/User/snippets"
" }}}

