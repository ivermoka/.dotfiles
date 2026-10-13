-- Split below the current editor window (not full-width) so neo-tree keeps its column
local function open_term(index)
  if vim.bo.filetype == 'neo-tree' then
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype ~= 'neo-tree' and vim.api.nvim_win_get_config(win).relative == '' then
        vim.api.nvim_set_current_win(win)
        break
      end
    end
  end
  require('betterTerm').open(index)
end

return {
  'CRAG666/betterTerm.nvim',
  keys = {
    {
      mode = { 'n', 't' },
      '<leader>t0',
      function()
        open_term()
      end,
      desc = 'Open BetterTerm 0',
    },
    {
      mode = { 'n', 't' },
      '<leader>t1',
      function()
        open_term(1)
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
    position = 'below',
    size = 10,
    startInserted = true,
  },
}
