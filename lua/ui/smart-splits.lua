return {
  {
    'smart-splits.nvim',
    lazy = false,
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('smart-splits').setup({
        at_edge = function(ctx)
          if ctx.direction == 'left' then
            vim.cmd('tabprevious')
          elseif ctx.direction == 'right' then
            vim.cmd('tabnext')
          end
        end,
      })

      local modes = { 't', 'n', 'v' }
      local ss = require('smart-splits')

      -- FIXME: Probably drop the non-terminal mode stuff
      -- stylua: ignore start
      if nixInfo(false, 'settings', 'terminalMode') then
        vim.keymap.set(modes, '<A-h>', function() ss.move_cursor_left() end,  { desc = "Move pane left" })
        vim.keymap.set(modes, '<A-j>', function() ss.move_cursor_down() end,  { desc = "Move pane left" })
        vim.keymap.set(modes, '<A-k>', function() ss.move_cursor_up() end,    { desc = "Move pane left" })
        vim.keymap.set(modes, '<A-l>', function() ss.move_cursor_right() end, { desc = "Move pane left" })
        modes = { 't', 'v', 'i', 'n' }
        vim.keymap.set(modes, '<A-S-h>',   function() ss.swap_buf_left() end,  { desc = "Swap pane left" })
        vim.keymap.set(modes, '<A-S-j>',   function() ss.swap_buf_down() end,  { desc = "Swap pane down" })
        vim.keymap.set(modes, '<A-S-k>',   function() ss.swap_buf_up() end,    { desc = "Swap pane up" }) 
        vim.keymap.set(modes, '<A-S-l>',   function() ss.swap_buf_right() end, { desc = "Swap pane right" })

        -- NOTE: these accept a range: `10<A-left>` will `resize_left` by `(10 * config.default_amount)`
        vim.keymap.set(modes, '<A-left>',  function() ss.resize_left() end,    { desc = "Resize pane left" })
        vim.keymap.set(modes, '<A-down>',  function() ss.resize_down() end,    { desc = "Resize pane down" } )
        vim.keymap.set(modes, '<A-up>',    function() ss.resize_up() end,      { desc = "Resize pane up" } )
        vim.keymap.set(modes, '<A-right>', function() ss.resize_right() end,   { desc = "Resize pane right" })
      else
        vim.keymap.set('n', '<C-left>',  require('smart-splits').resize_left)
        vim.keymap.set('n', '<C-down>',  require('smart-splits').resize_down)
        vim.keymap.set('n', '<C-up>',    require('smart-splits').resize_up)
        vim.keymap.set('n', '<C-right>', require('smart-splits').resize_right)
        -- moving between splits
        vim.keymap.set('n', '<C-h>',     require('smart-splits').move_cursor_left)
        vim.keymap.set('n', '<C-j>',     require('smart-splits').move_cursor_down)
        vim.keymap.set('n', '<C-k>',     require('smart-splits').move_cursor_up)
        vim.keymap.set('n', '<C-l>',     require('smart-splits').move_cursor_right)
        vim.keymap.set('n', '<C-.>',     require('smart-splits').move_cursor_previous)
        -- swapping buffers between windows
        vim.keymap.set('n', '<C-S-h>',   require('smart-splits').swap_buf_left)
        vim.keymap.set('n', '<C-S-j>',   require('smart-splits').swap_buf_down)
        vim.keymap.set('n', '<C-S-k>',   require('smart-splits').swap_buf_up)
        vim.keymap.set('n', '<C-S-l>',   require('smart-splits').swap_buf_right)
      end
      -- stylua: ignore end
    end,
  },
}
