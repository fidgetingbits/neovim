return {
  'modes',
  event = 'VimEnter',
  after = function(plugin)
    local colors = require('catppuccin.palettes').get_palette()
    require('modes').setup({
      colors = {
        copy = colors.sky,
        delete = colors.red,
        change = colors.peach,
        replace = colors.maroon,
        format = colors.yellow,
        insert = colors.green,
        visual = colors.mauve,
      },

      -- Set opacity for cursorline and number background
      line_opacity = 0.15,

      -- Enable cursor highlights
      set_cursor = true,

      -- Enable cursorline initially, and disable cursorline for inactive windows
      -- or ignored filetypes
      set_cursorline = true,

      -- Enable line number highlights to match cursorline
      set_number = true,

      -- Enable sign column highlights to match cursorline
      set_signcolumn = true,

      -- Disable modes highlights for specified filetypes
      -- or enable with prefix "!" if otherwise disabled (please PR common patterns)
      -- Can also be a function fun():boolean that disables modes highlights when true
      ignore = { 'NvimTree', 'TelescopePrompt', '!minifiles' },
    })
  end,
}
