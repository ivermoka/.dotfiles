return {
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    cmd = 'Copilot',
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,

        keymap = {
          accept = '<M-L>',
          next = '<M-K>',
          prev = '<M-J>',
          dismiss = '<M-H>',
        },
      },

      panel = {
        enabled = false,
      },
    },
  },
}
