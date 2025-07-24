return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('dashboard').setup {
        theme = 'doom',
        config = {
          header = {
            '╔═════════════════════════════════╗',
            '║                                 ║',
            '║ ██╗   ██╗██╗███╗   ███╗██╗  ██╗ ║',
            '║ ██║   ██║██║████╗ ████║██║ ██╔╝ ║',
            '║ ██║   ██║██║██╔████╔██║█████╔╝  ║',
            '║ ╚██╗ ██╔╝██║██║╚██╔╝██║██╔═██╗  ║',
            '║  ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██╗ ║',
            '║   ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ║',
            '║                                 ║',
            '╚═════════════════════════════════╝',
          },
          center = {
            { icon = '  ', desc = 'Find File', action = 'Telescope find_files' },
            { icon = '  ', desc = 'Recent Files', action = 'Telescope oldfiles' },
            { icon = '  ', desc = 'File Explorer', action = 'Neotree toggle' },
            { icon = '  ', desc = 'Find Word', action = 'Telescope live_grep' },
          },
          footer = { '⚡ Powered by Neovim' },
        },
      }
    end,
  },
}
