return {
  {
    -- Toggle and control terminals
    -- 'akinsho/toggleterm.nvim', version = "*",
    dir = '~/Developer/Vim/toggleterm.nvim',
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.3)
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.3)
        end
      end,
      open_mapping = [[<M-=>]],
      persist_size = false,
      shade_terminals = false,
      highlights = {
        -- Same as Telescope
        FloatBorder = { link = "Grey" }
      },
      float_opts = {
        border = 'curved',
        -- Width and height match Telescope's
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
      }
    },
    init = function()
      vim.keymap.set("n", "<leader>R", ':TermExec cmd="!!"<CR>:TermExec cmd=""<CR>', {
        desc = "Repeat last command",
        silent = true
      })
    end,
  },
}
