-- vim: set fdm=marker fmr={{{,}}}:

-- Keybindings: {{{
---@diagnostic disable-next-line: unused-local
local on_attach = function(client, bufnr)
  --Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local function opts(description)
    return { silent = true, buffer = bufnr, desc = description }
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('Show documentation'))
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts('Signature help'))

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('Go to declaration'))
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts('Go to definition'))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts('Go to implementation'))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts('Go to references'))

  -- Trouble only works with its list and provides no preview
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts('Go to previous diagnostic'))
  -- vim.keymap.set('n', '[g', function() require('trouble').previous({ skip_groups = true, jump = true }) end, opts('Go to previous diagnostic'))
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts('Go to next diagnostic'))
  -- vim.keymap.set('n', ']g', function() require('trouble').next({ skip_groups = true, jump = true }) end, opts('Go to next diagnostic'))
  vim.keymap.set('n', '<leader>g', require('trouble').toggle, opts('Toggle trouble'))

  vim.keymap.set('n', '<leader>qwa', vim.lsp.buf.add_workspace_folder, opts('Add workspace folder'))
  vim.keymap.set('n', '<leader>qwr', vim.lsp.buf.remove_workspace_folder, opts('Remove workspace folder'))
  vim.keymap.set('n', '<leader>qwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    opts('List workspace folders'))
  vim.keymap.set('n', '<leader>qr', vim.lsp.buf.rename, opts('Rename symbol'))
  vim.keymap.set('n', '<leader>qa', vim.lsp.buf.code_action, opts('Code action'))
  vim.keymap.set('v', '<leader>qa', vim.lsp.buf.code_action, opts('Range code action'))

  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts('Format buffer'))

  vim.keymap.set('n', '<leader>qd', vim.diagnostic.disable, opts('Disable diagnostics'))

  vim.keymap.set('n', '<leader>qg', require('telescope.builtin').diagnostics, opts('List diagnostics'))
  vim.keymap.set('n', '<leader>qo', require('telescope.builtin').lsp_document_symbols, opts('List document symbols'))
  vim.keymap.set('n', '<leader>qwo', require('telescope.builtin').lsp_dynamic_workspace_symbols,
    opts('List workspace symbols'))

  -- Allow nvim's Lua API completion+docs to be set up with a keypress
  if vim.bo.filetype == 'c' or vim.bo.filetype == 'cpp' then
    vim.keymap.set('n', '<leader>qh', ':ClangdSwitchSourceHeader<CR>', opts('Switch header/source'))
  end
end
-- }}}

-- LSPkind {{{
local lspkind = require('lspkind')

lspkind.init({
  mode = "symbol_text",

  symbol_map = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "פּ",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "塞",
    Value = "",
    Enum = "練",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = ""
  }
})

-- }}}

-- Cmp {{{
local cmp = require('cmp')
local compare = require('cmp.config.compare')
local types = require('cmp.types')
local feedkeys = require('cmp.utils.feedkeys')
local keymap = require('cmp.utils.keymap')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noinsert"
  },
  -- window = {
  --   completion = cmp.config.window.bordered(),
  --   documentation = cmp.config.window.bordered(),
  -- },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  formatting = {
    format = lspkind.cmp_format(),
    --   fields = { "kind", "abbr" },
    --   format = function(_, vim_item)
    --     vim_item.kind = cmp_kinds[vim_item.kind] or ""
    --     return vim_item
    --   end,
  },
  experimental = {
    ghost_text = true
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
  }),
  sorting = {
    priority_weight = 2,
    comparators = {
      -- Put snippets below everything else
      function(entry1, entry2)
        local kind1 = entry1:get_kind()
        kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
        local kind2 = entry2:get_kind()
        kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
        if kind1 ~= kind2 then
          if kind1 == types.lsp.CompletionItemKind.Snippet then
            return false
          end
          if kind2 == types.lsp.CompletionItemKind.Snippet then
            return true
          end
          local diff = kind1 - kind2
          if diff < 0 then
            return true
          elseif diff > 0 then
            return false
          end
        end
      end,
      -- Default values from here down
      compare.offset,
      compare.exact,
      -- compare.scopes,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    }
  }, sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'vsnip' },
    { name = 'path' }
  }, {
    { name = 'buffer' },
  }),
});

-- Mapping used for / and : completion
local cmdmapping = cmp.mapping.preset.cmdline({
  ['<Tab>'] = {
    c = function()
      -- Fill completion if anything has been typed in
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        -- I don't really know what this does, but it was in the cmp source code
        feedkeys.call(keymap.t('<C-z>'), 'n')
      end
    end,
  },
})

-- Use buffer source for searching with `/` and `?` (if you enabled
-- `native_menu`, this won't work anymore).
for _, v in pairs({ '/', '?' }) do
  cmp.setup.cmdline(v, {
    mapping = cmdmapping,
    sources = {
      { name = 'buffer' }
    }
  })
end

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmdmapping,
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

vim.keymap.set('n', 'qD', function() cmp.setup.buffer { enabled = false } end, { desc = 'Go to declaration' })
-- }}}

-- Mason {{{
require("mason").setup()

local servers = { 'emmet_ls', 'gopls', 'vimls', 'clangd', 'tsserver', 'html', 'pyright',
  'rust_analyzer', 'sumneko_lua', 'bashls', 'jdtls', 'cssls' }
local null_ls_tools = { 'eslint_d', 'prettierd' }

require("mason-lspconfig").setup {
  ensure_installed = servers
}

require('mason-tool-installer').setup {
  ensure_installed = null_ls_tools
}
-- }}}

-- Neodev - needs to be before LSP startup {{{
require("neodev").setup({})
-- }}}

-- LSPs {{{
local border = "single"

-- Add nvim-cmp information
local capabilities = require('cmp_nvim_lsp').default_capabilities()

for _, server in ipairs(servers) do

  if server == 'rust_analyzer' then
    -- rust_analyzer configuration {{{
    require('rust-tools').setup({
      tools = {
        hover_with_actions = false,
        inlay_hints = {
          parameter_hints_prefix = '<- ',
          other_hints_prefix = '» '
        },
        hover_actions = {
          border = border
        }
      },
      server = {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    })
    -- }}}
  else
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    if server == 'sourcekit' then
      -- Fix the path to the toolchain (found via `xcrun --find sourcekit-lsp`) and limit filetypes to not include c/c++
      opts = vim.tbl_deep_extend("force", {
        cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
        filetypes = { "swift", "objective-c", "objective-cpp" }
      }, opts)
    elseif server == 'jdtls' then
      -- Still doesn't work for some reason
      local root_files = {
        -- Single-module projects
        {
          'build.xml', -- Ant
          'pom.xml', -- Maven
          'settings.gradle', -- Gradle
          'settings.gradle.kts', -- Gradle
        },
        -- Multi-module projects
        { 'build.gradle', 'build.gradle.kts' },
      }

      opts = vim.tbl_deep_extend("force", {
        root_dir = function(fname)
          for _, patterns in ipairs(root_files) do
            local root = require('lspconfig.util').root_pattern(unpack(patterns))(fname)
            if root then
              return root
            end
          end

          return vim.fn.getcwd()
        end
      }, opts)
    end

    require('lspconfig')[server].setup(opts)
  end
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border,
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border,
})

-- From https://github.com/neovim/neovim/pull/14878 ; don't focus the quickfix window
local orig_ref_handler = vim.lsp.handlers["textDocument/references"]
vim.lsp.handlers["textDocument/references"] = function(...)
  orig_ref_handler(...)
  vim.cmd [[ wincmd p ]]
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  float = {
    border = border,
    header = { ' Diagnostics:' },
  }
})

-- Floating windows (hover, diagnostics, etc.) mess with Startify sessions
vim.cmd [[ command! CloseFloatingWindows lua _G.CloseFloatingWindows() ]]
_G.CloseFloatingWindows = function()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format('Closed %d windows: %s', #closed_windows, vim.inspect(closed_windows)))
end
-- }}}

-- LSP Saga -- Disabled {{{
-- local saga = require 'lspsaga'

-- saga.init_lsp_saga {
--   use_saga_diagnostic_sign = true,
--   error_sign = '',
--   warn_sign = '',
--   hint_sign = '',
--   infor_sign = '',
--   diagnostic_header_icon = '   ',
--   code_action_icon = ' ',
--   code_action_prompt = {
--     enable = true,
--     sign = true,
--     sign_priority = 20,
--     virtual_text = true,
--   },
--   -- finder_definition_icon = '  ',
--   -- finder_reference_icon = '  ',
--   -- max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
--   -- finder_action_keys = {
--   --   open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
--   -- },
--   code_action_keys = {
--     quit = '<Esc>',
--     exec = '<CR>'
--   },
--   rename_action_keys = {
--     quit = '<Esc>',
--     exec = '<CR>' -- quit can be a table
--   },
--   definition_preview_icon = '  ',
--   border_style = "single", -- "single" "double" "round" "plus"
--   rename_prompt_prefix = '➤',
--   -- if you don't use nvim-lspconfig you must pass your server name and
--   -- the related filetypes into this table
--   -- like server_filetype_map = {metals = {'sbt', 'scala'}}
--   -- server_filetype_map = {}
-- }

-- }}}

-- Nvim-autopairs {{{
require('nvim-autopairs').setup {
  enable_check_bracket_line = false
}

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ tex = false }))

-- }}}

-- null-ls.nvim {{{
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    -- Javascript
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.diagnostics.eslint_d.with({ method = null_ls.methods.DIAGNOSTICS_ON_SAVE }),
    null_ls.builtins.formatting.prettierd,

    -- Python
    null_ls.builtins.diagnostics.flake8.with({ method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      extra_args = { "--max-line-length=88", "--extend-ignore=E203" } }),
    null_ls.builtins.diagnostics.mypy.with({ method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      ---@diagnostic disable-next-line: unused-local
      extra_args = function(params)
        if vim.fn.isdirectory(params.cwd .. "/.venv/") == 1 then
          return { "--python-executable", ".venv/bin/python" }
        end
        return {}
      end }),
    -- null_ls.builtins.formatting.autopep8
    null_ls.builtins.formatting.black,

    -- Swift
    null_ls.builtins.formatting.swiftformat
  },
})

-- What about when things are missing? Is there form validation?
local null_ls_check_group = vim.api.nvim_create_augroup("null_ls_check", {})
local function dir_setup(dir_pattern, callback)
  vim.api.nvim_create_autocmd({ "BufRead", "BufNew" }, {
    pattern = dir_pattern,
    callback = callback,
    group = null_ls_check_group
  })
end

dir_setup("*/CSGenome/website/*", function() null_ls.disable("eslint") end)
dir_setup("*/CSGenome/csg/*", function() null_ls.disable("flake8") end)
-- }}}

-- Telescope {{{
require('telescope').setup {
  defaults = {
    scroll_strategy = "limit",
    -- path_display = "tail",
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    sorting_strategy = "ascending",

    layout_config = {
      horizontal = {
        prompt_position = 'top'
      },
      vertical = {
        mirror = true,
        prompt_position = 'top'
      },
    },
    dynamic_preview_title = true,
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close
      }
    },
  }
}
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = "File search" })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').live_grep, { desc = "Live grep" })

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Telescope picker that lists sessions in descending order of access (most recenly used first)
local sessionpicker = function(opts)
  opts = opts or {}

  -- Use for unsorted (but startify-leveraging) items
  -- local sessions = vim.api.nvim_call_function('startify#session_list', {''})

  -- Use for
  local sessiondir = vim.fn.stdpath('data') .. '/session'
  if vim.g.startify_session_dir ~= nil then
    sessiondir = vim.g.startify_session_dir
  end

  local sessions_exa = vim.fn.system("exa -rs accessed " .. sessiondir)
  local sessions = {}
  for s in sessions_exa:gmatch('[^\n]+') do
    -- Have to filter '__LAST__ -> ...' string from output
    if s:match('__LAST__') == nil then
      table.insert(sessions, s)
    end
  end

  pickers.new(opts, {
    prompt_title = "Session Picker",
    finder = finders.new_table {
      results = sessions
    },
    sorter = conf.generic_sorter(opts),
    ---@diagnostic disable-next-line: unused-local
    attach_mappings = function(prompt_bufnr, _map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd('SLoad ' .. selection[1])
        -- print(selection[1])
      end)
      return true
    end,
  }):find()
end

-- to execute the function
vim.keymap.set('n', '<leader>Pp', sessionpicker, { desc = 'Session picker' })
-- }}}

-- Dressing {{{
require('dressing').setup({
  input = {
    default_prompt = "> ",
    anchor = "NW",
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
      anchor = "NW",
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
  }
})
-- }}}

-- Lightbulb {{{
require('nvim-lightbulb').setup({
  autocmd = { enabled = true }
})
vim.fn.sign_define('LightBulbSign', { text = "", texthl = "LspDiagnosticsSignWarning" })
-- }}}

-- Trouble {{{
require("trouble").setup({})

-- }}}

-- Fidget {{{
require "fidget".setup({
  text = {
    spinner = "square_corners"
  }
})

-- }}}
