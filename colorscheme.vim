" vim: set fdm=marker fmr={{{,}}} fdl=0:

"          Sonokai (colorscheme)
"==========================================
if has("termguicolors")
  set termguicolors
endif
" The configuration options should be placed before `colorscheme sonokai`.
let g:sonokai_style = "maia"
" let g:sonokai_style = "machine"
" Enable italics
let g:sonokai_enable_italic = 1
" Show more markers for lines with diagnostics
" let g:sonokai_diagnostic_line_highlight = 1
let g:sonokai_diagnostic_text_highlight = 1
" Make the sign column the same background as normal text
let g:sonokai_sign_column_background = 'none'
" Normally, colour is based on the type of diagonstic (hint, into, error, etc.)
let g:sonokai_diagnostic_virtual_text = 'grey'
" Make autocomplete green instead of blue
let g:sonokai_menu_selection_background = 'green'
" Don't show the end of buffer `~`s
let g:sonokai_show_eob = 0

" Disable terminal colors
let g:sonokai_disable_terminal_colors = 1

function! s:sonokai_custom() abort
  " Link a highlight group to a predefined highlight group.
  " See `colors/sonokai.vim` for all predefined highlight groups.

  " Initialize the color palette.
  " The parameter is a valid value for `g:sonokai_style`,
  let l:palette = sonokai#get_palette(g:sonokai_style, {})
  " Define a highlight group.
  " 1: name of a highlight group,
  " 2: foreground color,
  " 3: background color,
  " 4: UI highlighting which is optional,
  " 5: `guisp` which is also optional.
  " See `autooad/sonokai.vim` for the format of `l:palette`.
  " call sonokai#highlight('groupE', l:palette.red, l:palette.none, 'undercurl', l:palette.red)
  let l:lighter_grey_color = ['#B8C4C3', '250']
  call sonokai#highlight('LighterGrey', l:lighter_grey_color, l:palette.none, 'NONE')
  call sonokai#highlight('LighterGreyItalic', l:lighter_grey_color, l:palette.none, 'italic')

  " call sonokai#highlight('NvimTreeNormal', l:palette.fg, l:palette.black, 'NONE')

  " Make diff for modified lines show as orange
  let l:lighter_diff_yellow = ['#735e35', '56']
  call sonokai#highlight('DiffChange', l:palette.none, l:palette.diff_yellow)
  " call sonokai#highlight('DiffText', l:palette.bg0, l:palette.orange)
  call sonokai#highlight('DiffText', l:palette.none, l:lighter_diff_yellow)

  " Don't show text in foreground of diff deleted (it's always dashes, which is useless)
  call sonokai#highlight('DiffDelete', l:palette.diff_red, l:palette.diff_red)

  " Use orange signs for changes with GitGutter
  highlight! link GitGutterChange OrangeSign
  highlight! link GitGutterChangeDelete OrangeSign

  " Show hint text (e.g. Rust type hints) as grey
  highlight! link CocHintSign CocCodeLens

  " Show lightbulb sign as yellow
  highlight! link LightBulbSign LspDiagnosticsSignWarning

  " Treesitter {{{
  " For things like null
  highlight! link @const.builtin Purple
  " For parenthesis, curly brackets, etc.
  highlight! link @punct.bracket Grey
  " For package and import statements
  highlight! link @include RedItalic
  " " For constructors
  highlight! link @constructor TSFunction
  " \n and the like
  highlight! link @string.escape Purple

  " For `this` and more
  highlight! link @variable.builtin LighterGreyItalic

  " For titles in markdown
  highlight! link @text.title Yellow

  " For # markers in markdown
  highlight! link @punctuation.special Comment

  " For XML tags (HTML/JSX/TSX)
  highlight! link @tag Red
  highlight! link @tag.attribute Blue
  highlight! link @tag.delimiter Grey

  " For function parameters
  highlight! link @parameter Orange

  call sonokai#highlight('@text.literal', l:lighter_grey_color, l:palette.none)
  " }}}

  " Terminal {{{
  " Running in Neovide GUI, so need to set terminal colors
  if exists('g:neovide')
    " Black
    let g:terminal_color_0 = '#273136'
    let g:terminal_color_8 = '#6b7678'
    " Red
    let g:terminal_color_1 =  '#ff6d7e'
    let g:terminal_color_9 =  '#ff6d7e'
    " Green
    let g:terminal_color_2 =  '#a2e57b'
    let g:terminal_color_10 = '#a2e57b'
    " Yellow
    let g:terminal_color_3 =  '#ffed72'
    let g:terminal_color_11 = '#ffed72'
    " Blue
    let g:terminal_color_4 =  '#3879ef'
    let g:terminal_color_12 = '#3879ef'
    " Magenta
    let g:terminal_color_5 =  '#baa0f8'
    let g:terminal_color_13 = '#5e92f2'
    " Cyan
    let g:terminal_color_6 =  '#7cd5f1'
    let g:terminal_color_14 = '#baa0f8'
    " White
    let g:terminal_color_7 =  '#f2fffc'
    let g:terminal_color_15 = '#f2fffc'
  endif
  " }}}

  " Cmp {{{
  " Make completion icons match VSCode Dark+ theme
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080

  " Highlight matches in blue
  " highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  " highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6

  " Highlight matches in regular bold
  call sonokai#highlight("CmpItemAbbrMatch", l:palette.fg, l:palette.none, "bold")
  call sonokai#highlight("CmpItemAbbrMatchFuzzy", l:palette.fg, l:palette.none, "bold")

  " Abbreviation (e.g. method name) is grey for contrast with bold matching text
  call sonokai#highlight("CmpItemAbbr", l:lighter_grey_color, l:palette.none)

  " Light coloured selection background w/ yellow text for contrast (237 is from bg4)
  call sonokai#highlight('PmenuSel', l:palette.yellow, ["#63696e", '237'])
  " call sonokai#highlight('PmenuSel', l:palette.yellow, l:palette.bg4)

  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4

  " lua require("colorscheme").reverse_colors()
  call sonokai#highlight("CmpItemMenu", l:palette.grey, l:palette.none, "italic")
  " }}}

  " Barbar {{{
  " highlight! link TabLineSel Normal
  " highlight! link TabLineFill
  " highlight! link TabLineSel TabLineFill
  " " highlight! link BufferTabpageFill BufferInactive

  " let l:tablinefill_id = synIDtrans(hlID('TabLineFill'))
  " let l:normal_id = synIDtrans(hlID('Normal'))
  " execute "highlight! BufferTabpageFill" .
  "   \" ctermfg=" . synIDattr(l:tablinefill_id, 'fg', 'cterm') .
  "   \" ctermbg=" . synIDattr(l:normal_id, 'bg', 'cterm') .
  "   \" guifg=" . synIDattr(l:tablinefill_id, 'fg', 'gui') .
  "   \" guibg=" . synIDattr(l:normal_id, 'bg', 'gui')

   " Meaning of terms:
   "
   " format: "Buffer" + status + part
   "
   " status:
   "     *Current: current buffer
   "     *Visible: visible but not current buffer
   "    *Inactive: invisible but not current buffer
   "
   " part:
   "        *Icon: filetype icon
   "       *Index: buffer index
   "         *Mod: when modified
   "        *Sign: the separator between buffers
   "      *Target: letter in buffer-picking mode
   "
   " BufferTabpages: tabpage indicator
   " BufferTabpageFill: filler after the buffer section
   " BufferOffset: offset section, created with set_offset()
  " call sonokai#highlight('BufferCurrent', l:palette.fg, l:palette.bg4)
  " call sonokai#highlight('BufferCurrentIndex', l:palette.fg, l:palette.bg4)
  " call sonokai#highlight('BufferCurrentMod', l:palette.blue, l:palette.bg4)
  " call sonokai#highlight('BufferCurrentSign', l:palette.red, l:palette.bg4)
  " call sonokai#highlight('BufferCurrentTarget', l:palette.red, l:palette.bg4, 'bold')
  " call sonokai#highlight('BufferVisible', l:palette.fg, l:palette.bg2)
  " call sonokai#highlight('BufferVisibleIndex', l:palette.fg, l:palette.bg2)
  " call sonokai#highlight('BufferVisibleMod', l:palette.blue, l:palette.bg2)
  " call sonokai#highlight('BufferVisibleSign', l:palette.red, l:palette.bg2)
  " call sonokai#highlight('BufferVisibleTarget', l:palette.yellow, l:palette.bg2, 'bold')
  " call sonokai#highlight('BufferInactive', l:palette.grey, l:palette.bg2)
  " call sonokai#highlight('BufferInactiveIndex', l:palette.grey, l:palette.bg2)
  " call sonokai#highlight('BufferInactiveMod', l:palette.grey, l:palette.bg2)
  " call sonokai#highlight('BufferInactiveSign', l:palette.grey_dim, l:palette.bg2)
  " call sonokai#highlight('BufferInactiveTarget', l:palette.yellow, l:palette.bg2, 'bold')
  " call sonokai#highlight('BufferTabpages', l:palette.bg0, l:palette.blue, 'bold')
  " call sonokai#highlight('BufferTabpageFill', l:palette.bg0, l:palette.bg0)
  " call sonokai#highlight('BufferTabpageFill', l:palette.bg2, l:palette.bg2)
  " }}}

  if has("nvim-0.10.0")
    call sonokai#highlight('LspInlayHint', l:palette.grey, l:palette.bg1, 'NONE')
  endif
endfunction

augroup SonokaiCustom
  autocmd!
  autocmd ColorScheme sonokai call s:sonokai_custom()
augroup ENDl

colorscheme sonokai

