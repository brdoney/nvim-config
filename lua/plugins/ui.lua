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
    event = "VeryLazy",
    keys = { { "<leader>i", function() require("ibl").debounced_refresh(0) end, { silent = true, desc = "Refresh indents" } } },
    config = function()
      -- local originalHighlights = {
      --   "#ff6d7e",
      --   "#ffb270",
      --   "#ffed72",
      --   "#a2e57b",
      --   "#7cd5f1",
      --   "#baa0f8",
      -- }
      -- These are the above colors, made translucent using bin/covert-color-alpha.py
      local dimHighlights = {
        '#5c4048',
        '#5c5144',
        '#5c5f45',
        '#455d47',
        '#3c5a64',
        '#4b4c66',
      }
      local brightHighlights = {
        '#ae5663',
        '#ae815a',
        '#aea65b',
        '#74a161',
        '#5c97ab',
        '#8376af',
      }

      local hooks = require("ibl.hooks")

      ---@type string[]
      local brightHighlightGroups = {}
      ---@type string[]
      local dimHighlightGroups = {}

      for i, _ in ipairs(brightHighlights) do
        table.insert(brightHighlightGroups, 'IBLRainbowIndent' .. i)
        table.insert(dimHighlightGroups, 'IBLDimRainbowIndent' .. i)
      end

      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        for i, _ in ipairs(brightHighlightGroups) do
          vim.api.nvim_set_hl(0, brightHighlightGroups[i], { fg = brightHighlights[i] })
          vim.api.nvim_set_hl(0, dimHighlightGroups[i], { fg = dimHighlights[i] })
        end
      end)

      require("ibl").setup({
        indent = {
          highlight = dimHighlightGroups,
          char = '│',
        },
        scope = {
          -- This is broken right now, see https://github.com/lukas-reineke/indent-blankline.nvim/issues/860
          -- highlight = brightHighlightGroups,
          enabled = false,
          show_start = false,
          show_end = false,
        },
        exclude = {
          filetypes = { "lspinfo", "packer", "checkhealth", "help", "man", "text", "startify", "NvimTree", "mason" },
          buftypes = { "terminal", "nofile", "quickfix", "prompt" }
        }
      })
    end
  },
}
