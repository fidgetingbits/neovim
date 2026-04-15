-- Primary AI functionality is done with ./codecompanion.lua
-- This file setups copilot.lua to allow authentication for github, and
-- for Next Edit Suggestions (NES) provided by copilot LSP. No other
-- copilot.lua functionality is configured/used
--
-- NOTE: It is disabled by default on purpose, so you don't leak private content
--
-- FIXME: Replace copilot NES with something that allows NES based on whatever
-- adapter is configured with codecompanion
--
-- FIXME: Allow attaching to a single buffer, rather than enabling and attaching to all
-- buffers, in case we have files open we don't want exposed, but want tweaks in one

return {
  {
    'copilot.lua',
    after = function(plugin)
      require('copilot').setup({
        server_opts_overrides = {
          settings = {
            telemetry = {
              telemetryLevel = 'off',
            },
          },
        },
        -- Using code-companion
        panel = { enabled = false },
        suggestion = { enabled = false },
        -- NES using copilot-lsp defined below
        nes = {
          enabled = true,
          keymap = {
            accept_and_goto = '<C-y>',
            accept = false,
            dismiss = '<Esc>',
          },
        },
      })

      vim.cmd('silent! Copilot disable')

      -- ai, pilot
      local l = '<leader>ap'
      -- stylua: ignore start
      vim.keymap.set('n', l .. 'd', function()
        vim.cmd('Copilot disable')
        vim.notify("Copilot disabled")
      end, { desc = 'Disable Copilot', silent = true, })
      vim.keymap.set('n', l .. 'e', function()
        vim.cmd('Copilot enable')
        vim.notify("Copilot enabled.")
      end,  { desc = 'Enable Copilot', silent = true, })
      vim.keymap.set('n', l .. 's', function() vim.cmd('Copilot status') end,  { desc = 'Copilot Status' })
      -- stylua: ignore end
    end,
  },
  {
    'copilot-lsp',
    dep_of = { 'copilot.lua' },
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable('copilot_ls')
      vim.lsp.config('copilot_ls')
    end,
    after = function(plugin)
      vim.keymap.set({ 'n', 'i' }, '<C-a>', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local state = vim.b[bufnr].nes_state
        if state then
          -- Try to jump to the start of the suggestion edit.
          -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
          local _ = require('copilot-lsp.nes').walk_cursor_start_edit()
            or (
              require('copilot-lsp.nes').apply_pending_nes()
              and require('copilot-lsp.nes').walk_cursor_end_edit()
            )
          return nil
        else
          return nil
        end
      end, { desc = 'Accept Copilot NES suggestion', expr = true })

      -- stylua: ignore start
      vim.keymap.set({ 'i', 'n' }, '<c-;>', function() require('copilot-lsp.nes').clear() end, { desc = 'Clear Copilot suggestion' })
      -- stylua: ignore end
    end,
  },
}
