return {
  {
    "noice.nvim",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("noice").setup({
        cmdline = {
          -- view = "cmdline",
          view = "cmdline_popup",
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          -- Conflicts with blink
          signature = { enabled = false },
        },

        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        -- https://github.com/folke/noice.nvim/discussions/908#discussioncomment-10583586
        routes = {
          { filter = { event = "msg_show", find = "written" } },
          { filter = { event = "msg_show", find = "yanked" } },
          { filter = { event = "msg_show", find = "%d+L, %d+B" } },
          { filter = { event = "msg_show", find = "; after #%d+" } },
          { filter = { event = "msg_show", find = "; before #%d+" } },
          { filter = { event = "msg_show", find = "%d fewer lines" } },
          { filter = { event = "msg_show", find = "%d more lines" } },
          { filter = { event = "msg_show", find = "<ed" } },
          { filter = { event = "msg_show", find = ">ed" } },
        },
      })
    end,
  },
}
