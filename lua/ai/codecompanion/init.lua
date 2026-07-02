-- Useful resources:
-- Chat editor contexts: https://codecompanion.olimorris.dev/usage/chat-buffer/editor-context
-- Slash commands: https://codecompanion.olimorris.dev/usage/chat-buffer/slash-commands
-- Prompt library: https://codecompanion.olimorris.dev/configuration/prompt-library
-- Keymap: https://codecompanion.olimorris.dev/usage/chat-buffer/#keymaps

-- FIXME: Move this
-- https://github.com/petobens/dotfiles/blob/8a62acb/nvim/lua/plugin-config/codecompanion/mappings.lua#L315
local function explore_open_chats()
  local codecompanion = require('codecompanion')
  local telescope_action_state = require('telescope.actions.state')
  local telescope_actions = require('telescope.actions')
  codecompanion.actions()
  vim.defer_fn(function()
    local picker = telescope_action_state.get_current_picker(vim.api.nvim_get_current_buf())
    picker:move_selection(-1)
    telescope_actions.select_default(picker)
  end, 250)
end

local l = '<leader>a'
return {
  'codecompanion.nvim',
  cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionCmd', 'CodeCompanionActions' },
  -- stylua: ignore
  keys = {
    -- Use an extra alt-one for toggling since chat is often in insert mode.
    { '<A-space>', function() vim.cmd("CodeCompanionChat toggle") end, mode = { 'i', 'n', 't' }, desc = 'CodeCompanion Chat Toggle' },
    { l .. 't', function() vim.cmd("CodeCompanionChat toggle") end, mode = { 'n' }, desc = 'CodeCompanion Chat Toggle' },
    { l .. 'h', function() vim.cmd("CodeCompanion") end, mode = { 'n' }, desc = 'CodeCompanion Inline Prompt' },
    { l .. 'c', function() vim.cmd("CodeCompanionActions") end, mode = { 'n', 'x' }, desc = 'CodeCompanion Actions' },
    { l .. 'f', explore_open_chats, mode = { 'n', }, desc = 'CodeCompanion Find Chats' },
    { 'ga', function() vim.cmd("CodeCompanionChat add") end, mode = { 'x', }, { noremap = true, desc = 'CodeCompanion Add Selection to chat' }},
  },
  after = function(_plugin)
    require('codecompanion').setup({
      opts = {
        opts = {
          log_level = 'DEBUG',
        },
      },
      extensions = {
        -- FIXME: says spinner extension not found
        -- spinner = {},
      },
      -- FIXME: Need a way to configure defaults based on what system it is
      -- probably use hostname? We should setup something similar to nixInfo
      -- or just actually put it in nixInfo?
      strategies = {
        chat = {
          adapter = 'oedo',
        },
        inline = {
          adapter = 'oedo',
        },
      },
      adapters = {
        http = {
          opts = {
            show_presets = false, -- Only show what I've explicitly configured
          },
          ossa = require('ai.codecompanion.adapters.ossa'),
          oedo = require('ai.codecompanion.adapters.oedo'),
          gemini = require('ai.codecompanion.adapters.gemini'),
          openrouter = require('ai.codecompanion.adapters.openrouter'),
          nvidia_nim = require('ai.codecompanion.adapters.nvidia_nim'),
        },

        -- FIXME: Failed attempt at connecting into microvm and running claude code
        -- as the agent
        acp = {
          opts = {
            show_presets = false, -- Only show what I've explicitly configured
          },
          nano = require('ai.codecompanion.adapters.nano'),
        },
        cli = {
          opts = {
            show_presets = false, -- Only show what I've explicitly configured
          },
        },
      },

      display = {
        chat = {
          start_in_insert_mode = true,
        },
        -- FIXME: Use some config setting for if we have snacks enabled
        action_palette = {
          provider = 'telescope',
        },
      },
    })
    -- Expand cc in commandline mode
    vim.cmd.cab('cc CodeCompanion')

    -- Noice notification pop-up during CodeCompanion commands
    require('ai.codecompanion.extensions.notification').init()
  end,
}
