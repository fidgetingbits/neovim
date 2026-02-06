return {
  "codecompanion.nvim",
  for_cat = 'general.general',
  -- FIXME: why we need this?
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
  after = function(plugin)
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "openai",
        },
      },
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            schema = {
              model = {
                default = "deepseek-r1:8",
              },
            },
          })
        end,
      },
      display = {
        chat = {
          start_in_insert_mode = true,
        },
        action_palette = {
          provider = "telescope",
        },
      },
    })
  end
}
