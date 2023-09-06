-- vim: set fdm=marker fmr={{{,}}} fdl=0:

local M = {}

-- On attach/keybindings: {{{
---@diagnostic disable-next-line: unused-local
M.lsp_on_attach = function(client, bufnr)
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
  vim.keymap.set('n', 'gm', vim.lsp.buf.implementation, opts('Go to implementation'))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts('Go to references'))

  -- Trouble only works with its list and provides no preview
  vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts('Go to previous diagnostic'))
  -- vim.keymap.set('n', '[g', function() require('trouble').previous({ skip_groups = true, jump = true }) end, opts('Go to previous diagnostic'))
  vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts('Go to next diagnostic'))
  -- vim.keymap.set('n', ']g', function() require('trouble').next({ skip_groups = true, jump = true }) end, opts('Go to next diagnostic'))

  vim.keymap.set('n', '<leader>qwa', vim.lsp.buf.add_workspace_folder, opts('Add workspace folder'))
  vim.keymap.set('n', '<leader>qwr', vim.lsp.buf.remove_workspace_folder, opts('Remove workspace folder'))
  vim.keymap.set('n', '<leader>qwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    opts('List workspace folders'))
  vim.keymap.set('n', '<leader>qr', vim.lsp.buf.rename, opts('Rename symbol'))
  vim.keymap.set({ 'n', 'v' }, '<leader>qa', vim.lsp.buf.code_action, opts('Code action'))
  vim.keymap.set('n', '<leader>qc', vim.lsp.codelens.run, opts('Code lens'))

  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts('Format buffer'))
  vim.keymap.set('v', '<leader>f', vim.lsp.buf.format, opts('Format buffer'))

  vim.keymap.set('n', '<leader>qd', vim.diagnostic.disable, opts('Disable diagnostics'))

  vim.keymap.set('n', '<leader>qg', require('telescope.builtin').diagnostics, opts('List diagnostics'))
  vim.keymap.set('n', '<leader>qo', require('telescope.builtin').lsp_document_symbols, opts('List document symbols'))
  vim.keymap.set('n', '<leader>qwo', require('telescope.builtin').lsp_dynamic_workspace_symbols,
    opts('List workspace symbols'))

  -- Allow nvim's Lua API completion+docs to be set up with a keypress
  if vim.bo.filetype == 'c' or vim.bo.filetype == 'cpp' then
    vim.keymap.set('n', '<leader>qh', ':ClangdSwitchSourceHeader<CR>', opts('Switch header/source'))
  end

  -- Set up code lenses
  if client.server_capabilities.codeLensProvider then
    -- Refresh code lenses
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("codelens", {}),
      callback = vim.lsp.codelens.refresh,
      buffer = bufnr,
    })
  end

  -- Enable inlay hints
  if vim.fn.has("nvim-0.10.0") and client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint(bufnr, true)
  end
end
-- }}}

local servers = { 'emmet_ls', 'gopls', 'vimls', 'clangd', 'tsserver', 'html', 'pyright',
  'rust_analyzer', 'lua_ls', 'bashls', 'jdtls', 'cssls' }

-- Neodev - needs to be before LSP startup {{{
require("neodev").setup({})
-- }}}

-- LSPs {{{
local border = "single"

-- Add nvim-cmp information
-- TODO: Put it back to cmp's defaults
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = capabilities

for _, server in ipairs(servers) do
  if server == 'jdtls' then
    -- Skip b/c configuerd in after/ftplugin/java.lua
  elseif server == 'rust_analyzer' then
    -- rust-tools.nvim {{{
    require('rust-tools').setup({
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
        on_attach = M.lsp_on_attach,
        capabilities = capabilities,
      }
    })
    -- }}}
  else
    local opts = {
      on_attach = M.lsp_on_attach,
      capabilities = capabilities,
    }

    if server == 'sourcekit' then
      -- Fix the path to the toolchain (found via `xcrun --find sourcekit-lsp`) and limit filetypes to not include c/c++
      opts = vim.tbl_deep_extend("force", {
        cmd = { "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp" },
        filetypes = { "swift", "objective-c", "objective-cpp" }
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
---@diagnostic disable-next-line: duplicate-set-field
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
    if config.relative ~= "" then        -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not force
      table.insert(closed_windows, win)
    end
  end
  print(string.format('Closed %d windows: %s', #closed_windows, vim.inspect(closed_windows)))
end
-- }}}

return M
