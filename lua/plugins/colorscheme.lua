-- vim: set fdm=marker fmr={{{,}}} fdl=0:

local function link(color, to)
  -- 0 means this will be globlal
  vim.api.nvim_set_hl(0, color, { link = to })
end

---Sets a highlight group globally
---@param name string the name of the highlight group to set
---@param data vim.api.keyset.highlight the highlight data from |nvim_set_hl()|
local function set_hl(name, data)
  vim.api.nvim_set_hl(0, name, data)
end

local function sonokai_custom()
  -- Link a highlight group to a predefined highlight group.
  -- See `colors/sonokai.vim` for all predefined highlight groups.

  -- Initialize the color palette.
  local config = vim.fn['sonokai#get_configuration']()
  local palette = vim.fn['sonokai#get_palette'](config.style, config.colors_override)

  local sonokai_hl = vim.fn['sonokai#highlight']
  -- Define a highlight group.
  -- 1: name of a highlight group,
  -- 2: foreground color,
  -- 3: background color,
  -- 4: UI highlighting which is optional,
  -- 5: `guisp` which is also optional.
  -- See `autooad/sonokai.vim` for the format of `palette`.
  -- sonokai_hl('groupE', palette.red, palette.none, 'undercurl', palette.red)
  local lighter_grey_color = { '#B8C4C3', '250' }
  sonokai_hl('LighterGrey', lighter_grey_color, palette.none, 'NONE')
  sonokai_hl('LighterGreyItalic', lighter_grey_color, palette.none, 'italic')

  -- sonokai_hl('NvimTreeNormal', palette.fg, palette.black, 'NONE')

  -- Make diff for modified lines show as orange
  local lighter_diff_yellow = { '#735e35', '56' }
  sonokai_hl('DiffChange', palette.none, palette.diff_yellow)
  -- sonokai_hl('DiffText', palette.bg0, palette.orange)
  sonokai_hl('DiffText', palette.none, lighter_diff_yellow)

  -- Don't show text in foreground of diff deleted (it's always dashes, which is useless)
  sonokai_hl('DiffDelete', palette.diff_red, palette.diff_red)

  -- Use orange signs for changes with GitGutter
  link("GitGutterChange", "OrangeSign")
  link("GitGutterChangeDelete", "OrangeSign")

  -- Use orange for changes in lualine
  link("LuaLineDiffChange", "OrangeSign")

  -- Show hint text (e.g. Rust type hints) as grey
  link("CocHintSign", "CocCodeLens")

  -- Show lightbulb sign as yellow
  link("LightBulbSign", "LspDiagnosticsSignWarning")

  -- Window bar for nvim-navic
  link("WinBar", "Normal")
  link("WinBarNC", "NormalNC")

  -- Treesitter {{{
  -- For things like null
  link("@const.builtin", "Purple")
  -- For parenthesis, curly brackets, etc.
  link("@punct.bracket", "Grey")
  -- For package and import statements
  link("@include", "RedItalic")
  -- -- For constructors
  link("@constructor", "TSFunction")
  -- \n and the like
  link("@string.escape", "Purple")

  -- For `this` and more
  link("@variable.builtin", "LighterGreyItalic")

  -- For - markers in markdown
  -- link("@punctuation.special", "Comment")
  link("@markup.list.markdown", "Comment")

  -- For XML tags (HTML/JSX/TSX)
  link("@tag", "Red")
  link("@tag.tsx", "Red")
  link("@tag.attribute", "Blue")
  link("@tag.delimiter", "Grey")

  -- For function parameters
  link("@parameter", "Orange")

  -- sonokai_hl('@text.literal', lighter_grey_color, palette.none)
  sonokai_hl('@markup.raw.markdown_inline', lighter_grey_color, palette.none)
  sonokai_hl('@markup.raw.delimiter.markdown_inline', lighter_grey_color, palette.none)
  -- }}}

  -- Neovide Terminal {{{
  -- Running in Neovide GUI, so need to set terminal colors
  if vim.fn.exists('g:neovide') == 1 then
    -- Black
    vim.g.terminal_color_0 = '#273136'
    vim.g.terminal_color_8 = '#6b7678'
    -- Red
    vim.g.terminal_color_1 = '#ff6d7e'
    vim.g.terminal_color_9 = '#ff6d7e'
    -- Green
    vim.g.terminal_color_2 = '#a2e57b'
    vim.g.terminal_color_10 = '#a2e57b'
    -- Yellow
    vim.g.terminal_color_3 = '#ffed72'
    vim.g.terminal_color_11 = '#ffed72'
    -- Blue
    vim.g.terminal_color_4 = '#3879ef'
    vim.g.terminal_color_12 = '#3879ef'
    -- Magenta
    vim.g.terminal_color_5 = '#baa0f8'
    vim.g.terminal_color_13 = '#5e92f2'
    -- Cyan
    vim.g.terminal_color_6 = '#7cd5f1'
    vim.g.terminal_color_14 = '#baa0f8'
    -- White
    vim.g.terminal_color_7 = '#f2fffc'
    vim.g.terminal_color_15 = '#f2fffc'
  end
  -- }}}

  -- Cmp {{{
  -- Make completion icons match VSCode Dark+ theme
  -- gray
  set_hl("CmpItemAbbrDeprecated", { fg = "#808080", bg = "NONE", strikethrough = true })
  -- highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080

  -- Highlight matches in blue
  -- set_hl("CmpItemAbbrMatch", { fg = "#569CD6", bg = "NONE" })
  -- set_hl("CmpItemAbbrMatchFuzzy", { fg = "#569CD6", bg = "NONE" })

  -- Highlight matches in regular bold
  sonokai_hl("CmpItemAbbrMatch", palette.fg, palette.none, "bold")
  sonokai_hl("CmpItemAbbrMatchFuzzy", palette.fg, palette.none, "bold")

  -- Abbreviation (e.g. method name) is grey for contrast with bold matching text
  sonokai_hl("CmpItemAbbr", lighter_grey_color, palette.none)

  -- Light coloured selection background w/ yellow text for contrast (237 is from bg4)
  sonokai_hl('PmenuSel', palette.yellow, { "#63696e", '237' })
  -- sonoaki_hl('PmenuSel', palette.yellow, palette.bg4)

  -- light blue
  set_hl("CmpItemKindVariable", { fg = "#9CDCFE", bg = "NONE" })
  set_hl("CmpItemKindInterface", { fg = "#9CDCFE", bg = "NONE" })
  set_hl("CmpItemKindText", { fg = "#9CDCFE", bg = "NONE" })
  -- pink0,
  set_hl("CmpItemKindFunction", { fg = "#C586C0", bg = "NONE" })
  set_hl("CmpItemKindMethod", { fg = "#C586C0", bg = "NONE" })
  -- fron0, t
  set_hl("CmpItemKindKeyword", { fg = "#D4D4D4", bg = "NONE" })
  set_hl("CmpItemKindProperty", { fg = "#D4D4D4", bg = "NONE" })
  set_hl("CmpItemKindUnit", { fg = "#D4D4D4", bg = "NONE" })

  -- lua require("colorscheme").reverse_colors()
  sonokai_hl("CmpItemMenu", palette.grey, palette.none, "italic")
  -- }}}

  -- Barbar {{{
  -- link("TabLineSel", "Normal")
  -- highlight! link TabLineFill
  -- link("TabLineSel", "TabLineFill")
  -- -- link("BufferTabpageFill", "BufferInactive")

  -- let tablinefill_id = synIDtrans(hlID('TabLineFill'))
  -- let normal_id = synIDtrans(hlID('Normal'))
  -- execute "highlight! BufferTabpageFill-- .
  --   \-- ctermfg=-- . synIDattr(tablinefill_id, 'fg', 'cterm') .
  --   \-- ctermbg=-- . synIDattr(normal_id, 'bg', 'cterm') .
  --   \-- guifg=-- . synIDattr(tablinefill_id, 'fg', 'gui') .
  --   \-- guibg=-- . synIDattr(normal_id, 'bg', 'gui')

  -- Meaning of terms:
  --
  -- format: "Buffer-- + status + part
  --
  -- status:
  --     *Current: current buffer
  --     *Visible: visible but not current buffer
  --    *Inactive: invisible but not current buffer
  --
  -- part:
  --        *Icon: filetype icon
  --       *Index: buffer index
  --         *Mod: when modified
  --        *Sign: the separator between buffers
  --      *Target: letter in buffer-picking mode
  --
  -- BufferTabpages: tabpage indicator
  -- BufferTabpageFil filler after the buffer section
  -- BufferOffset: offset section, created with set_offset()
  -- sonokai_hl('BufferCurrent', palette.fg, palette.bg4)
  -- sonokai_hl('BufferCurrentIndex', palette.fg, palette.bg4)
  -- sonokai_hl('BufferCurrentMod', palette.blue, palette.bg4)
  -- sonokai_hl('BufferCurrentSign', palette.red, palette.bg4)
  -- sonokai_hl('BufferCurrentTarget', palette.red, palette.bg4, 'bold')
  -- sonokai_hl('BufferVisible', palette.fg, palette.bg2)
  -- sonokai_hl('BufferVisibleIndex', palette.fg, palette.bg2)
  -- sonokai_hl('BufferVisibleMod', palette.blue, palette.bg2)
  -- sonokai_hl('BufferVisibleSign', palette.red, palette.bg2)
  -- sonokai_hl('BufferVisibleTarget', palette.yellow, palette.bg2, 'bold')
  -- sonokai_hl('BufferInactive', palette.grey, palette.bg2)
  -- sonokai_hl('BufferInactiveIndex', palette.grey, palette.bg2)
  -- sonokai_hl('BufferInactiveMod', palette.grey, palette.bg2)
  -- sonokai_hl('BufferInactiveSign', palette.grey_dim, palette.bg2)
  -- sonokai_hl('BufferInactiveTarget', palette.yellow, palette.bg2, 'bold')
  -- sonokai_hl('BufferTabpages', palette.bg0, palette.blue, 'bold')
  -- sonokai_hl('BufferTabpageFill', palette.bg0, palette.bg0)
  -- sonokai_hl('BufferTabpageFill', palette.bg2, palette.bg2)
  -- }}}

  if vim.fn.has("nvim-0.10.0") == 1 then
    sonokai_hl('LspInlayHint', palette.grey, palette.bg1, 'NONE')
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('custom_highlights_sonokai', {}),
  pattern = 'sonokai',
  callback = sonokai_custom
})


return {
  -- Syntax highlighting
  {
    'sainnhe/sonokai',
    priority = 1000,
    init = function()
      -- The configuration options should be placed before `colorscheme sonokai`.
      vim.g.sonokai_style = "maia"
      -- Enable italics
      vim.g.sonokai_enable_italic = 1
      -- Show more markers for lines with diagnostics
      vim.g.sonokai_diagnostic_text_highlight = 1
      -- Make the sign column the same background as normal text
      vim.g.sonokai_sign_column_background = 'none'
      -- Normally, colour is based on the type of diagonstic (hint, into, error, etc.)
      vim.g.sonokai_diagnostic_virtual_text = 'grey'
      -- Make autocomplete green instead of blue
      vim.g.sonokai_menu_selection_background = 'green'
      -- Don't show the end of buffer `~`s
      vim.g.sonokai_show_eob = 0
      -- Disable terminal colors
      vim.g.sonokai_disable_terminal_colors = 1
    end,
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme sonokai]])
    end,
  },
}
