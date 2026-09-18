vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- neo-tree replaces netrw; must be disabled before anything else touches it
-- to avoid the two fighting over directory buffers.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'
