-- To set up autocmd for LspAttach
local border = require("border").border;

local mason_servers = {
  -- HTML/CSS/JS/TS
  'emmet_ls',
  'html',
  'cssls',
  'ts_ls',
  'eslint',
  -- Go
  'gopls',
  -- C/C++
  'clangd',
  -- Python
  'basedpyright',
  'ruff',
  -- Rust
  'rust_analyzer',
  -- BASH
  'bashls',
  -- Vim
  'vimls',
  -- Lua
  'lua_ls',
  -- Svelte
  'svelte',
  -- JSON
  'jsonls'
}

---@diagnostic disable-next-line: deprecated
table.unpack = table.unpack or unpack -- 5.1 compatibility

local servers = {
  -- Swift
  'sourcekit',
  -- Mason servers
  table.unpack(mason_servers)
}

local tools = {
  -- JS/TS
  'prettierd',
  -- Bash
  'shfmt',
  -- Python
  'mypy',
  -- C#: Roslyn language - not provided by mason-lspconfig (custom registry)
  'roslyn',
  'rzls',
  -- SQL
  'sqlfluff'
}

return {
  {
    -- For nvim Lua API
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {}
  },
  {
    -- For non-spec JDTLS features, not started until after/ftplugin/java.lua is run when a Java file is opened
    -- (so .setup() isn't run here)
    'mfussenegger/nvim-jdtls',
    ft = 'java'
  },
  -- {
  --   "jlcrochet/vim-razor",
  --   ft = "razor",
  -- },
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = {
      {
        "tris203/rzls.nvim",
        config = true,
      },
      "williamboman/mason.nvim"
    },
    config = function()
      require("roslyn").setup({
        -- Turn off filewatching for performance
        filewatching = "off",

        -- Default to full stack solution
        choose_target = function(target)
          return vim.iter(target):find(function(item)
            if string.match(item, "StudentFirst Full Stack.sln") then
              return item
            end
          end)
        end
      })

      local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
      local cmd = {
        "roslyn",
        "--stdio",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
        "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
        "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
        "--extension",
        vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
      }
      vim.lsp.config('roslyn', {
        cmd = cmd,
        handlers = require('rzls.roslyn_handlers'),
        capabilities = require('lsp-utils').capabilities,
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
          },
        }
      })
      vim.lsp.enable('roslyn')
    end,
    init = function()
      -- We add the Razor file types before the plugin loads.
      vim.filetype.add({
        extension = {
          razor = "razor",
          cshtml = "razor",
        },
      })
    end,
  },
  {
    -- Native LSP support
    'neovim/nvim-lspconfig',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'folke/neodev.nvim', 'williamboman/mason-lspconfig.nvim', 'seblyng/roslyn.nvim', "tris203/rzls.nvim" },
    event = "VeryLazy",
    config = function()
      for _, server in ipairs(servers) do
        if server == 'jdtls' or server == "roslyn" then
          -- Skip b/c configuerd in after/ftplugin/java.lua
        else
          local opts = {
            capabilities = require('lsp-utils').capabilities,
          }

          if server == 'sourcekit' then
            -- Fix the path to the toolchain (found via `xcrun --find sourcekit-lsp`) and limit filetypes to not include c/c++
            opts = vim.tbl_deep_extend("force", {
              cmd = {
                "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
              filetypes = { "swift", "objective-c", "objective-cpp" }
            }, opts)
          elseif server == "clangd" then
            opts = vim.tbl_deep_extend("force", {
              filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' } -- Remove proto
            }, opts)
          end

          vim.lsp.config(server, opts)
          vim.lsp.enable(server, true)
        end
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
          get_config = function(opts)
            if opts.kind == "codeaction" then
              return {
                telescope = require('telescope.themes').get_cursor({
                  borderchars = {
                    { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
                    results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
                    preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                  },
                  winblend = 10,
                  initial_mode = "normal"
                })
              }
            end
          end,

          -- Not actually used b/c it looks ugly, but just in case the backend
          -- is changed later
          builtin = {
            border = border,
            relative = "cursor",
          },
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
    'nvimtools/none-ls.nvim',
    -- 'jose-elias-alvarez/null-ls.nvim', -- deprecated
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = "VeryLazy",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- Javascript
          null_ls.builtins.formatting.prettierd,

          -- Bash
          null_ls.builtins.formatting.shfmt,

          -- SQL
          null_ls.builtins.diagnostics.sqlfluff,
          null_ls.builtins.formatting.sqlfluff,

          -- Python
          -- null_ls.builtins.diagnostics.flake8.with({
          --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          --   extra_args = { "--max-line-length=88", "--extend-ignore=E203" }
          -- }),
          --
          -- Use dmypy -- alternatives in https://github.com/jose-elias-alvarez/null-ls.nvim/issues/831
          -- null_ls.builtins.diagnostics.mypy.with({
          --   command = 'dmypy',
          --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          --   prepend_extra_args = true,
          --
          --   extra_args = function(params)
          --     local args = { "run", "--timeout", "500", "--" }
          --     if vim.fn.isdirectory(params.cwd .. "/.venv/") == 1 then
          --       -- Use the virtual environment version if available so it sees all the project's types
          --       -- prefer_local = ".venv/bin" doesn't work because we don't want to have to install mypy in projects
          --       table.insert(args, "--python-executable")
          --       table.insert(args, ".venv/bin/python")
          --     elseif vim.fn.isdirectory(params.cwd .. "/venv/") == 1 then
          --       -- Use the virtual environment version if available so it sees all the project's types
          --       -- prefer_local = ".venv/bin" doesn't work because we don't want to have to install mypy in projects
          --       table.insert(args, "--python-executable")
          --       table.insert(args, "venv/bin/python")
          --     end
          --     return args
          --   end,
          -- }),
          -- null_ls.builtins.formatting.autopep8
          -- null_ls.builtins.formatting.black,

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
        text = "󰌵",
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
    keys = { { '<leader>g', function() require('trouble').toggle("diagnostics") end, desc = 'Toggle trouble' } },
    opts = {
      modes = {
        diagnostics = {
          filter = function(items)
            -- For C# diagnostics
            return vim.tbl_filter(function(item)
              return not string.match(item.basename, "%__virtual.cs$")
            end, items)
          end,
        },
      },
    }
  },
  {
    'williamboman/mason.nvim',
    event = "VeryLazy",
    opts = {
      registries = {
        -- The base registry
        "github:mason-org/mason-registry",
        -- For roslyn
        "github:Crashdummyy/mason-registry",
      },
    }
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = 'williamboman/mason.nvim',
    event = "VeryLazy",
    opts = {
      ensure_installed = mason_servers,
      -- We manually enable them to change the settings
      automatic_enable = false
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
      { "<leader>qnn", function() require("neogen").generate({}) end,                 silent = true, desc = "Auto" },
      { "<leader>qnf", function() require("neogen").generate({ type = "func" }) end,  silent = true, desc = "Function" },
      { "<leader>qnc", function() require("neogen").generate({ type = "class" }) end, silent = true, desc = "Class" },
      { "<leader>qnt", function() require("neogen").generate({ type = "type" }) end,  silent = true, desc = "Type" },
      { "<leader>qnm", function() require("neogen").generate({ type = "file" }) end,  silent = true, desc = "File" },
    }
  },
  {
    'SmiteshP/nvim-navic',
    dependencies = 'SmiteshP/nvim-navic',
    opts = {
      icons = require('symbols').symbol_map_spaces,
      separator = '  ',
      -- separator = '',
      lsp = {
        auto_attach = true,
      },
      highlight = true,

      -- Make it only work on CursorHold
      -- lazy_update_context = true,
    },
  }
}
