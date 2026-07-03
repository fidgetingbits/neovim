-- FIXME - This probably wants cli extension instead?
return function()
  return require('codecompanion.adapters').extend('claude_code', {
    commands = {
      default = {
        'ssh',
        '-q',
        'claude',
        -- FIXME: Make this a function or something
        -- 'tee /tmp/acp_in.log | claude-code-acp | tee /tmp/acp_out.log',
        string.format(
          "export ANTHROPIC_API_KEY='%s'; env > /tmp/foo; tee /tmp/acp_in.log |  claude-code-acp --hide-claude-auth | tee /tmp/acp_out.log",
          vim.env.ANTHROPIC_API_KEY
        ),
      },
    },
    -- FIXME: double check this
    opts = {
      -- Allows the agent to use your project paths correctly
      sync_directory = false,
    },
  })
end
