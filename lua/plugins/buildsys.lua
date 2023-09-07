return {
  {
    -- Toggle and control terminals
    -- 'akinsho/toggleterm.nvim', version = "*",
    dir = '~/Developer/Vim/toggleterm.nvim',
    event = "VeryLazy",
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
  {
    -- Run code based on a defined task system (like code runner in VSCode)
    'skywind3000/asyncrun.vim',
    dependencies = { 'skywind3000/asynctasks.vim' },
    init = function()
      local function toggleterm_runner(opts)
        vim.cmd("1TermExec cmd='" .. opts.cmd .. "'")
      end

      -- Register our custom toggleterm plugin
      if vim.g.asyncrun_runner == nil then
        vim.g.asyncrun_runner = { send_toggleterm = toggleterm_runner }
      else
        vim.g.asyncrun_runner.send_toggleterm = toggleterm_runner
      end

      -- Use our custom toggleterm plugin for running tasks
      vim.g.asynctasks_term_pos = 'send_toggleterm'

      -- Save all files on run
      vim.g.asyncrun_save = 2
    end,
    keys = {
      { "<leader>r", ":AsyncTask run<cr>",   silent = true, desc = "Run", },
      { "<leader>b", ":AsyncTask build<cr>", silent = true, desc = "Build" },
      { "<leader>T", ":AsyncTask test<cr>",  silent = true, desc = "Test" }
    },
    cmd = "AsyncTask"
  }
}
