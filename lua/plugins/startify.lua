local function courses()
  return { { line = 'CS 6204 Extensibility', cmd = 'SLoad cs6204' } }
end

local function research()
  return { { line = 'Thesis', cmd = 'SLoad thesis' } }
end

local function concat(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
end

local lists = {}

-- Add the lists for mac if we're currently on it
if vim.fn.hostname() == "BrdMPro.local" then
  concat(lists, {
    { type = courses,  header = { '   Courses' } },
    { type = research, header = { '   Research' } }
  })
end

-- Add the base lists
concat(lists, {
  { type = 'sessions',  header = { '   Sessions' } },
  { type = 'dir',       header = { '   MRU ' .. vim.fn.getcwd() } },
  { type = 'files',     header = { '   MRU' } },
  { type = 'bookmarks', header = { '   Bookmarks' } },
  { type = 'commands',  header = { '   Commands' } },
})

-- macOS file picker script
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

-- Floating windows (hover, diagnostics, etc.) mess with Startify sessions
-- The created command is called during startify shutdown
vim.api.nvim_create_user_command("CloseFloatingWindows", function()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then        -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format('Closed %d windows: %s', #closed_windows, vim.inspect(closed_windows)))
end, { bang = true, desc = "Close all floating windows" })

vim.api.nvim_create_user_command("CloseFugitiveIfOpen", function()
  if vim.g.fugitive_tab ~= nil then
    vim.cmd.tabclose(vim.g.fugitive_tab)
    vim.g.fugitive_tab = nil
    print("Closed Fugitive")
  else
    print("Fugitive not open")
  end
end, { bang = true, desc = "Close Fugitive tab if it's open" })

vim.api.nvim_create_user_command("CloseDBUIIfOpen", function()
  if vim.g.dbui_tab ~= nil then
    vim.cmd.tabclose(vim.g.dbui_tab)
    vim.g.dbui_tab = nil
    print("Closed DBUI")
  else
    print("DBUI not open")
  end
end, { bang = true, desc = "Close DBUI tab if it's open" })

return {
  {
    'mhinz/vim-startify',
    cond = not vim.g.started_by_firenvim,
    init = function()
      vim.g.startify_lists = lists

      -- Autoload Session.vim when found in a directory
      vim.g.startify_session_autoload = 1
      -- Automatically save sessions when exiting editor
      vim.g.startify_session_persistence = 1
      -- Sort sessions by modification time instead of alphabetically
      vim.g.startify_session_sort = 1
      -- Close NERDTree before saving session because saving with it causes errors on
      -- session open
      -- vim.g.startify_session_before_save = [ 'silent! tabdo NERDTreeClose', 'silent! tabdo call TerminalClose()', 'silent! tabdo call CloseFugitiveIfOpen()' ]
      vim.g.startify_session_before_save = {
        'silent! tabdo cclose',
        'silent! tabdo NvimTreeClose',
        -- 'silent! tabdo call CloseFugitiveIfOpen()',
        -- 'silent! tabdo lua require("incline").disable()',
        'silent! tabdo TroubleClose',
        'silent! tabdo lua require("fidget").close()',
        'silent! tabdo CloseFloatingWindows',
        'silent! tabdo DBUIClose'
      }
      -- Just to make cowsay look pretty
      vim.g.startify_fortune_use_unicode = 1

      vim.keymap.set('n', '<leader>Pq', ":SClose<CR>", { desc = 'Close sessions' })

      if vim.fn.has("mac") == 1 then
        vim.keymap.set('n', '<leader>Po', pickFile, { desc = 'Folder picker' })
      end
    end
  },
}
