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
            ['<C-p>'] = require('telescope.actions.layout').toggle_preview,
            ['<C-a>'] = require('telescope.actions').toggle_all
          }
        },
        file_ignore_patterns = {
          "^.?venv/", "^.git/", "__pycache__/", "Migrations\\", "%__virtual.cs$"
        }
      }
    },
    cmd = "Telescope",
    keys = {
      { '<C-p>',      function() require('telescope.builtin').find_files({ hidden = true }) end,            desc = "File search" },
      { '<D-p>',      function() require('telescope.builtin').find_files({ hidden = true }) end,            desc = "File search" },
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
      { '<leader>sr', related_files,                                            desc = "Related" },
      { '<leader>p',  function() require('telescope.builtin').buffers() end,    desc = "Buffers" }
    }
  },
}
