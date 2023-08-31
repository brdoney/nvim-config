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
