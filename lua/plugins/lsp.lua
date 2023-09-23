local border = "single"

local servers = {
  -- HTML/CSS/JS/TS
  'emmet_ls',
  'html',
  'cssls',
  'tsserver',
  -- Go
  'gopls',
  -- C/C++
  'clangd',
  -- Python
  'pyright',
  -- Rust
  'rust_analyzer',
  -- BASH
  'bashls',
  -- Vim
  'vimls',
  -- Lua
  'lua_ls',
}

local tools = {
  -- JS/TS
  'eslint_d', 'prettierd'
}

return {
  {
    -- For nvim Lua API
    'folke/neodev.nvim',
    ft = 'lua',
    opts = {}
  },
  {
    -- For non-spec JDTLS features, not started until after/ftplugin/java.lua is run when a Java file is opened
    -- (so .setup() isn't run here)
    'mfussenegger/nvim-jdtls',
    ft = 'java'
  },
  {
    -- Non-spec LSP additions for Rust
    'simrat39/rust-tools.nvim',
    dependencies = 'hrsh7th/cmp-nvim-lsp',
    ft = 'rust',
    config = function()
      require("rust-tools").setup({
        tools = {
          hover_with_actions = false,
          inlay_hints = {
            -- Disabled for now
            auto = false,
            parameter_hints_prefix = '<- ',
            other_hints_prefix = '» ',
            right_align = true
          },
          hover_actions = {
            border = border
          }
        },
        server = {
          on_attach = require('lsp-utils').lsp_on_attach,
          capabilities = require('lsp-utils').capabilities,
        }
      })
    end
  },
  {
    -- Native LSP support
    'neovim/nvim-lspconfig',
    dependencies = 'hrsh7th/cmp-nvim-lsp',
    event = "VeryLazy",
    config = function()
      for _, server in ipairs(servers) do
        if server == 'jdtls' then
          -- Skip b/c configuerd in after/ftplugin/java.lua
        elseif server == 'rust_analyzer' then
        else
          local opts = {
            on_attach = require('lsp-utils').lsp_on_attach,
            capabilities = require('lsp-utils').capabilities,
          }

          if server == 'sourcekit' then
            -- Fix the path to the toolchain (found via `xcrun --find sourcekit-lsp`) and limit filetypes to not include c/c++
            opts = vim.tbl_deep_extend("force", {
              cmd = {
                "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
              filetypes = { "swift", "objective-c", "objective-cpp" }
            }, opts)
          end

          require('lspconfig')[server].setup(opts)
        end
      end

      -- Put border around popups
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = border,
      })
      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = border,
      })

      -- From https://github.com/neovim/neovim/pull/14878 ; don't focus the quickfix window
      local orig_ref_handler = vim.lsp.handlers["textDocument/references"]
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers["textDocument/references"] = function(...)
        orig_ref_handler(...)
        vim.cmd [[ wincmd p ]]
      end

      -- Use custom icons in gutter
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Custom header for diagnostics
      vim.diagnostic.config({
        float = {
          border = border,
          header = { ' Diagnostics:' },
        }
      })

      -- Floating windows (hover, diagnostics, etc.) mess with Startify sessions
      -- The created command is called during startify shutdown
      vim.cmd [[ command! CloseFloatingWindows lua _G.CloseFloatingWindows() ]]
      _G.CloseFloatingWindows = function()
        local closed_windows = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local config = vim.api.nvim_win_get_config(win)
          if config.relative ~= "" then        -- is_floating_window?
            vim.api.nvim_win_close(win, false) -- do not force
            table.insert(closed_windows, win)
          end
        end
        print(string.format('Closed %d windows: %s', #closed_windows, vim.inspect(closed_windows)))
      end
    end
  },
  {
    'stevearc/dressing.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    event = 'VeryLazy',
    config = function()
      require("dressing").setup({
        input = {
          default_prompt = "> ",
          border = border,
        },
        select = {
          -- backend = { "builtin", "telescope", "fzf_lua", "fzf", "nui" },

          -- telescope = require('telescope.themes').get_cursor({ borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" } }),
          telescope = require('telescope.themes').get_cursor({
            borderchars = {
              { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
              prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
              results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
              preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            },
            winblend = 10,
            initial_mode = "normal"
          }),

          -- Not actually used b/c it looks ugly, but just in case the backend
          -- is changed later
          builtin = {
            border = border,
            relative = "cursor",
          },

          format_item_override = {
            codeaction = function(action_tuple)
              local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
              local client = vim.lsp.get_client_by_id(action_tuple[1])

              -- for index, data in ipairs(action_tuple) do
              --   print(string.format("%d %s", index, vim.inspect(data)))
              -- end
              return string.format(" %s %s ", title:gsub("\n", "\\n"), client.name)
            end,
          }
        },
        override = function(conf)
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          conf.anchor = "NW"
          return conf
        end,
      })
    end
  },
  {
    -- Support non-LSP sources (i.e. for formatting)
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = "VeryLazy",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- Javascript
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d.with({ method = null_ls.methods.DIAGNOSTICS_ON_SAVE }),
          null_ls.builtins.formatting.prettierd,

          -- Python
          null_ls.builtins.diagnostics.ruff,
          -- null_ls.builtins.diagnostics.flake8.with({
          --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          --   extra_args = { "--max-line-length=88", "--extend-ignore=E203" }
          -- }),
          --
          -- Use dmypy -- alternatives in https://github.com/jose-elias-alvarez/null-ls.nvim/issues/831
          null_ls.builtins.diagnostics.mypy.with({
            command = 'dmypy',
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            -- Use the virtual environment version if available so it sees all the project's types
            prefer_local = ".venv/bin",
            prepend_extra_args = true,
            extra_args = function()
              return { "run", "--timeout", "500", "--" }
            end
          }),
          -- null_ls.builtins.formatting.autopep8
          null_ls.builtins.formatting.black,

          -- Swift
          null_ls.builtins.formatting.swiftformat
        },
      })
    end
  },
  {
    -- Show a lightbulb in the gutter when there's code actions
    'kosayoda/nvim-lightbulb',
    event = 'LspAttach',
    opts = {
      autocmd = { enabled = true },
      sign = {
        enabled = true,
        text = "",
        hl = "LightBulbSign",
      },
    }
  },
  {
    'j-hui/fidget.nvim',
    -- Use legacy tag until rewrite is done
    tag = 'legacy',
    event = 'LspAttach',
    opts = {
      text = {
        spinner = "square_corners"
      },
      fmt = {
        task = function(task_name, message, percentage)
          -- Hide all code-actions until we can specific sources from null-ls
          -- https://github.com/j-hui/fidget.nvim/issues/99
          -- https://github.com/j-hui/fidget.nvim/issues/112
          -- Still shows spinner for null-ls (even when there are no items besides the hidden code-actions)
          -- and still show any non-code-action items for null-ls
          if task_name == "code_action" then
            return false
          end
          return string.format(
            "%s%s [%s]",
            message,
            percentage and string.format(" (%s%%)", percentage) or "",
            task_name
          )
        end,
      }
    }
  },
  {
    'folke/trouble.nvim',
    event = 'LspAttach',
    keys = { { '<leader>g', function() require('trouble').toggle() end, desc = 'Toggle trouble' } }
  },
  {
    'williamboman/mason.nvim',
    event = "VeryLazy",
    opts = {}
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = 'williamboman/mason.nvim',
    event = "VeryLazy",
    opts = {
      ensure_installed = servers
    }
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = 'williamboman/mason.nvim',
    event = "VeryLazy",
    opts = {
      ensure_installed = tools
    }
  },
  {
    -- Neogen for generating Javadoc, JSDoc, Docstrings, etc.
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      snippet_engine = "vsnip"
    },
    keys = {
      { "<leader>qn", function() require("neogen").generate() end, silent = true, desc = "Neogen" }
    }
  }
}
