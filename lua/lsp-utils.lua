-- vim: set fdm=marker fmr={{{,}}} fdl=0:

local M = {}

-- Add cmp capabilities to default ones
M.capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Single border that will be used around all floating windows
local border = 'single'
M.border = border

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lspattach", {}),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

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
    if vim.lsp.inlay_hint ~= nil and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
  end,
})


-- From https://github.com/MariaSolOs/dotfiles/blob/bda5388e484497b8c88d9137c627c0f24ec295d7/.config/nvim/lua/lsp.lua
local md_namespace = vim.api.nvim_create_namespace('mariasolos/lsp_float')

---LSP handler that adds extra inline highlights, keymaps, and window options.
---Code inspired from `noice`.
---@param handler fun(err: any, result: any, ctx: any, config: any): integer, integer
---@return function
local function enhanced_float_handler(handler)
  return function(err, result, ctx, config)
    local buf, win = handler(
      err,
      result,
      ctx,
      vim.tbl_deep_extend('force', config or {}, {
        border = border,
      })
    )

    if not buf or not win then
      return
    end

    -- Conceal everything.
    vim.wo[win].concealcursor = 'n'

    -- Extra highlights.
    for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      for pattern, hl_group in pairs {
        ['|%S-|'] = '@text.reference',
        ['@%S+'] = '@parameter',
        ['^%s*(Parameters:)'] = '@text.title',
        ['^%s*(Return:)'] = '@text.title',
        ['^%s*(See also:)'] = '@text.title',
        ['{%S-}'] = '@parameter',
      } do
        local from = 1 ---@type integer?
        while from do
          local to
          from, to = line:find(pattern, from)
          if from then
            vim.api.nvim_buf_set_extmark(buf, md_namespace, l - 1, from - 1, {
              end_col = to,
              hl_group = hl_group,
            })
          end
          from = to and to + 1 or nil
        end
      end
    end

    -- Add keymaps for opening links.
    if not vim.b[buf].markdown_keys then
      vim.keymap.set('n', 'K', function()
        -- Vim help links.
        local url = (vim.fn.expand '<cWORD>' --[[@as string]]):match '|(%S-)|'
        if url then
          return vim.cmd.help(url)
        end

        -- Markdown links.
        local col = vim.api.nvim_win_get_cursor(0)[2] + 1
        local from, to
        from, to, url = vim.api.nvim_get_current_line():find '%[.-%]%((%S-)%)'
        if from and col >= from and col <= to then
          vim.system({ 'open', url }, nil, function(res)
            if res.code ~= 0 then
              vim.notify('Failed to open URL' .. url, vim.log.levels.ERROR)
            end
          end)
        end
      end, { buffer = buf, silent = true })
      vim.b[buf].markdown_keys = true
    end
  end
end

if vim.fn.has('nvim-0.10.0') == 1 then
  -- Depends on treesitter markdown for floats, so only works in 0.10+
  vim.lsp.handlers['textDocument/hover'] = enhanced_float_handler(vim.lsp.handlers.hover)
  vim.lsp.handlers['textDocument/signatureHelp'] = enhanced_float_handler(vim.lsp.handlers.signature_help)
else
  -- Just put border around the standard popups
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border, })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border, })
end

-- From https://github.com/neovim/neovim/pull/14878 ; don't focus the quickfix window
local orig_ref_handler = vim.lsp.handlers["textDocument/references"]
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.handlers["textDocument/references"] = function(...)
  orig_ref_handler(...)
  vim.cmd [[ wincmd p ]]
end

-- Use custom icons in gutter
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Custom header for diagnostics
vim.diagnostic.config({
  float = {
    border = border,
    header = { ' Diagnostics:' },
    -- Show source if there are multiple in the buffer
    source = "if_many"
  }
})

-- Floating windows (hover, diagnostics, etc.) mess with Startify sessions
-- The created command is called during startify shutdown
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
return M
