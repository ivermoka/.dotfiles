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
      model = 'claude-opus-5', -- AI model to use
      temperature = 0.1, -- Lower = focused, higher = creative

      -- trusted_tools = nil, -- Require approval for all tool calls

      window = {
        layout = 'vertical', -- 'vertical', 'horizontal', 'float'
        width = 0.4, -- 50% of screen width
        auto_fold = true,
      },

      tools = 'edit',
      trusted_tools = nil,
      auto_insert_mode = true, -- Enter insert mode when opening
      chat_autocomplete = true,
    },

    keys = {
      -- Toggle/open the chat window
      { '<leader>aa', '<cmd>CopilotChatToggle<CR>', desc = 'AI: Toggle Chat', mode = { 'n', 'v' } },
      { '<leader>aq', '<cmd>CopilotChatStop<CR>', desc = 'AI: Stop Response', mode = 'n' },
      { '<leader>ar', '<cmd>CopilotChatReset<CR>', desc = 'AI: Reset Chat', mode = 'n' },
      { '<leader>am', '<cmd>CopilotChatModels<CR>', desc = 'AI: Pick Model', mode = 'n' },

      -- Prompt templates: work on the whole buffer (normal mode)
      -- or on your visual selection (visual mode)
      { '<leader>ae', '<cmd>CopilotChatExplain<CR>', desc = 'AI: Explain Code', mode = { 'n', 'v' } },
      { '<leader>af', '<cmd>CopilotChatFix<CR>', desc = 'AI: Fix Code', mode = { 'n', 'v' } },
      { '<leader>av', '<cmd>CopilotChatReview<CR>', desc = 'AI: Review Code', mode = { 'n', 'v' } },
      { '<leader>ao', '<cmd>CopilotChatOptimize<CR>', desc = 'AI: Optimize Code', mode = { 'n', 'v' } },
      { '<leader>at', '<cmd>CopilotChatTests<CR>', desc = 'AI: Generate Tests', mode = { 'n', 'v' } },
      { '<leader>ad', '<cmd>CopilotChatDocs<CR>', desc = 'AI: Generate Docs', mode = { 'n', 'v' } },
      { '<leader>ac', '<cmd>CopilotChatCommit<CR>', desc = 'AI: Commit Message', mode = 'n' },

      -- Ask a free-form question about the current selection/buffer
      { '<leader>ai', ':CopilotChat ', desc = 'AI: Ask About Selection', mode = { 'n', 'v' } },
    },
  },
}
