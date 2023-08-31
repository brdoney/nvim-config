-- vim: set fdm=marker fmr={{{,}}} fdl=0:

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

-- smart-splits.nvim {{{
require("smart-splits").setup()
vim.keymap.set("n", "<C-w>r", require('smart-splits').start_resize_mode, { desc = "Start buffer resize mode" });
-- }}}
