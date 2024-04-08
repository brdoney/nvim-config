return {
  {
    -- Improvements to the quickfix window
    'kevinhwang91/nvim-bqf',
    dependencies = {
      'nvim-treesitter/nvim-treesitter'
    },
    ft = "qf",
    opts = {
      auto_resize_height = true,
    }
  },
  {
    -- Basic zen mode
    'junegunn/goyo.vim',
    init = function()
      vim.g.goyo_height = "100%"
      -- vim.g.goyo_width = 90
    end,
    -- Toggle Goyo on keypress
    keys = { { "<leader>z", "<cmd>Goyo<CR>", silent = true, desc = "Toggle Goyo", } },
    cmd = "Goyo"
  },
  {
    -- Scrollbar which shows diagnostics and such
    'petertriho/nvim-scrollbar',
    opts = {
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
    }
  },
  {
    -- Indent highlights
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    init = function()
      -- Fix for https://github.com/lukas-reineke/indent-blankline.nvim/issues/489
      local indentblanklinegrp = vim.api.nvim_create_augroup('IndentBlankLineFix', {})
      vim.api.nvim_create_autocmd('WinScrolled', {
        group = indentblanklinegrp,
        callback = function(args)
          if vim.v.event.all.leftcol ~= 0 then
            require("ibl").debounced_refresh(args.buf)
          end
        end,
      })
      -- Set manual refresh for when things get funky
      vim.keymap.set("n", "<leader>i", require("ibl").refresh, { silent = true, desc = "Refresh indents" })
    end,
    opts = {
      indent = { char = '│' },
      scope = {
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = { "lspinfo", "packer", "checkhealth", "help", "man", "text", "startify", "NvimTree", "mason" },
        buftypes = { "terminal", "nofile", "quickfix", "prompt" }
      }
    }
  },
}
