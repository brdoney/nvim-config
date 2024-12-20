local function create_date_file_in_nvim_tree()
  -- Get the current directory from nvim-tree where the cursor is located
  local node = require('nvim-tree.api').tree.get_node_under_cursor()

  -- Check if the node is a directory; if not, use the parent directory
  local dir = node.parent.absolute_path
  if node.type == "directory" then
    dir = node.absolute_path
  end

  -- Get the current date
  local date = os.date("%y-%m-%d")
  -- Set the file path
  local filepath = vim.fn.expand(dir .. "/" .. date .. ".md")

  if filepath == "" then
    print("Could not expand filepath with pieces " .. dir .. " and " .. date)
    return
  end

  -- Check if the file already exists
  if vim.fn.filereadable(filepath) == 0 then
    -- Create the file and open it in a new buffer
    vim.cmd("edit " .. filepath)

    -- Refresh nvim-tree to show the new file
    require('nvim-tree.api').tree.reload()
  else
    print("File already exists: " .. filepath)
  end
end

local function nvim_tree_on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Mappings from the default keybindings
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview, opts('Open Preview'))
  vim.keymap.set('n', '>', api.node.navigate.sibling.next, opts('Next Sibling'))
  vim.keymap.set('n', '<', api.node.navigate.sibling.prev, opts('Previous Sibling'))
  vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 'a', api.fs.create, opts('Create'))
  vim.keymap.set('n', 'bmv', api.marks.bulk.move, opts('Move Bookmarked'))
  vim.keymap.set('n', 'B', api.tree.toggle_no_buffer_filter, opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
  vim.keymap.set('n', 'C', api.tree.toggle_git_clean_filter, opts('Toggle Git Clean'))
  vim.keymap.set('n', '[c', api.node.navigate.git.prev, opts('Prev Git'))
  vim.keymap.set('n', ']c', api.node.navigate.git.next, opts('Next Git'))
  vim.keymap.set('n', 'D', api.fs.remove, opts('Delete'))
  vim.keymap.set('n', 'd', api.fs.trash, opts('Trash'))
  vim.keymap.set('n', 'E', api.tree.expand_all, opts('Expand All'))
  vim.keymap.set('n', 'e', api.fs.rename_basename, opts('Rename: Basename'))
  vim.keymap.set('n', ']e', api.node.navigate.diagnostics.next, opts('Next Diagnostic'))
  vim.keymap.set('n', '[e', api.node.navigate.diagnostics.prev, opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F', api.live_filter.clear, opts('Clean Filter'))
  vim.keymap.set('n', 'f', api.live_filter.start, opts('Filter'))
  vim.keymap.set('n', 'g?', api.tree.toggle_help, opts('Help'))
  vim.keymap.set('n', 'gy', api.fs.copy.absolute_path, opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H', api.tree.toggle_hidden_filter, opts('Toggle Dotfiles'))
  -- vim.keymap.set('n', 'J', api.node.navigate.sibling.last, opts('Last Sibling'))
  -- vim.keymap.set('n', 'K', api.node.navigate.sibling.first, opts('First Sibling'))
  vim.keymap.set('n', 'm', api.marks.toggle, opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'O', api.node.open.no_window_picker, opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
  vim.keymap.set('n', 'P', api.node.navigate.parent, opts('Parent Directory'))
  vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
  vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
  vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
  vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
  vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
  vim.keymap.set('n', 'U', api.tree.toggle_custom_filter, opts('Toggle Hidden'))
  vim.keymap.set('n', 'W', api.tree.collapse_all, opts('Collapse'))
  vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
  vim.keymap.set('n', 'y', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'Y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))

  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', 'K', api.node.show_info_popup, opts('Info'))
  vim.keymap.set('n', 'I', api.tree.toggle_gitignore_filter, opts('Toggle Git Ignore'))

  -- Custom functions
  vim.keymap.set('n', 'M', create_date_file_in_nvim_tree, opts('Create meeting file'))
end

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

return {
  {
    "nvim-tree/nvim-tree.lua",
    -- Latest stable version
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      disable_netrw = true,
      -- tab = {
      --   sync = {
      --     -- Auto-open nvim-tree if it was open and we do :tabnew
      --     open = true
      --   }
      -- },
      -- Keep the cursor at the start of the line
      hijack_cursor = true,
      -- Update cwd if we use :cd for some reason
      sync_root_with_cwd = true,
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = { error = " ", warning = " ", hint = " ", info = " " }
      },
      update_focused_file = {
        -- Focus a file when opened (if it's in currenet directory)
        enable = true,
      },
      actions = {
        file_popup = {
          open_win_config = {
            border = require("border").border
          }
        }
      },
      renderer = {
        indent_markers = {
          enable = true
        },
        highlight_git = true,
        group_empty = true,
        add_trailing = true,
        icons = {
          glyphs = {
            git = {
              unstaged = "*",
              ignored = "",
            }
          },
        }
      },
      filters = {
        -- Show gitignore and dotfiles (will highlight differently)
        git_ignored = false,
        dotfiles = false,
      },
      on_attach = nvim_tree_on_attach
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      vim.keymap.set('n', '<leader>e', ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree", silent = true })
      -- vim.keymap.set('n', '<leader>ef', require('nvim-tree').find_file, { desc = "Show open file in NvimTree" })
    end
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    event = "LspAttach",
    opts = {},
  }
}
