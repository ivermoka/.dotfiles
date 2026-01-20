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
            { icon = '  ', desc = 'Grep', action = 'Telescope live_grep' },
            { icon = '  ', desc = 'LazyGit', action = 'LazyGit' },
            { icon = '  ', desc = 'Edit Config', action = 'edit ~/.config/nvim/' },
            { icon = '  ', desc = 'Edit dotfiles', action = 'edit ~/projects/.dotfiles/' },
          },
          footer = { '  Powered by milk' },
        },
      }
    end,
  },
}
