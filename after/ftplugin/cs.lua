local hooks = require "ibl.hooks"

-- #!
-- #:
-- #nullable
-- #if elif else endif
-- #define undef
-- #region endregion
-- #error warning line
-- #pragma

local function skip_preproc_lines(_, _, _, line)
  for _, pattern in ipairs {
    -- List from https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/preprocessor-directives
    "^#!",
    "^#:",
    "^#nullable",
    "^#if",
    "^#elif",
    "^#else",
    "^#endif",
    "^#define",
    "^#undef",
    "^#region",
    "^#endregion",
    "^#error",
    "^#warning",
    "^#line",
    "^#pragma",
  } do
    if line:match(pattern) then
      return true
    end
  end
  return false
end

hooks.register(
  hooks.type.SKIP_LINE,
  skip_preproc_lines,
  { bufnr = 0 }
)
