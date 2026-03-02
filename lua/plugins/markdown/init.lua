return {
  {
    -- FIXME: prefer using marksman with lsp to access toc via telescope
    "vim-markdown-toc",
    after = function(plugin)
      vim.g.vmt_list_item_char = "-"
      vim.g.vmt_fence_text = '_header: "Outline"'
      vim.g.vmt_fence_closing_text = '_footer: ""'
      vim.g.vmt_fence_hidden_markdown_style = "GFM"
    end
  },
}
