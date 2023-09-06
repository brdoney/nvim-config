local border = "single"

return {
  {
    'stevearc/dressing.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    event = 'BufWinEnter',
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
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- Javascript
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.diagnostics.eslint_d.with({ method = null_ls.methods.DIAGNOSTICS_ON_SAVE }),
          null_ls.builtins.formatting.prettierd,

          -- Python
          null_ls.builtins.diagnostics.flake8.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            extra_args = { "--max-line-length=88", "--extend-ignore=E203" }
          }),
          null_ls.builtins.diagnostics.mypy.with({
            method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            ---@diagnostic disable-next-line: unused-local
            extra_args = function(params)
              if vim.fn.isdirectory(params.cwd .. "/.venv/") == 1 then
                return { "--python-executable", ".venv/bin/python" }
              end
              return {}
            end
          }),
          -- null_ls.builtins.formatting.autopep8
          null_ls.builtins.formatting.black,

          -- Swift
          null_ls.builtins.formatting.swiftformat
        },
      })
    end
  }
}
