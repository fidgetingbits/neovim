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

function get_adapter_model()
  vim.inspect(adapter)
  return { '' }
end

-- FIXME: Move to a util module
local function show_adapter_info(chat_obj)
  local adapter = chat_obj.adapter

  local model = get_adapter_model(adapter)
  local params = adapter.type == 'acp' and adapter.defaults or chat_obj.settings
  local adapter_info = {
    { 'type', adapter.type },
    { 'name', adapter.name },
    { 'model', model },
    { 'model_params', params },
  }
  local lines = vim
    .iter(adapter_info)
    :map(function(item)
      return string.format('%s = %s', item[1], vim.inspect(item[2]))
    end)
    :totable()
  vim.print(string.format('Adapter Info\n%s', table.concat(lines, '\n')))
end

-- FIXME: Move to a util module
local function setup_codecompanion_filetype_mappings(e)
  local codecompanion = require('codecompanion')
  local bufnr = e.buf

  vim.keymap.set({ 'n' }, 'gi', function()
    local chat_obj = codecompanion.buf_get_chat(bufnr)
    show_adapter_info(chat_obj)
  end, { buf = bufnr, desc = 'Show adapter info' })
end

local function setup_filetype_mappings(group)
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'codecompanion',
    desc = 'CodeCompanion filetype mappings',
    callback = setup_codecompanion_filetype_mappings,
  })
end

local l = '<leader>a'
return {
  {
    'codecompanion.nvim',
    load = function(name)
      nixInfo.lze.loaders.multi({
        name,
        'codecompanion-history.nvim',
        'codecompanion-spinner.nvim',
      })
    end,
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
          spinner = {},
          -- https://github.com/ravitemer/codecompanion-history.nvim
          history = {
            enabled = true,
            opts = {
              auto_generate_title = true,
              title_generation_opts = {
                adapter = 'ossa',
                model = 'Qwen 3.6 Coder 30B (Light)',
                refresh_every_n_prompts = 3,
                max_refreshes = 10,
              },
              auto_save = true,
              expiration_days = 0,
            },
          },
        },

        -- FIXME: Need a way to configure defaults based on what system it is
        -- probably use hostname? We should setup something similar to nixInfo
        -- or just actually put it in nixInfo?
        interactions = {
          chat = {
            adapter = 'oedo',
            -- See setup_filetype_mappings() for additional keymaps
            keymaps = {
              send = {
                modes = {
                  n = { '<CR>', '<C-enter>' },
                  i = '<C-enter>',
                },
              },
            },
            roles = {
              llm = function(adapter)
                local adapter_name = adapter.name or 'CodeCompanion'
                local model_name = adapter.model.name or adapter.model_params.model
                return adapter_name .. ' (' .. model_name .. ')'
              end,
              user = 'fidgetingbits',
            },
          },

          inline = {
            adapter = 'oedo',
          },
        },

        adapters = {
          http = {
            opts = {
              show_presets = false,
            },
            ossa = require('ai.codecompanion.adapters.ossa'),
            oedo = require('ai.codecompanion.adapters.oedo'),
            gemini = require('ai.codecompanion.adapters.gemini'),
            openrouter = require('ai.codecompanion.adapters.openrouter'),
            nvidia_nim = require('ai.codecompanion.adapters.nvidia_nim'),
          },

          acp = {
            opts = {
              show_presets = false,
            },
            nano = require('ai.codecompanion.adapters.nano'),
          },
          cli = {
            opts = {
              show_presets = false,
            },
          },
        },

        display = {
          chat = {
            start_in_insert_mode = true,
          },
          action_palette = {
            provider = 'telescope',
          },
        },
      })
      -- FIXME: Revisit
      setup_filetype_mappings()

      -- Expand cc in commandline mode
      vim.cmd.cab('cc CodeCompanion')

      -- Noice notification pop-up during CodeCompanion commands
      require('ai.codecompanion.extensions.notification').init()
    end,
  },
}
