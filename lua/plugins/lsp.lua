local border = "single"

return {
  {
    'stevearc/dressing.nvim',
    opts = {
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
    }
  }
}
