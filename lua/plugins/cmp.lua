return {
  {
    -- Snippet engine (used by cmp)
    'hrsh7th/vim-vsnip',
    event = 'VeryLazy',
    init = function()
      ---@diagnostic disable-next-line: undefined-field
      local os = vim.uv.os_uname().sysname
      ---@diagnostic disable-next-line: undefined-field
      local home = vim.uv.os_homedir()
      if os == "Windows_NT" then
        vim.g.vsnip_snippet_dir = home .. "\\Application Data\\Code\\User\\snippets"
      elseif os == "macOS" then
        vim.g.vsnip_snippet_dir = home .. "/Library/Application Support/Code/User/snippets"
      else
        vim.g.vsnip_snippet_dir = home .. "/.config/Code/User/snippets"
      end
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- cmp sources
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      -- Snippets
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      -- For putting dunder methods lower in list in Python
      'lukas-reineke/cmp-under-comparator',
      {
        "MattiasMTS/cmp-dbee",
        dependencies = {
          { "kndndrj/nvim-dbee" }
        },
        ft = "sql",
        opts = {}, -- needed
      }
    },
    event = 'VeryLazy',
    config = function()
      local cmp = require('cmp')
      local compare = require('cmp.config.compare')
      local types = require('cmp.types')
      local feedkeys = require('cmp.utils.feedkeys')
      local keymap = require('cmp.utils.keymap')

      local function has_words_before()
        ---@diagnostic disable-next-line: deprecated
        table.unpack = table.unpack or unpack -- 5.1 compatibility

        local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local function feedkey(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert"
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
          completion = {
            -- winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
          }
        },
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
          -- Not really sure what this does?
          expandable_indicator = true,

          -- Highlighted type on left, annotation on right
          -- Adapted from https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-add-visual-studio-code-codicons-to-the-menu
          fields = { 'kind', 'abbr', 'menu' },
          format = function(_, vim_item)
            vim_item.kind = " " .. (require("symbols").symbol_map[vim_item.kind] or '') .. " "
            return vim_item
          end,
        },
        experimental = {
          ghost_text = true
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = function(fallback)
            -- Not currently important, but just in case I end up using <C-b> for bolding
            if cmp.visible() then
              cmp.scroll_docs(-4)
            else
              fallback()
            end
          end,
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
              fallback() -- The fallback function sends a already mapped key
            end
          end, { "i", "s" }),
        }),
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset,
            compare.exact,
            function(entry1, entry2)
              ---@type table<integer, integer>
              local modified_priority = {
                -- Variables and methods should be weighed equally
                [types.lsp.CompletionItemKind.Variable] = types.lsp.CompletionItemKind.Method,
                [types.lsp.CompletionItemKind.Constant] = types.lsp.CompletionItemKind.Method,
                [types.lsp.CompletionItemKind.Snippet] = 100, -- bottom
                [types.lsp.CompletionItemKind.Keyword] = 0,   -- top
                [types.lsp.CompletionItemKind.Text] = 100,    -- bottom
              }
              ---@param kind integer: kind of completion entry
              local function modified_kind(kind)
                return modified_priority[kind] or kind
              end

              local kind1 = modified_kind(entry1:get_kind())
              kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
              local kind2 = modified_kind(entry2:get_kind())
              kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
              if kind1 ~= kind2 then
                return kind1 - kind2 < 0
              end
              -- Fall back to nil like original kind sort
              return nil
            end,
            -- compare.scopes,
            compare.score,
            -- Put Python dunder functions lower
            require("cmp-under-comparator").under,
            compare.recently_used,
            compare.locality,
          }
        },
        sources = cmp.config.sources(
          {
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
            { name = 'vsnip' },
            { name = 'path' },
            {
              name = "lazydev",
              -- group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            },
          },
          { { name = 'cmp-dbee' } },
          { { name = 'buffer' }, }
        ),
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
    end
  },
}
