local M = {}

---Flip the background and foreground group for a given highlight group
---@param hgroup string
local function flip_highlight(hgroup)
  local ok, group = pcall(vim.api.nvim_get_hl_by_name, hgroup, true)
  if not ok then
    print(hgroup .. " was undefined, but expected")
    return
  end

  -- Get the colours, defaulting to fg colour if background is not defined
  local fg = group.foreground
  local bg = "fg"
  if group.background ~= nil then
    bg = group.background
  end

  -- Swap the colours
  group.foreground = bg
  group.background = fg

  -- vim.pretty_print(group)

  vim.api.nvim_set_hl(0, hgroup, group)
end

function M.reverse_colors()
  local cmp_colors = {
    "CmpItemKind",
    "CmpItemKindText",
    "CmpItemKindMethod",
    "CmpItemKindFunction",
    "CmpItemKindConstructor",
    "CmpItemKindField",
    "CmpItemKindVariable",
    "CmpItemKindClass",
    "CmpItemKindInterface",
    "CmpItemKindModule",
    "CmpItemKindProperty",
    "CmpItemKindUnit",
    "CmpItemKindValue",
    "CmpItemKindEnum",
    "CmpItemKindKeyword",
    "CmpItemKindSnippet",
    "CmpItemKindColor",
    "CmpItemKindFile",
    "CmpItemKindReference",
    "CmpItemKindFolder",
    "CmpItemKindEnumMember",
    "CmpItemKindConstant",
    "CmpItemKindStruct",
    "CmpItemKindEvent",
    "CmpItemKindOperator",
    "CmpItemKindTypeParameter"
  }

  for _, hgroup in ipairs(cmp_colors) do
    flip_highlight(hgroup)
  end
end

return M
