return {
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
    keys = {
      { 'gcc', mode = 'n', desc = 'Toggle comment line' },
      { 'gc', mode = 'v', desc = 'Toggle comment block' },
    },
  },
}
