return {
  -- FIXME: Finish this
  {
    "flash.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      -- FIXME: Test this for awhile and revisit
      {
        "<leader>j",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<leader>J",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-j>",
        mode = { "c" },
        function()
          require("flash").toggle()
          -- FIXME: probably notify?
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
}
