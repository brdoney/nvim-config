local function run_rainbow_align()
  -- Ignore "already formatted" error from RainbowAlign
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, 'RainbowAlign')
  -- local success, _ = pcall(vim.cmd, 'RainbowAlign')
  -- if not success then
  --   print("RainbowAlign command failed, but errors are ignored.")
  -- end
end

return {
  -- Rainbow CSV and querying
  {
    'mechatroner/rainbow_csv',
    ft = { "csv", "tsv", "csv_semicolon", "csv_whitespace", "csv_pipe" },
    keys = {
      { '<leader>f', run_rainbow_align, mode = 'n', { desc = 'Rainbow Align' } },
      { '<M-F>',     run_rainbow_align, mode = 'n', { desc = 'Rainbow Align' } }
    },
  },
}
