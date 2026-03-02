return {
  {
    "nvim-notify",
    priority = 1000,
    after = function(plugin)
      local notify = require("notify")
      notify.setup({
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { focusable = false })
        end,
        -- Avoid warning when using transparency
        -- FIXME: Tweak color, only using suggestion from warning for now
        background_colour = "#000000",
      })
      vim.notify = notify
      vim.keymap.set("n", "<Esc>", function()
        notify.dismiss({ silent = true, })
      end, { desc = "dismiss notify popup and clear hlsearch" })
    end,
  },
}
