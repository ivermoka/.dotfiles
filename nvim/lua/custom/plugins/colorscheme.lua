return {
  {
    'zaldih/themery.nvim',
    lazy = false,
    config = function()
      local themery = require 'themery'

      themery.setup {
        themes = {
          {
            name = 'Tokyonight Storm',
            colorscheme = 'tokyonight-storm',
            before = [[
              require('tokyonight').setup{
                styles = { comments = { italic = false } },
                on_highlights = function(highlights, colors)
                  highlights.normal = { fg = '#ffffff', bg = colors.bg }
                  highlights.comment = { fg = '#b5b5b5', italic = false }
                end,
              }
            ]],
          },
          {
            name = 'Tokyonight Moon',
            colorscheme = 'tokyonight-moon',
            before = [[
              require('tokyonight').setup{
                styles = { comments = { italic = false } },
                on_highlights = function(highlights, colors)
                  highlights.normal = { fg = '#ffffff', bg = colors.bg }
                  highlights.comment = { fg = '#b5b5b5', italic = false }
                end,
              }
            ]],
          },
          {
            name = 'Tokyonight Night',
            colorscheme = 'tokyonight-night',
            before = [[
              require('tokyonight').setup{
                styles = { comments = { italic = false } },
                on_highlights = function(highlights, colors)
                  highlights.normal = { fg = '#ffffff', bg = colors.bg }
                  highlights.comment = { fg = '#b5b5b5', italic = false }
                end,
              }
            ]],
          },

          {
            name = 'Kanagawa Lotus',
            colorscheme = 'kanagawa',
            before = [[
              require('kanagawa').setup {
	      	background = 'dark',
                compile = false,
                undercurl = true,
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,
                terminalColors = true,
                colors = {
                  palette = {},
                  theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
                },
                overrides = function(colors)
                  return {}
                end,
                theme = 'lotus',
              }
            ]],
          },
        },
        {
          name = 'Kanagawa Wave',
          colorscheme = 'kanagawa',
          before = [[
              require('kanagawa').setup {
                compile = false,
                background = 'dark',
		undercurl = true,
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,
                terminalColors = true,
                colors = {
                  palette = {},
                  theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
                },
                overrides = function(colors)
                  return {}
                end,
                theme = 'wave',
              }
            ]],
        },
        {
          name = 'Kanagawa Dragon',
          colorscheme = 'kanagawa',
          before = [[
              require('kanagawa').setup {
                compile = false,
                undercurl = true,
		background = 'dark',
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true },
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,
                terminalColors = true,
                colors = {
                  palette = {},
                  theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
                },
                overrides = function(colors)
                  return {}
                end,
                theme = 'dragon',
              }
            ]],
        },

        livePreview = true,
      }

      themery.setThemeByName('Tokyonight Storm', true)
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
  },
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
  },
}
