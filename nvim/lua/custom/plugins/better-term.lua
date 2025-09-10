return {
  'CRAG666/betterTerm.nvim',
  keys = {
    {
      mode = { 'n', 't' },
      '<leader>t0',
      function()
        require('betterTerm').open()
      end,
      desc = 'Open BetterTerm 0',
    },
    {
      mode = { 'n', 't' },
      '<leader>t1',
      function()
        require('betterTerm').open(1)
      end,
      desc = 'Open BetterTerm 1',
    },
    {
      mode = 'n',
      '<leader>tt',
      function()
        require('betterTerm').select()
      end,
      desc = 'Select terminal',
    },
  },
  opts = {
    position = 'bot',
    size = 10,
    startInserted = false,

    -- TODO: Fix mapping
    jump_tab_mapping = '<C-ø>',
  },
}
