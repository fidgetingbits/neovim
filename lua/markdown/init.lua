return {
  {
    -- FIXME: prefer using marksman with lsp to access toc via telescope
    'vim-markdown-toc',
    ft = 'markdown',
    after = function(plugin)
      vim.g.vmt_list_item_char = '-'
      vim.g.vmt_fence_text = '_header: "Outline"'
      vim.g.vmt_fence_closing_text = '_footer: ""'
      vim.g.vmt_fence_hidden_markdown_style = 'GFM'
    end,
  },

  -- FIXME: make it's own module
  {
    'markdown-preview.nvim',
    cmd = { 'MarkdownPreview', 'MarkdownPreviewStop', 'MarkdownPreviewToggle' },
    ft = 'markdown',
    -- stylua: ignore
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview <CR>",       mode = { "n" }, noremap = true, desc = "markdown preview" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop <CR>",   mode = { "n" }, noremap = true, desc = "markdown preview stop" },
      { "<leader>mt", "<cmd>MarkdownPreviewToggle <CR>", mode = { "n" }, noremap = true, desc = "markdown preview toggle" },
    },
    before = function(plugin)
      vim.g.mkdp_auto_close = 0
    end,
  },
}
