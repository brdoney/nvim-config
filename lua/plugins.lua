-- vim: set fdm=marker fmr={{{,}}} fdl=0:

-- Scope.nvim {{{

require("scope").setup()

-- }}}

-- TreeSitter {{{
require('nvim-treesitter.configs').setup {
  ensureInstalled = "all",
  highlight = {
    enable = true,
  },
  -- Add to above to enable indenting using treesitter
  -- indent = {
  --   enable = false
  -- },
  -- From 'nvim-treesitter/nvim-treesitter-refactor'
  --refactor = {
  --  smart_rename = {
  --    enable = true,
  --    keymaps = {
  --      smart_rename = "grr",
  --    },
  --  },
  --},
  -- From JoosepAlviste/nvim-ts-context-commentstring
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  -- From windwp/nvim-ts-autotag
  autotag = {
    enable = true,
  }
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- Start at 99 so everything isn't folded up at the start
vim.opt.foldlevel = 99
vim.opt.foldnestmax = 10
-- Remove folds since treesitter will regenerate them each time anyway
-- (and sessions will preserve manual folding from past otherwise)
vim.opt.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,terminal"

-- }}}

-- Gitsigns -- Disabled {{{
-- require('gitsigns').setup {
--   current_line_blame = false,
--   linehl = false,
--   numhl = true,
-- }
-- }}}

-- Todo Comments -- Disabled {{{
-- require("todo-comments").setup {
--   signs = false,
-- }
-- }}}

-- Open URL {{{
-- Used because netrw is disabled, so we can't rely on its `gx` mapping

-- Utility function for mapping
local map = setmetatable({}, {
  __index = function(_, mode)
    return setmetatable({}, {
      __newindex = function(_, lhs, tbl)
        if tbl == nil then vim.api.nvim_del_keymap(mode, lhs); return end
        local rhs = table.remove(tbl, 1)
        local opts = {}
        for _, v in ipairs(tbl) do
          opts[v] = true
        end
        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
      end
    })
  end
})

-- URL handling
if vim.fn.has("mac") == 1 then
  map[''].gx = { '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>' }
elseif vim.fn.has("unix") == 1 then
  map[''].gx = { '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>' }
else
  map[''].gx = { '<Cmd>lua print("Error: gx is not supported on this OS!")<CR>' }
end
-- }}}

-- NvimTree {{{
require 'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  hijack_directories  = {
    enable = true,
    auto_open = true,
  },
  open_on_tab         = false,
  hijack_cursor       = true,
  sync_root_with_cwd  = true,
  diagnostics         = {
    enable = true,
    show_on_dirs = true,
    icons = { error = " ", warning = " ", hint = " ", info = " " }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open         = {
    cmd  = nil,
    args = {}
  },
  actions             = {
    open_file = {
      resize_window = true
    }
  },
  view                = {
    width = 30,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {
        { key = "K", action = "toggle_file_info" },
        -- Unbind <C-k>
        { key = "<C-k>", action = "" }
      }
    }
  },
  renderer            = {
    indent_markers = {
      enable = true
    },
    highlight_git = true,
    group_empty = true,
    add_trailing = true,
    icons = {
      glyphs = {
        git = {
          unstaged = '*',
        }
      }
    }
  }
}

local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

vim.keymap.set('n', '<leader>e', ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
-- vim.keymap.set('n', '<leader>ef', require('nvim-tree').find_file, { desc = "Show open file in NvimTree" })

-- Integrate with barbar so tabs start after tree
-- local nvim_tree_events = require('nvim-tree.events')
-- local bufferline_state = require('bufferline.state')
--
-- local function get_tree_size()
--   return require'nvim-tree.view'.View.width
-- end
-- nvim_tree_events.on_tree_open(function()
--   bufferline_state.set_offset(get_tree_size())
-- end)
--
-- nvim_tree_events.on_tree_resize(function()
--   bufferline_state.set_offset(get_tree_size())
-- end)
--
-- nvim_tree_events.on_tree_close(function()
--   bufferline_state.set_offset(0)
-- end)
-- }}}

-- WhichKey {{{
local wk = require("which-key")

wk.setup {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  operators = {},
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    ["<space>"] = "spc",
    ["<cr>"] = "",
    ["<tab>"] = "",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = '<c-d>', -- binding to scroll down inside the popup
    scroll_up = '<c-u>', -- binding to scroll up inside the popup
  },
  window = {
    border = "single", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "center", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

wk.register({
  c = {
    name = "conflict" -- optional group name
  },
  h = {
    name = "git"
  },
  q = {
    name = "lsp",
    w = {
      name = "workspace"
    }
  },
  s = {
    name = "search"
  },
  P = {
    name = 'project'
  },
  ["<Space>"] = {
    name = "VM"
  },
  w = {
    name = "word"
  },
  [";"] = { "Add ; to end of line" },
  m = { "Max height" },
  M = { "Max width" }
}, { prefix = "<leader>" })

wk.register({
  D = { "Go to declaration" },
  d = { "Go to definition" },
  r = { "Go to references" },
  i = { "Go to implementation" },
})

wk.register({
  q = {
    name = "lsp",
  },
}, { prefix = "<leader>", mode = "v" })
-- }}}

-- nvim-web-devicons {{{
local web = require("nvim-web-devicons")
web.setup {
  -- your personal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  -- override = {
  --  zsh = {
  --    icon = "",
  --    color = "#428850",
  --    cterm_color = "65",
  --    name = "Zsh"
  --  }
  -- };
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true;
}
-- }}}

-- Incline {{{
local function winbar_render(props)
  local bufname = vim.api.nvim_buf_get_name(props.buf)

  local res, extension
  if bufname ~= '' then
    res = vim.fn.fnamemodify(bufname, ':t')
    extension = vim.fn.matchstr(res, [[\v\.@<=\w+$]], '', '')
  else
    res = '[No Name]'
    extension = ''
  end

  local icon, _ = web.get_icon(res, extension, { default = true })
  res = icon .. ' ' .. res

  if vim.api.nvim_buf_get_option(props.buf, 'modified') then
    res = res .. ' '
  end
  return res
end

-- Only run when running base nvim (not in firenvim)
if not vim.g.started_by_firenvim then
  require('incline').setup {
    render = winbar_render,
    window = {
      margin = {
        horizontal = {
          left = 0,
          right = 0
        },
        vertical = {
          bottom = 0,
          top = 1
        }
      }
    },
  }
end

-- }}}

-- nvim-scrollbar {{{
require("scrollbar").setup({
  show_in_active_only = true,
  hide_if_all_visible = true, -- Hides everything if all lines are visible
  handle = {
    color = "#353f46",
  },
  marks = {
    Cursor = {
      text = "-",
    },
    Search = { color = "#f3a96a" },
    Error = { color = "#f76c7c" },
    Warn = { color = "#e3d367" },
    Info = { color = "#78cee9" },
    Hint = { color = "#9cd57b" },
    Misc = { color = "#baa0f8" },
  }
})
-- }}}

-- Comment.nvim {{{
require('Comment').setup {
  -- Integrate with nvim-ts-context-commentstring
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}

vim.keymap.set('n', '<C-_>', require("Comment.api").toggle.linewise.current, { desc = 'Toggle comment' })
-- vim.keymap.set('i', '<C-_>', function()
--   require("Comment.api").toggle.linewise.current()
--   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>A", true, false, true), "m", true)
-- end, { desc = 'Toggle comment' })

local comft = require("Comment.ft");
comft.set("llvm", ";%s")

-- Modeled after insert mode command under NERDCommenter
local comapi = require("Comment.api")
local function imode_comment()
  local curr_line = vim.api.nvim_get_current_line()
  -- vim.pretty_print(curr_line)
  if curr_line ~= nil and curr_line:match('^%s*$') then
    -- Empty
    local input = vim.api.nvim_replace_termcodes("x<Esc>gccA<BS>", true, true, true)
    vim.api.nvim_feedkeys(input, "m", true)
  else
    -- Not empty
    local pos = vim.api.nvim_win_get_cursor(0)
    local prevlen = curr_line:len()

    comapi.toggle.linewise.current()

    curr_line = vim.api.nvim_get_current_line()
    local newlen = curr_line:len()

    if curr_line ~= nil and curr_line:match('^%s*$') then
      -- It's empty, so re-indent using `S`
      vim.cmd [[ stopinsert ]]
      vim.api.nvim_feedkeys("S", "m", false)
    else
      -- It's not empty, so just use I to get back to the beginning
      local diff = prevlen - newlen

      -- vim.api.nvim_win_set_cursor(0, {row - diff, col})
      pos[2] = pos[2] - diff
      vim.api.nvim_win_set_cursor(0, pos)
    end
  end
end

-- vim.keymap.set('i', '<C-_>', '<Esc>gcA', { remap = true, desc = 'Toggle comment' })
vim.keymap.set('i', '<C-_>', imode_comment, { remap = true, desc = 'Toggle comment' })

-- Stay in visual mode after the toggle
vim.keymap.set('x', '<C-_>', 'gcgv', { remap = true, desc = 'Toggle comment' })
-- }}}

-- File picker script {{{
local function pickFile()
  local output = vim.fn.system("~/Developer/Swift/NvimFilePicker/.build/release/NvimFilePicker")

  -- Do nothing if it wasn't succesful
  if vim.v.shell_error == 1 then
    print(output)
    return
  end

  -- Get rid of trailing new line
  output = vim.trim(output)

  -- Close the current session (if open) and open the folder
  vim.cmd [[ SClose ]]
  vim.cmd('e ' .. output)
end

vim.keymap.set('n', '<leader>Po', pickFile, { desc = 'Folder picker' })
vim.keymap.set('n', '<leader>Pq', ":SClose<CR>", { desc = 'Close sessions' })
-- }}}

-- vim-easy-align {{{
vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', { remap = true, desc = 'Easy align' })
vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', { remap = true, desc = 'Easy align' })

local eagroup = vim.api.nvim_create_augroup('EasyAlignMappings', {})
vim.api.nvim_create_autocmd('FileType', { pattern = 'markdown', group = eagroup, callback = function()
  -- vim.keymap.set('n', '<leader>f', ':%EasyAlign*<Bar><Enter>', { desc = 'Format tables' })
  vim.keymap.set('x', '<leader>f', ':EasyAlign*<Bar><Enter>gv', { desc = 'Format tables' })
  vim.wo.wrap = true
end })
-- }}}

-- Distant -- disabled b/c not working {{{
-- require('distant').setup {
--   -- Applies Chip's personal settings to every machine you connect to
--   --
--   -- 1. Ensures that distant servers terminate with no connections
--   -- 2. Provides navigation bindings for remote directories
--   -- 3. Provides keybinding to jump into a remote file's parent directory
--   ['*'] = require('distant.settings').chip_default()
-- }
-- }}}

-- Autolist {{{
local autolist_startup = function()
  local autolist = require("autolist")
  autolist.setup()
  autolist.create_mapping_hook("i", "<CR>", autolist.new)
  autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
  autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
  autolist.create_mapping_hook("n", "o", autolist.new)
  autolist.create_mapping_hook("n", "O", autolist.new_before)
  autolist.create_mapping_hook("n", ">>", autolist.indent)
  autolist.create_mapping_hook("n", "<<", autolist.indent)
  autolist.create_mapping_hook("n", "<C-r>", autolist.force_recalculate)
  autolist.create_mapping_hook("n", "<leader>x", autolist.invert_entry, "")
  -- vim.api.nvim_create_autocmd("TextChanged", {
  --   pattern = "*",
  --   callback = function()
  --     vim.cmd.normal({ autolist.force_recalculate(nil, nil), bang = false })
  --   end
  -- })
end

vim.keymap.set('n', '<leader>l', autolist_startup, { desc = 'Nabla popup' })

-- local autolist_group = vim.api.nvim_create_augroup("autolist", {})
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "markdown", "text" },
--   group = autolist_group,
--   callback = autolist_startup
-- })
-- }}}

-- Nabla.nvim {{{
-- nnoremap <leader>p :lua require("nabla").popup()<CR> " Customize with popup({border = ...})  : `single` (default), `double`, `rounded`
vim.keymap.set('n', '<leader>wp', require('nabla').popup, { desc = 'Nabla popup' })
-- local nabla_enabled = false
-- vim.keymap.set('n', '<leader>wv', function()
--   if nabla_enabled then
--     require('nabla').enable_virt()
--   else
--     require('nabla').disable_virt()
--   end
--   nabla_enabled = not nabla_enabled
-- end, { desc = 'Toggle Nabla virt' })
-- }}}

-- BQF {{{
require('bqf').setup({
  auto_resize_height = true,
})
-- }}}

-- git-conflict.nvim {{{
require('git-conflict').setup({
  default_mappings = false,
  disable_diagnostics = true,
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'DiffDelete',
    current = 'DiffAdd',
  }
})

vim.keymap.set('n', '<leader>co', '<Plug>(git-conflict-ours)')
vim.keymap.set('n', '<leader>ct', '<Plug>(git-conflict-theirs)')
vim.keymap.set('n', '<leader>cb', '<Plug>(git-conflict-both)')
vim.keymap.set('n', '<leader>c0', '<Plug>(git-conflict-none)')
vim.keymap.set('n', '[x', '<Plug>(git-conflict-prev-conflict)')
vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)')
-- }}}

-- vim-llvm {{{
-- " e.g. Map 'go to definition' to gd
-- autocmd FileType llvm nmap <buffer><silent>gd <Plug>(llvm-goto-definition)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "llvm",
  callback = function()
    vim.keymap.set("n", "gd", "<Plug>(llvm-goto-definition)", { buffer = true, silent = true })
  end
})
-- }}}

-- vim-dadbod {{{
vim.g.db_ui_save_location = vim.fn.stdpath "config" .. require("plenary.path").path.sep .. "db_ui"

local function db_completion()
  require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "sql",
    "mysql",
    "plsql",
  },
  callback = function()
    vim.schedule(db_completion)
  end,
})
require('cmp').setup.buffer({ sources = { { name = 'vim-dadbod-completion' } } })
-- }}}

-- smart-splits.nvim {{{
require("smart-splits").setup()
vim.keymap.set("n", "<C-w>r", require('smart-splits').start_resize_mode, { desc = "Start buffer resize mode" });
-- }}}

-- toggleterm {{{
require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return math.floor(vim.o.lines * 0.3)
    elseif term.direction == "vertical" then
      return math.floor(vim.o.columns * 0.3)
    end
  end,
  open_mapping = [[<M-=>]],
  persist_size = false,
  shade_terminals = false,
  highlights = {
    -- Same as Telescope
    FloatBorder = { link = "Grey" }
  },
  float_opts = {
    border = 'curved',
    -- Width and height match Telescope's
    width = function()
      return math.floor(vim.o.columns * 0.8)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.9)
    end,
  }
})
-- nnoremap <silent> <leader>R :H !!<CR>:H<CR>
vim.keymap.set("n", "<leader>R", ':TermExec cmd="!!"<CR>:TermExec cmd=""<CR>', { desc = "Repeat last command",
  silent = true })
-- }}}

-- Barbar {{{
require("barbar").setup({
  insert_at_end = true,
  icons = {
    modified = {
      button = ""
    }
  }
})

local function barbarmap(key, command, desc)
  local opts = { silent = true, noremap = true, desc = desc }
  vim.keymap.set("n", key, command, opts)
end

-- Barbar operations
barbarmap("<leader>p", ":BufferPick<CR>", "Pick buffer")
barbarmap("<leader>[", ":BufferPrevious<CR>", "Previous buffer")
barbarmap("<leader>]", ":BufferNext<CR>", "Next buffer")
barbarmap("<leader>{", ":BufferMovePrevious<CR>", "Move buffer left")
barbarmap("<leader>}", ":BufferMoveNext<CR>", "Move buffer right")
barbarmap("<leader>\\", ":BufferClose<CR>", "Close buffer")

-- Tabpage operations
barbarmap("<leader>tt", ":tabnew<CR>", "Open new tab")
barbarmap("<leader>t[", ":tabprevious<CR>", "Previous tab")
barbarmap("<leader>t]", ":tabnext<CR>", "Next tab")
barbarmap("<leader>|", ":tabclose<CR>", "Close tab")
-- }}}
