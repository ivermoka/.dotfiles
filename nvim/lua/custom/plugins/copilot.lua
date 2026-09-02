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
  {
    'CopilotC-Nvim/CopilotChat.nvim',

    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },

    cmd = {
      'CopilotChat',
      'CopilotChatOpen',
      'CopilotChatToggle',
    },

    opts = {
      window = {
        layout = 'vertical',
        width = 0.4,
      },

      auto_insert_mode = true,

      trusted_tools = {
        'file',
        'glob',
        'grep',
      },
    },

    keys = {
      {
        '<leader>ac',
        '<cmd>CopilotChatToggle<CR>',
        desc = 'AI Chat',
      },
    },
  },
}
