return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      --[[ log_level = 'debug', ]]
      format_on_save = { -- synchronous formatting
        lsp_fallback = true,
        timeout_ms = 15000,
        async = false,
      },
      format_after_save = { -- asynchronous formatting
        lsp_fallback = true,
        timeout_ms = 15000,
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        kotlin = { 'ktlint' },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        xml = { 'xmlformatter', stop_after_first = true },
        yaml = { 'yamlfmt', stop_after_first = true },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
