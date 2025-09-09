-- Easier esc in terminal
-- tnoremap <Esc> <C-\><C-n>
-- tnoremap <C-w> <C-\><C-n>
-- tnoremap <C-w> <C-\><C-n><C-w>
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

-- Make Y behave like any other capital letter
vim.keymap.set("n", "Y", "y$", { silent = true })

-- Navigate lines visually when lines are wrapped
vim.keymap.set("", "j", "gj", { silent = true })
vim.keymap.set("", "k", "gk", { silent = true })

-- Add semicolon to end of line without messing up cursor position
vim.keymap.set("n", "<leader>;", ":normal! mqA;<Esc>`q", { silent = true, desc = "EOL semicolon" })

vim.keymap.set("n", "]q", ":cn<CR>", { silent = true })
vim.keymap.set("n", "[q", ":cp<CR>", { silent = true })
vim.keymap.set("n", "]Q", ":cnf<CR>", { silent = true })
vim.keymap.set("n", "[Q", ":cpf<CR>", { silent = true })
vim.keymap.set("n", "<leader>qq", ":cclose<CR>", { silent = true })

-- Maximise height/width of current window w/o using <C-w>_ or <C-w>| (awkward keybindings)
vim.keymap.set("", "<leader>m", "<C-w>_", { silent = true, desc = "Max height" })
vim.keymap.set("", "<leader>M", "<C-w>|", { silent = true, desc = "Max width" })

if vim.fn.has('win64') == 1 or vim.fn.has('win32') == 1 then
  -- Remap C-n/C-p (set to down/up with Powertoys) so they work like normal
  vim.keymap.set("", "<Down>", "<C-n>", { remap = true })
  vim.keymap.set("!", "<Down>", "<C-n>", { remap = true })
  vim.keymap.set("", "<Up>", "<C-p>", { remap = true })
  vim.keymap.set("!", "<Up>", "<C-p>", { remap = true })
end
