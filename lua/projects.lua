local null_ls_check_group = vim.api.nvim_create_augroup("projects", {})

---Run the given callback when a file in the given directory is hit
---@param dir_pattern string the pattern, with optional globs, to match against
---@param callback fun():nil the function to call when a file is read or created in the directory
local function dir_setup(dir_pattern, callback)
  vim.api.nvim_create_autocmd({ "BufRead", "BufNew", "BufNewFile" }, {
    pattern = dir_pattern,
    callback = callback,
    group = null_ls_check_group
  })
end

---Remap the given file type to another file type if found for the current buffer.
---@param from_ft string the file type to change
---@param to_ft string the file type to map to, if the other is found
local function remap_file(from_ft, to_ft)
  if vim.bo.filetype == from_ft then
    vim.bo.filetype = to_ft
  end
end

dir_setup("*/CSGenome/website/*", function()
  remap_file("javascript", "javascriptreact")
end)

dir_setup("*/CSGenome/csg/*", function()
  require("null-ls").disable("flake8")
end)

dir_setup("*/CSGenome/ML-rewrite/*", function()
  require("null-ls").disable("flake8")
end)
