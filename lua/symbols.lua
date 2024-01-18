local M = {}

-- Custom lspkind symbols, before I had codicons
-- M.symbol_map = {
--   Text = "",
--   Method = "",
--   Function = "",
--   Constructor = "",
--   Field = "",
--   Variable = "",
--   Class = "פּ",
--   Interface = "",
--   Module = "",
--   Property = "",
--   Unit = "塞",
--   Value = "",
--   Enum = "練",
--   Keyword = "",
--   Snippet = "",
--   Color = "",
--   File = "",
--   Reference = "",
--   Folder = "",
--   EnumMember = "",
--   Constant = "",
--   Struct = "פּ",
--   Event = "",
--   Operator = "",
--   TypeParameter = ""
-- }

-- Basically just lspkind codicons preset with a couple tweaks
M.symbol_map = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

-- Same as symbol_map, but with spaces after each symbol
M.symbol_map_spaces = {}
for k, v in pairs(M.symbol_map) do
  M.symbol_map_spaces[k] = v .. " "
end

return M
