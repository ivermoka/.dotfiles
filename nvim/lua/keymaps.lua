vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>qq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', 'gj', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic (error/warning)' })
vim.keymap.set('n', 'gk', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic (error/warning)' })

vim.keymap.set('t', '<C-q>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- NOTE: <C-hjkl> window-focus navigation and resize are handled by
-- smart-splits.nvim (see custom/plugins/smart-splits.lua) so they can also
-- cross into tmux panes at the edge of the Neovim layout.

vim.keymap.set('n', '<leader>wh', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<leader>wl', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<leader>wj', '<C-w>J', { desc = 'Move window to the bottom' })
vim.keymap.set('n', '<leader>wk', '<C-w>K', { desc = 'Move window to the top' })

vim.keymap.set('n', '<leader>st', ':TodoQuickFix<CR>', { noremap = true, desc = 'Todo quick fix list' })

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
    if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
      vim.fn.setreg('+', vim.fn.getreg '"')
    end
  end,
})

vim.keymap.set('n', '<leader>tT', ':Themery<CR>', { noremap = true, desc = 'Open Themery plugin' })

-- [[ Window Commands ]]
-- Move between buffers
vim.api.nvim_set_keymap('n', '<S-h>', ':bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true })

-- Delete current buffer (kept off <C-w> so the native window-command
-- prefix, e.g. <C-w>s/<C-w>v/<C-w>q/<C-w>=, stays fully usable)
vim.keymap.set('n', '<leader>bd', ':bd<CR>', { noremap = true, silent = true, desc = '[B]uffer [D]elete' })
