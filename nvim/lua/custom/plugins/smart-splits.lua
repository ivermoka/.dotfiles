-- smart-splits.nvim: tmux-aware window navigation + resize
-- https://github.com/mrjones2014/smart-splits.nvim
--
-- Replaces the old <C-hjkl> window-focus keymaps (previously duplicated
-- across keymaps.lua). Detects $TMUX automatically and shells out to
-- `tmux select-pane`/`resize-pane` at the edge of the Neovim layout, so no
-- tmux.conf changes are required.
--
-- NOTE: resize is bound to <C-Up/Down/Left/Right>, not <A-hjkl>, because
-- config/tmux/.tmux.conf already binds `M-h/j/k/l` (unprefixed) to
-- `select-pane` at the root key table -- those keys never reach Neovim.
return {
  'mrjones2014/smart-splits.nvim',
  event = 'VeryLazy',
  opts = {
    ignored_filetypes = { 'nofile', 'quickfix', 'prompt' },
    ignored_buftypes = { 'nofile' },
  },
  keys = {
    {
      '<C-h>',
      function()
        require('smart-splits').move_cursor_left()
      end,
      desc = 'Move focus left (tmux-aware)',
    },
    {
      '<C-j>',
      function()
        require('smart-splits').move_cursor_down()
      end,
      desc = 'Move focus down (tmux-aware)',
    },
    {
      '<C-k>',
      function()
        require('smart-splits').move_cursor_up()
      end,
      desc = 'Move focus up (tmux-aware)',
    },
    {
      '<C-l>',
      function()
        require('smart-splits').move_cursor_right()
      end,
      desc = 'Move focus right (tmux-aware)',
    },
    {
      '<C-Left>',
      function()
        require('smart-splits').resize_left()
      end,
      desc = 'Resize split left',
    },
    {
      '<C-Down>',
      function()
        require('smart-splits').resize_down()
      end,
      desc = 'Resize split down',
    },
    {
      '<C-Up>',
      function()
        require('smart-splits').resize_up()
      end,
      desc = 'Resize split up',
    },
    {
      '<C-Right>',
      function()
        require('smart-splits').resize_right()
      end,
      desc = 'Resize split right',
    },
  },
}
