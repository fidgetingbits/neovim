-- Useful resources:
-- Chat editor contexts: https://codecompanion.olimorris.dev/usage/chat-buffer/editor-context
-- Slash commands: https://codecompanion.olimorris.dev/usage/chat-buffer/slash-commands
-- Prompt library: https://codecompanion.olimorris.dev/configuration/prompt-library
-- Keymap: https://codecompanion.olimorris.dev/usage/chat-buffer/#keymaps

-- FIXME: Move this
-- https://github.com/petobens/dotfiles/blob/8a62acb51ab5076aec2d578dbd4e77b5f718a089/nvim/lua/plugin-config/codecompanion/mappings.lua#L315
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

return {
  'codecompanion.nvim',
  cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionCmd', 'CodeCompanionActions' },
  -- stylua: ignore
  keys = {
    { '<leader>ct', function() vim.cmd("CodeCompanionChat toggle") end, mode = { 'n' }, desc = 'CodeCompanion Chat Toggle' },
    { '<leader>ch', function() vim.cmd("CodeCompanion") end, mode = { 'n' }, desc = 'CodeCompanion Inline Prompt' },
    { '<leader>cc', function() vim.cmd("CodeCompanionActions") end, mode = { 'n', 'v' }, desc = 'CodeCompanion Actions' },
    { '<leader>cf', explore_open_chats, mode = { 'n', }, desc = 'CodeCompanion Chats' },
    { 'ga', function() vim.cmd("CodeCompanionChat add") end, mode = { 'v', }, desc = 'CodeCompanion Add Selection to chat' },
  },
  after = function(_plugin)
    require('codecompanion').setup({
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
      -- adapters = {
      --   copilot = function()
      --     return require('codecompanion.adapters').extend('copilot', {
      --       schema = {
      --         model = {
      --           default = function()
      --             local models = require('codecompanion.adapters.http.copilot.get_models').choices()
      --             table.sort(models, function(a, b)
      --               return (a.description or '') > (b.description or '')
      --             end)
      --             return models[1].id
      --           end,
      --         },
      --       },
      --     })
      --   end,
      -- },
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
  end,
}
