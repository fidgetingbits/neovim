return {
  -- FIXME: Finish this
  {
    'flash.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    -- stylua: ignore
    keys = {
      -- FIXME: Test this for awhile and revisit
      { "<leader>j", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash", },
      { "<leader>J", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter", },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash", },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search", },
      -- FIXME: Maybe add a notification we toggled?
      { "<c-j>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search", },
    },
  },
}
