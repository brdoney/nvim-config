--- Convenience func to obtain input using vim.ui with a prompt and callback.
---@param prompt string the prompt to show
---@param func fun(res:string|nil) callback to give result to
local function input(prompt, func)
  return function()
    vim.ui.input({ prompt = prompt }, func)
  end
end

return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    opts = {
      ensure_installed = { "python", "delve", "codelldb", "node2" },
      handlers = {},
    }
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {
      controls = {
        element = "console"
      },
      floating = {
        border = require("border").border
      },
      mappings = {
        edit = "c",
        toggle = "="
      },
      layouts = {
        {
          elements = {
            "scopes",
            "breakpoints",
            "stacks",
            "watches",
          },
          position = "left",
          size = 40
        },
        {
          elements = {
            -- "repl"
            "console"
          },
          position = "bottom",
          size = 14
        }
      },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")

      vim.print(opts)
      dapui.setup(opts)

      dap.listeners.before.attach.dapui_config = function()
        require('nvim-tree.api').tree.close()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        require('nvim-tree.api').tree.close()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = 'dap-repl',
        group = vim.api.nvim_create_augroup("dap", {}),
        callback = function()
          require('dap.ext.autocompl').attach()
        end
      })
    end,
    keys = {
      {
        "<leader>dd",
        function()
          require('nvim-tree.api').tree.close()
          require("dapui").toggle()
        end,
        desc = "Toggle debugger"
      },
      { '<leader>dc', function() require('dap').continue() end,  desc = "Continue" },
      { '<leader>ds', function() require('dap').step_over() end, desc = "Step over" },
      { '<leader>di', function() require('dap').step_into() end, desc = "Step into" },
      { '<leader>do', function() require('dap').step_out() end,  desc = "Step out" },
      { '<leader>dr', function() require('dap').run_last() end,  desc = "Run last" },
      {
        '<leader>dbb',
        function() require('dap').toggle_breakpoint() end,
        desc = "Toggle breakpoint"
      },
      {
        '<leader>dbl',
        input("Log point message", function(res) require('dap').set_breakpoint(nil, nil, res) end),
        desc = "Log point"
      },
      {
        '<leader>dbc',
        input("Condition", function(res) require('dap').set_breakpoint(res) end),
        desc = "Conditional breakpoint"
      },
      {
        '<leader>dbh',
        input("Number of hits", function(res) require('dap').set_breakpoint(nil, res) end),
        desc = "Hitpoint"
      },
      -- Without dapui
      -- {
      --   '<Leader>dF',
      --   function()
      --     local widgets = require('dap.ui.widgets')
      --     widgets.centered_float(widgets.frames)
      --   end,
      --   desc = "Show frames"
      -- },
      -- {
      --   '<Leader>dS',
      --   function()
      --     local widgets = require('dap.ui.widgets')
      --     widgets.centered_float(widgets.scopes)
      --   end,
      --   desc = "Show scopes"
      -- },
      -- { '<Leader>dh', function() require('dap.ui.widgets').hover() end,   mode = { 'n', 'v' }, desc = "Hover" },
      -- { '<Leader>dp', function() require('dap.ui.widgets').preview() end, mode = { 'n', 'v' }, desc = "Preview" },
      -- { '<leader>dt', function() require('dap').terminate() end, desc = "Stop" },
      -- { '<leader>dR', function() require('dap').repl.open() end, desc = "Open REPL" },
      -- With dapui
      { '<Leader>dh', function() require('dapui').eval() end,    mode = { 'n', 'v' }, desc = "Hover" },
      { '<leader>dS', function() require('dap').terminate() end, desc = "Stop" },
      {
        '<leader>dR',
        function()
          -- Width and height match telescope's
          local width = math.floor(vim.o.columns * 0.8)
          local height = math.floor(vim.o.lines * 0.9)
          require('dapui').float_element("repl",
            { title = "DAP REPL", width = width, height = height, enter = true, position = "center" })
        end,
        desc = "Open REPL"
      },
    }
  }
}
