-- [[ Setting options ]]
vim.o.number = true
vim.o.relativenumber = false

vim.o.showtabline = 2

vim.o.mouse = 'a'

vim.o.showmode = true

-- Enable break indent
vim.o.breakindent = true

vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.history = 100
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == 'string' and msg:match '-32603' then
    return -- silently ignore that message
  end
  notify(msg, level, opts)
end

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 200

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

vim.o.confirm = true

-- vim: ts=2 sts=2 sw=2 et
