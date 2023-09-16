return {
  -- Syntax highlighting
  {
    'sainnhe/sonokai',
    priority = 1000,
    init = function()
      -- The configuration options should be placed before `colorscheme sonokai`.
      vim.g.sonokai_style = "maia"
      -- Enable italics
      vim.g.sonokai_enable_italic = 1
      -- Show more markers for lines with diagnostics
      vim.g.sonokai_diagnostic_text_highlight = 1
      -- Make the sign column the same background as normal text
      vim.g.sonokai_sign_column_background = 'none'
      -- Normally, colour is based on the type of diagonstic (hint, into, error, etc.)
      vim.g.sonokai_diagnostic_virtual_text = 'grey'
      -- Make autocomplete green instead of blue
      vim.g.sonokai_menu_selection_background = 'green'
      -- Don't show the end of buffer `~`s
      vim.g.sonokai_show_eob = 0
      -- Disable terminal colors
      vim.g.sonokai_disable_terminal_colors = 1
    end,
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme sonokai]])
    end,
  },
  -- Scope to make buffers window-specific
  { "tiagovla/scope.nvim" },
  {
    'mhinz/vim-startify',
    cond = not vim.g.started_by_firenvim,
    init = function()
      local function courses()
        return { { line = 'CS 5944 Graduate Seminar', cmd = 'SLoad gradseminar' } }
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
      vim.g.startify_session_before_save = { 'silent! tabdo cclose',
        'silent! tabdo NvimTreeClose',
        'silent! tabdo call TerminalClose()',
        'silent! tabdo call CloseFugitiveIfOpen()',
        'silent! tabdo lua require("incline").disable()',
        'silent! tabdo TroubleClose',
        'silent! tabdo lua require("fidget").close()',
        'silent! tabdo CloseFloatingWindows'
      }
      -- Just to make cowsay look pretty
      vim.g.startify_fortune_use_unicode = 1
    end
  },
  {
    'vim-airline/vim-airline',
    cond = not vim.g.started_by_firenvim,
    dependencies = { 'vim-airline/vim-airline-themes' },
    init = function()
      -- From vim-airline-themes
      vim.g.airline_theme = "minimalist"
      -- Use powerline in airline
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_stl_path_style = 'short'
    end,
    config = function()
      vim.api.nvim_exec2([[
        function! SleuthPlugin(...)
          " Prepend sleuth info to section x (right before the file type)
          let w:airline_section_x = get(w:, 'airline_section_x', g:airline_section_x)
          let w:airline_section_x = '%{SleuthIndicator()}' . g:airline_symbols.space . w:airline_section_x
        endfunction
        call airline#add_statusline_func('SleuthPlugin')
      ]], {})
    end
  },
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      -- Lazy will set it up for us
      vim.g.barbar_auto_setup = false

      local function barbarmap(key, command, desc)
        local opts = { silent = true, noremap = true, desc = desc }
        vim.keymap.set("n", key, command, opts)
      end

      -- Barbar operations
      barbarmap("<leader>p", ":BufferPick<CR>", "Pick buffer")
      barbarmap("<leader>[", ":BufferPrevious<CR>", "Previous buffer")
      barbarmap("<leader>]", ":BufferNext<CR>", "Next buffer")
      barbarmap("<leader>{", ":BufferMovePrevious<CR>", "Move buffer left")
      barbarmap("<leader>}", ":BufferMoveNext<CR>", "Move buffer right")
      barbarmap("<leader>\\", ":BufferClose<CR>", "Close buffer")

      -- Tabpage operations
      barbarmap("<leader>tt", ":tabnew<CR>", "Open new tab")
      barbarmap("<leader>t[", ":tabprevious<CR>", "Previous tab")
      barbarmap("<leader>t]", ":tabnext<CR>", "Next tab")
      barbarmap("<leader>|", function()
        -- ":tabclose<CR>"
        vim.cmd.tabclose()
        -- Reload nvim tree for git updates
        require('nvim-tree.api').tree.reload()
        -- Refresh gitgutter for updates
        vim.cmd("GitGutterAll")
      end, "Close tab")
    end,
    opts = {
      insert_at_end = true,
      icons = {
        button = "",
        modified = {
          button = ""
        }
      }
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        ["<space>"] = "spc",
        ["<cr>"] = "",
        ["<tab>"] = "",
      },
      window = {
        border = "single",        -- none, single, double, shadow
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
      },
    }
    ,
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        c = {
          name = "conflict" -- optional group name
        },
        h = {
          name = "git"
        },
        q = {
          name = "lsp",
          w = {
            name = "workspace"
          }
        },
        s = {
          name = "search"
        },
        P = {
          name = 'project'
        },
        ["<Space>"] = {
          name = "VM"
        },
        w = {
          name = "word"
        },
        [";"] = { "Add ; to end of line" },
        m = { "Max height" },
        M = { "Max width" }
      }, { prefix = "<leader>" })
      -- wk.register({
      --   D = { "Go to declaration" },
      --   d = { "Go to definition" },
      --   r = { "Go to references" },
      --   i = { "Go to implementation" },
      -- })

      wk.register({
        q = {
          name = "lsp",
        },
      }, { prefix = "<leader>", mode = "v" })
    end
  },
  -- Only run when running base nvim (not in firenvim)
  {
    "b0o/incline.nvim",
    cond = not vim.g.started_by_firenvim,
    dependencies = {
      'nvim-tree/nvim-web-devicons' -- for icons in tab
    },
    opts = {
      render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)

        local res, extension
        if bufname ~= '' then
          res = vim.fn.fnamemodify(bufname, ':t')
          extension = vim.fn.matchstr(res, [[\v\.@<=\w+$]])
        else
          res = '[No Name]'
          extension = ''
        end

        local icon, _ = require("nvim-web-devicons").get_icon(res, extension, { default = true })
        res = icon .. ' ' .. res

        if vim.api.nvim_buf_get_option(props.buf, 'modified') then
          res = res .. ' '
        end
        return res
      end,
      window = {
        margin = {
          horizontal = {
            left = 0,
            right = 0
          },
          vertical = {
            bottom = 0,
            top = 1
          }
        }
      },
    }
  },
  {
    -- Indent highlights
    'lukas-reineke/indent-blankline.nvim',
    init = function()
      -- Fix for https://github.com/lukas-reineke/indent-blankline.nvim/issues/489
      local indentblanklinegrp = vim.api.nvim_create_augroup('IndentBlankLineFix', {})
      vim.api.nvim_create_autocmd('WinScrolled', {
        group = indentblanklinegrp,
        callback = function()
          if vim.v.event.all.leftcol ~= 0 then
            vim.cmd('silent! IndentBlanklineRefresh')
          end
        end,
      })
      -- Set manual refresh for when things get funky
      vim.keymap.set("n", "<leader>i", ":IndentBlanklineRefresh<CR>", { silent = true, desc = "Refresh indents" })
    end,
    opts = {
      use_treesitter = true,
      char = '│',
      filetype_exclude = { "lspinfo", "packer", "checkhealth", "help", "man", "text", "startify", "NvimTree", "mason" },
      buftype_exclude = { "terminal", "nofile", "quickfix", "prompt" },
      show_trailing_blankline_indent = false,
    }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        ensureInstalled = "all",
        highlight = {
          enable = true,
        },
        -- Add to enable indenting using treesitter
        -- indent = {
        --   enable = false
        -- },
        -- From JoosepAlviste/nvim-ts-context-commentstring
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        -- From windwp/nvim-ts-autotag
        autotag = {
          enable = true,
        }
      }

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      -- Start at 99 so everything isn't folded up at the start
      vim.opt.foldlevel = 99
      vim.opt.foldnestmax = 10
      -- Remove folds since treesitter will regenerate them each time anyway
      -- (and sessions will preserve manual folding from past otherwise)
      vim.opt.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,terminal"
    end
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
    keys = { "<leader>z", "<cmd>Goyo<CR>", silent = true, desc = "Toggle Goyo", },
    cmd = "Goyo"
  },
  -- Rainbow CSV and querying
  { 'mechatroner/rainbow_csv', ft = { "csv", "tsv", "csv_semicolon", "csv_whitespace", "csv_pipe" } },
  {
    -- Resize mode using natural directions
    'mrjones2014/smart-splits.nvim',
    keys = { "<C-w>r", },
    config = function(_, opts)
      require('smart-splits').setup(opts)
      vim.keymap.set("n", "<C-w>r", require('smart-splits').start_resize_mode, { desc = "Start buffer resize mode" });
    end
  }
}
