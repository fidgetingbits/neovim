-- We may want to consider something else eventually for better quick bookmarking
-- harpoon seems limited, especially because of splits
-- maybe marlin.nvim?
return {
  {
    'marks.nvim',
    event = 'DeferredUIEnter',
    after = function(_)
      local l = '<leader>m'
      local d = '<leader>M' -- Not sure how to deal with deletions bindings
      require('marks').setup({
        default_mappings = false,
        mappings = {
          set = l .. '',
          set_next = l .. ',',
          toggle = l .. ';',
          next = l .. ']',
          prev = l .. '[',
          preview = l .. ':',
          next_bookmark = l .. '}',
          prev_bookmark = l .. '{',
          delete = d,
          delete_line = d .. '-',
          delete_bookmark = d .. '=',
          delete_buf = d .. '<space>',
        },
      })
    end,
  },
}
