return {
  'resession.nvim',
  lazy = false,
  after = function()
    local resession = require('resession')
    resession.setup({
      autosave = {
        enabled = true,
        interval = 60,
        notify = true, -- FIXME: Double check what this is like
      },
      extensions = {
        lualine = {},
      },
      -- FIXME: This is old possession
      -- hooks = {
      --   before_save = function()
      --     local user_data = {}
      --     -- Don't bother saving the state of open tooling
      --
      --     -- TODO: Decide if I want this after testing neotree plugin
      --     -- pcall(function()
      --     --   vim.cmd("Neotree close")
      --     -- end)
      --     pcall(function()
      --       require('dapui').close()
      --     end)
      --     pcall(function()
      --       require('neogit').close()
      --     end)
      --
      --     return {
      --       lualine = lualine_before_save(),
      --     }
      --   end,
      --
      --   after_load = function(name, user_data)
      --     lualine_after_load(name, user_data.lualine)
      --   end,
      -- },
    })
    
    -- stylua: ignore start
    local r = require('resession')
    vim.keymap.set('n', '<leader>ps', resession.save,   { desc = 'Save session' })
    vim.keymap.set('n', '<leader>pl', resession.load,   { desc = 'Load session' })
    vim.keymap.set('n', '<leader>pd', resession.delete, { desc = 'Delete session' })
    vim.keymap.set('n', '<leader>px', resession.detach, { desc = 'Close session' })
    -- stylua: ignore end

    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = function()
        -- Always save a special session named "last"
        resession.save('last')
      end,
    })
  end,
}

