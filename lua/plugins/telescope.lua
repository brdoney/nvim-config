local function select_one_or_multi(prompt_bufnr)
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require('telescope.actions').close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        if j.lnum ~= nil then
          vim.cmd(string.format("%s +%s %s", "edit", j.lnum, j.path))
        else
          vim.cmd(string.format("%s %s", "edit", j.path))
        end
      end
    end
  else
    require('telescope.actions').select_default(prompt_bufnr)
  end
end

local function related_files(opts)
  opts = opts or {}
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values

  local full_path = vim.api.nvim_buf_get_name(0)
  local basename = vim.fs.basename(full_path)
  local m = basename:match("(.-)%.cs")
  if m == nil then
    return
  end
  m = m:gsub("Enumeration", "")

  local relevant = m .. "(EntityTypeConfiguration|Model)\\.cs"
  local find_command = { "fdfind", relevant }

  pickers.new(opts, {
    prompt_title = "Related Files",
    finder = finders.new_oneshot_job(find_command, opts),
    previewer = conf.grep_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

local function if_preview_open(open_callback, closed_callback)
  return function(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local current_picker = action_state.get_current_picker(prompt_bufnr)

    if current_picker.previewer ~= nil
        and vim.api.nvim_win_is_valid(current_picker.previewer.state.winid)
        and vim.api.nvim_buf_is_loaded(current_picker.previewer.state.bufnr) then
      open_callback(prompt_bufnr)
    else
      closed_callback(prompt_bufnr)
    end
  end
end

return {
  {
    -- Fuzzy finder and selectors
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        scroll_strategy = "limit",

        -- path_display = "tail",
        -- Show file names before the path, like VSCode (better for deeply nested directories)
        path_display = {
          filename_first = {
            reverse_directories = false
          }
        },

        set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        sorting_strategy = "ascending",

        layout_config = {
          horizontal = {
            prompt_position = 'top'
          },
          vertical = {
            mirror = true,
            prompt_position = 'top'
          },
        },
        dynamic_preview_title = true,
        mappings = {
          i = {
            ["<CR>"] = select_one_or_multi,
            ["<esc>"] = "close",
            ['<C-u>'] = require('telescope.actions').results_scrolling_up,
            ['<C-d>'] = require('telescope.actions').results_scrolling_down,

            ['<C-f>'] = require('telescope.actions').results_scrolling_right,
            ['<C-b>'] = require('telescope.actions').results_scrolling_left,

            ['<Up>'] = if_preview_open(
              require('telescope.actions').preview_scrolling_up,
              require('telescope.actions').move_selection_previous
            ),
            ['<Down>'] = if_preview_open(
              require('telescope.actions').preview_scrolling_down,
              require('telescope.actions').move_selection_next
            ),
            ['<Right>'] = require('telescope.actions').preview_scrolling_right,
            ['<Left>'] = require('telescope.actions').preview_scrolling_left,

            ['<C-S-p>'] = require('telescope.actions.layout').toggle_preview,
            ['<C-a>'] = require('telescope.actions').toggle_all,
            ['<C-l>'] = function(prompt_bufnr)
              local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              local strategies = { "horizontal", "vertical" }

              -- Find the next strategy in the list
              local next_strategy = "horizontal"
              for i, s in ipairs(strategies) do
                if s == current_picker.layout_strategy then
                  next_strategy = strategies[(i % #strategies) + 1]
                  break
                end
              end

              -- Update the layout and refresh the picker
              current_picker.layout_strategy = next_strategy
              current_picker:full_layout_update()
            end,
          }
        },
        file_ignore_patterns = {
          "^.?venv/",
          "^.git/",
          "__pycache__/",
          "%__virtual.cs$",
          "%.Designer%.cs$", -- EF designer files (basically a db dump)
          -- The conservative set:
          -- "Migrations/",
          -- "Environment/",
          -- The technical set:
          "src/Environment/RestContracts/",
          "src/Environment/StudentFirst.DbMaintenance.ConsoleApp/",
          "src/Environment/StudentFirst.DbMigration.ConsoleApp/",
          -- "src/Environment/StudentFirst.Infrastructure/", -- the actual, good one
          -- "src/Environment/Tenants/",  -- probably want to include? Not sure though
          "src/Services/Crm/Contacts/GlobalEdTech.Crm.Contracts.Infrastructure/Migrations/",
          "src/Web/GlobalEdTech.Authentication.WebApp/Data/Migrations/",
          "src/operations/infrastructure/Migrations/",
        }
      }
    },
    cmd = "Telescope",
    keys = {
      { '<C-p>',      function() require('telescope.builtin').find_files({ hidden = true, previewer = false }) end,    desc = "File search" },
      { '<D-p>',      function() require('telescope.builtin').find_files({ hidden = true, previewer = false }) end,            desc = "File search" },
      { '<leader>qd', function() require('telescope.builtin').lsp_definitions({ jump_type = "never" }) end, desc = "Peek definition" },
      {
        '<leader>sa',
        function() require('telescope.builtin').find_files({ no_ignore = true }) end,
        desc = "File search without gitignore"
      },
      {
        '<leader>sh',
        function() require('telescope.builtin').find_files({ no_ignore = true, hidden = true }) end,
        desc = "File search all files"
      },
      { '<leader>ss', function() require('telescope.builtin').live_grep() end,  desc = "Live grep" },
      { '<leader>sg', function() require('telescope.builtin').git_status() end, desc = "Git status" },
      { '<leader>sr', function() require('telescope.builtin').resume() end,     desc = "Resume" },
      { '<leader>sf', related_files,                                            desc = "Related" },
      { '<leader>p',  function() require('telescope.builtin').buffers() end,    desc = "Buffers" }
    }
  },
}
