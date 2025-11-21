vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>wh', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<leader>wl', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<leader>wj', '<C-w>J', { desc = 'Move window to the bottom' })
vim.keymap.set('n', '<leader>wk', '<C-w>K', { desc = 'Move window to the top' })

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

-- [[ Window Commands ]]
-- Move between buffers
vim.api.nvim_set_keymap('n', '<S-h>', ':bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true })

-- Previous buffer
vim.api.nvim_set_keymap('n', '<C-h>', '<C-O>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-l>', '<C-I>', { noremap = true, silent = true })

-- Delete current buffer
vim.api.nvim_set_keymap('n', '<C-w>', ':bd<CR>', { noremap = true, silent = true })

-- Go to Neo-tree (left)
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window (Neo-tree)' })

-- Go to editor (right)
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window (Editor)' })
