vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Window Commands ]]

-- Next buffer on Tab
vim.api.nvim_set_keymap('n', 'g<Tab>', ':bnext<CR>', { noremap = true, silent = true })

-- Previous buffer on Shift+Tab
vim.api.nvim_set_keymap('n', 'g<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })

-- Delete current buffer

vim.api.nvim_set_keymap('n', '<C-w>', ':bd<CR>', { noremap = true, silent = true })

-- Go to Neo-tree (left)
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window (Neo-tree)' })

-- Go to editor (right)
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window (Editor)' })

-- [[ Compiler.lua ]]

vim.api.nvim_set_keymap('n', '<leader>c', '<cmd>CompilerOpen<cr>', { noremap = true, silent = true })

-- Redo last selected option
vim.api.nvim_set_keymap(
  'n',
  '<S-F6>',
  '<cmd>CompilerStop<cr>' -- (Optional, to dispose all tasks before redo)
    .. '<cmd>CompilerRedo<cr>',
  { noremap = true, silent = true }
)

-- Toggle compiler results
vim.api.nvim_set_keymap('n', '<S-F7>', '<cmd>CompilerToggleResults<cr>', { noremap = true, silent = true })
