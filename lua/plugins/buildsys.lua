return {
  {
    -- Toggle and control terminals
    'akinsho/toggleterm.nvim',
    version = "*",
    -- dir = '~/Developer/Vim/toggleterm.nvim',
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
        local term = require('toggleterm.terminal').get(1)
        if term ~= nil then
          -- Clear the current terminal contents, since they're from a past run
          vim.cmd("1TermExec cmd=clear")
          -- May need to wait after this, but haven't had any issues yet
          local sb = vim.bo[term.bufnr].scrollback
          vim.bo[term.bufnr].scrollback = 1
          vim.bo[term.bufnr].scrollback = sb
          vim.cmd("1TermExec cmd='" .. opts.cmd .. "'")
        else
          -- Create a fresh terminal to run the job
          vim.cmd("1TermExec cmd='" .. opts.cmd .. "'")
        end
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
      { "<leader>r", "<cmd>AsyncTask run<cr>",   silent = true, desc = "Run" },
      { "<D-r>",     "<cmd>AsyncTask run<cr>",   silent = true, desc = "Run" },
      { "<leader>b", "cmd>AsyncTask build<cr>",  silent = true, desc = "Build" },
      { "<D-b>",     "<cmd>AsyncTask build<cr>", silent = true, desc = "Build" },
      { "<leader>T", "cmd>AsyncTask test<cr>",   silent = true, desc = "Test" }
    },
    cmd = "AsyncTask"
  }
}
