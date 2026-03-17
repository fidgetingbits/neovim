return {
  {
    'nvim-better-n',
    lazy = false,
    after = function(_)
      local better_n = require('better-n')
      better_n.setup({})

      -- FIXME: None of these listen() ones work yet, despite following README
      -- stylua: ignore
      better_n.listen('%]%]', { next = ']]', prev = '[[', remap = true, expr = true })
      better_n.listen('%[%[', { next = '[[', prev = ']]', remap = true, expr = true })

      better_n.listen('(%d-)j(.*)', {
        -- Arguments will be what was matched in the pattern above
        match = function(count, rest)
          return (tonumber(d) or 1) >= 5
        end,
        next = '5j', -- Moving down by display line
        prev = '5k', -- Moving up by display line
        remap = true, -- Honor existing remaps, such as j => gj
      })
    end,
  },
}
