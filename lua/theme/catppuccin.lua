return {
  'catppuccin/nvim',
  name = 'catppuccin-nvim', -- required for nixcats to recognize
  lazy = false,
  priority = 1000,
  after = function(plugin)
    require('catppuccin').setup({
      transparent_background = true,
      auto_integrations = true,
      -- FIXME: not sure if auto integration works with lze
      integrations = {
        gitsigns = true,
        neotree = true,
        notify = true,
        treesitter = true,
        ufo = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        local utils = require('catppuccin.utils.colors')

        -- Helper function to blend heading colors with the background (15% opacity)
        local function bg_blend(color)
          return utils.blend(color, colors.base, 0.15)
        end

        return {
          -- Foreground/Text highlights
          ['@markup.heading.1.markdown'] = { fg = colors.red, style = { 'bold' } },
          ['@markup.heading.2.markdown'] = { fg = colors.blue, style = { 'bold' } },
          ['@markup.heading.3.markdown'] = { fg = colors.green, style = { 'bold' } },
          ['@markup.heading.4.markdown'] = { fg = colors.mauve, style = { 'bold' } }, -- Violet
          ['@markup.heading.5.markdown'] = { fg = colors.sky, style = { 'bold' } }, -- Cyan
          ['@markup.heading.6.markdown'] = { fg = colors.yellow, style = { 'bold' } },

          -- RenderMarkdown icon/text highlights (matching the above)
          RenderMarkdownH1 = { fg = colors.red, style = { 'bold' } },
          RenderMarkdownH2 = { fg = colors.blue, style = { 'bold' } },
          RenderMarkdownH3 = { fg = colors.green, style = { 'bold' } },
          RenderMarkdownH4 = { fg = colors.mauve, style = { 'bold' } },
          RenderMarkdownH5 = { fg = colors.sky, style = { 'bold' } },
          RenderMarkdownH6 = { fg = colors.yellow, style = { 'bold' } },

          -- Background highlights
          RenderMarkdownH1Bg = { bg = bg_blend(colors.red) },
          RenderMarkdownH2Bg = { bg = bg_blend(colors.blue) },
          RenderMarkdownH3Bg = { bg = bg_blend(colors.green) },
          RenderMarkdownH4Bg = { bg = bg_blend(colors.mauve) },
          RenderMarkdownH5Bg = { bg = bg_blend(colors.sky) },
          RenderMarkdownH6Bg = { bg = bg_blend(colors.yellow) },
        }
      end,
    })
  end,
}
