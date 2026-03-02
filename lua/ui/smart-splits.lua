return {
  {
    -- Better in and around targeting that includes treesitter support
    "smart-splits.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require('smart-splits').setup()
      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<C-h>` will `resize_left` by `(10 * config.default_amount)`
      vim.keymap.set('n', '<C-left>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<C-down>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<C-up>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<C-right>', require('smart-splits').resize_right)
      -- moving between splits
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
      vim.keymap.set('n', '<C-.>', require('smart-splits').move_cursor_previous)
      -- swapping buffers between windows
      vim.keymap.set('n', '<C-S-h>', require('smart-splits').swap_buf_left)
      vim.keymap.set('n', '<C-S-j>', require('smart-splits').swap_buf_down)
      vim.keymap.set('n', '<C-S-k>', require('smart-splits').swap_buf_up)
      vim.keymap.set('n', '<C-S-l>', require('smart-splits').swap_buf_right)
    end
  },
}
