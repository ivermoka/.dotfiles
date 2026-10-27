return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'buffers', -- or "tabs"
          diagnostics = 'nvim_lsp',
          show_buffer_close_icons = false,
          show_close_icon = true,
          separator_style = 'slant',
          hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' },
          },
          offsets = {
            {
              filetype = 'neo-tree',
              text = 'File Explorer',
              text_align = 'center',
              separator = true,
              highlight = 'Directory',
            },
          },
        },
      }
    end,
  },
}
