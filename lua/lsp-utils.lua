-- vim: set fdm=marker fmr={{{,}}} fdl=0:

local M = {}

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

-- Add cmp capabilities to default ones
M.capabilities = require('cmp_nvim_lsp').default_capabilities()

return M
