return {
  {
    'flash.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    -- stylua: ignore
    keys = {
      { "s",         mode = { "n", "x", "o" }, function() require('flash').jump() end, desc = "Flash", },
      { "S",         mode = { "n", "x", "o" }, function() require('flash').treesitter() end, desc = "Flash Treesitter", },
      { "v",         mode = { "v"},            function() require('flash').treesitter() end, desc = "Flash Treesitter", },
      { "r",         mode = "o",               function() require('flash').remote() end, dsc = "Remote Flash", },
      { "R",         mode = { "o", "x" },      function() require('flash').treesitter_search() end, desc = "Treesitter Search", },

      -- FIXME: Maybe add a notification we toggled?
      -- Make sure this works
      { "<c-s>",     mode = { "c" },           function() require('flash').toggle() end, desc = "Toggle Flash Search", },
    },
  },
}
