return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = { "nvim-lua/plenary.nvim" },

  keys = {
    {
      "<C-p>",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Find Buffers",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help Tags",
    },
  },

  opts = {
    defaults = {
      layout_strategy = "vertical",
      layout_config = {
        vertical = { width = 0.5 },
      },
    },
  },
}
