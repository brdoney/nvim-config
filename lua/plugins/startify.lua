local function load_session_action(session)
  return function()
    require("mini.sessions").read(session)
  end
end

local function shortcuts()
  local shortcuts_list = {
    { name = "Thesis",   session = "thesis" },
    { name = "Analysis", session = "thesisanalysis" },
  }

  local items = {}

  -- Add the lists for mac if we're currently on it
  if vim.fn.hostname() == "BrdMPro.local" then
    for i, value in ipairs(shortcuts_list) do
      items[i] = { name = value.name, action = load_session_action(value.session), section = "Shortcuts" }
    end
  end

  return items
end

-- macOS file picker script
-- local function pickFile()
--   local output = vim.fn.system("~/Developer/Swift/NvimFilePicker/.build/release/NvimFilePicker")
--
--   -- Do nothing if it wasn't succesful
--   if vim.v.shell_error == 1 then
--     print(output)
--     return
--   end
--
--   -- Get rid of trailing new line
--   output = vim.trim(output)
--
--   -- Close the current session (if open) and open the folder
--   vim.cmd [[ SClose ]]
--   vim.cmd('e ' .. output)
-- end

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
    -- vim.cmd.tabclose(vim.g.dbui_tab)
    require("dbee").close()
    vim.g.dbui_tab = nil
    print("Closed DBUI")
  else
    print("DBUI not open")
  end
end, { bang = true, desc = "Close DBUI tab if it's open" })

return {
  {
    'echasnovski/mini.sessions',
    version = '*',
    dependencies = {
      "tiagovla/scope.nvim", -- For loading sessions
    },
    opts = {
      hooks = {
        pre = {
          write = function()
            require("nvim-tree.api").tree.close_in_all_tabs()

            local commands = {
              -- Per-tab commands
              'silent! tabdo cclose',
              'silent! tabdo TroubleClose',
              'silent! tabdo lua require("fidget").close()',
              -- 'silent! tabdo lua require("incline").disable()',
              -- Run once commands
              'silent! CloseFugitiveIfOpen',
              'silent! CloseDBUIIfOpen',
              'silent! CloseFloatingWindows',
            }
            for _, cmd in ipairs(commands) do
              vim.cmd(cmd)
            end
          end
        },
      }
    },
    keys = {
      { "<leader>PP", function() require("mini.sessions").select() end, desc = 'Session picker' },
      {
        "<leader>Ps",
        function()
          vim.ui.input({ prompt = "Session name" }, function(name)
            require("mini.sessions").write(name)
          end)
        end,
        desc = "Save session"
      }
    }
  },
  {
    "echasnovski/mini.starter",
    version = "*",
    dependencies = { "echasnovski/mini.sessions" },
    config = function()
      local starter = require("mini.starter")
      starter.setup({
        evaluate_single = true,
        items = {
          shortcuts,
          starter.sections.sessions(10),
          -- Don't show paths on any files (last argument)
          starter.sections.recent_files(5, false, false),
          starter.sections.recent_files(5, true, false),
          -- starter.sections.builtin_actions(),
        },
        content_hooks = {
          starter.gen_hook.adding_bullet(),
          -- starter.gen_hook.indexing("all", { "Builtin actions" }),
          -- starter.gen_hook.padding(3, 2),
          starter.gen_hook.aligning("center", "center"),
        },
        header = function()
          -- Looks like "Wednesday 08/28 12:27am"
          return vim.fn.strftime("%A %m/%d %l:%M%p"):gsub("AM", "am"):gsub("PM", "pm")
        end,
        -- query_updaters = "0123456789.eq"
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniStarterOpened",
        group = vim.api.nvim_create_augroup("starter_opened", {}),
        callback = function()
          -- Get regular scrolling back, but does prevent the j and k keys from being used in queries
          vim.keymap.set("n", "j", function() starter.update_current_item("next") end, { buffer = true })
          vim.keymap.set("n", "k", function() starter.update_current_item("prev") end, { buffer = true })
        end
      })
    end
  },
}
