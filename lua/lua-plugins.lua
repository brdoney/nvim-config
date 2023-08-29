-- vim: set fdm=marker fmr={{{,}}} fdl=0:

-- TreeSitter {{{
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
        if tbl == nil then
          vim.api.nvim_del_keymap(mode, lhs); return
        end
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
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  group = eagroup,
  callback = function()
    -- vim.keymap.set('n', '<leader>f', ':%EasyAlign*<Bar><Enter>', { desc = 'Format tables' })
    vim.keymap.set('x', '<leader>f', ':EasyAlign*<Bar><Enter>gv', { desc = 'Format tables' })
    vim.wo.wrap = true
  end
})
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

-- git-conflict.nvim {{{
require('git-conflict').setup({
  default_mappings = false,
  disable_diagnostics = true,
  highlights = {
    -- They must have background color, otherwise the default color will be used
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
vim.keymap.set("n", "<leader>R", ':TermExec cmd="!!"<CR>:TermExec cmd=""<CR>', {
  desc = "Repeat last command",
  silent = true
})
-- }}}
