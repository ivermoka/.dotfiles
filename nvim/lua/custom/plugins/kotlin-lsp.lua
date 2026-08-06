return {
  { 'stevearc/oil.nvim' },
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',

        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',

        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  {
    'AlexandrosAlexiou/kotlin.nvim',
    ft = { 'kotlin' },

    dependencies = {
      'mason.nvim',
      'mason-lspconfig.nvim',
      'trouble.nvim',
      -- nvim-dap is NOT a kotlin.nvim dependency. Install and configure it
      -- separately (signs, keymaps, optionally nvim-dap-ui). kotlin.nvim only
      -- registers a `kotlin` adapter and the `:KotlinDebug` command on top.
      -- See the "Debugging Support" section below for details.
    },
    config = function()
      require('kotlin').setup {
        root_markers = {
          'gradlew',
          '.git',
          'mvnw',
          'settings.gradle',
          'pom.xml',
        },

        -- Optional: JDK for symbol resolution (analyzing your Kotlin code)
        -- This is the JDK that your project code will be analyzed against
        -- (the server itself runs on bin/intellij-server's bundled JBR)
        -- Required for: Analyzing JDK APIs, standard library symbols, platform types
        jdk_for_symbol_resolution = '/home/iverk/.sdkman/candidates/java/current',
        jvm_args = {
          '-Xmx8g', -- Increase max heap (useful for large projects)
        },
        inlay_hints = {
          enabled = true, -- Enable inlay hints (auto-enable on LSP attach)
          parameters = true, -- Show parameter names
          parameters_compiled = true, -- Show compiled parameter names
          parameters_excluded = false, -- Show excluded parameter names
          types_property = true, -- Show property types
          types_variable = true, -- Show local variable types
          function_return = true, -- Show function return types
          function_parameter = true, -- Show function parameter types
          lambda_return = true, -- Show lambda return types
          lambda_receivers_parameters = true, -- Show lambda receivers/parameters
          value_ranges = true, -- Show value ranges
          kotlin_time = true, -- Show kotlin.time warnings
          call_chains = true, -- Show call-chain intermediate types (default false)
        },
        folding = { enabled = true },
        build_tool = 'maven',
        -- defaults (Class, File, Interface, Data Class, Enum, Annotation, Object).
        file_templates = {
          enabled = true,
          Class = 'package ${PACKAGE_NAME}\n\nclass ${NAME} {\n\t|\n}',
        },
      }
    end,
  },
}
