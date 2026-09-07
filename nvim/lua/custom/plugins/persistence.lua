-- persistence.nvim: automatic session save/restore
-- https://github.com/folke/persistence.nvim
--
-- Auto-saves window layout/buffers/cwd on exit; no session restoration
-- previously existed in this config.
return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Session: restore for cwd',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'Session: restore last',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = "Session: don't save on exit",
    },
  },
}
