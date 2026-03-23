return {
  {
    'nvim-treesitter',
    auto_enable = true,
    lazy = false,
    after = function(_)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          -- Ignores internal telescope buffers, etc. Avoids some breakage with pickers
          -- eg zoxide selection is nil
          local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
          if buftype ~= '' then
            return
          end

          if not vim.treesitter.language.add(language) then
            return
          end

          -- enables syntax highlighting and other treesitter features
          vim.treesitter.start(buf, language)

          -- enables treesitter based folds
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
          -- ensure folds are open to begin with
          vim.o.foldlevel = 99

          -- enables treesitter based indentation
          -- FIXME: Might not be necessary with the earlier config
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          vim.print('Started treesitter for ' .. language .. ' buffer')
        end,
      })
    end,
  },
  {
    'nvim-treesitter-textobjects',
    auto_enable = true,
    lazy = false,
    dep_of = { 'nvim-treesitter' },
    -- NOTE: Most settings/comments come from:
    -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/main?tab=readme-ov-file
    before = function(plugin)
      vim.g.no_plugin_maps = true
    end,
    after = function(plugin)
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true, -- Automatically jump forward to textobj
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      })

      -- Helpers
      local xo = { 'x', 'o' }
      local nxo = { 'n', 'x', 'o' }
      local select_textobject = function(query, group)
        group = group or 'textobjects'
        require('nvim-treesitter-textobjects.select').select_textobject(query, group)
      end
      local goto_next_start = function(query, group)
        group = group or 'textobjects'
        require('nvim-treesitter-textobjects.move').goto_next_start(query, group)
      end
      local goto_next_end = function(query, group)
        group = group or 'textobjects'
        require('nvim-treesitter-textobjects.move').goto_next_end(query, group)
      end

      local goto_previous_start = function(query, group)
        group = group or 'textobjects'
        require('nvim-treesitter-textobjects.move').goto_previous_start(query, group)
      end
      local goto_previous_end = function(query, group)
        group = group or 'textobjects'
        require('nvim-treesitter-textobjects.move').goto_previous_end(query, group)
      end
      local swap_next = require('nvim-treesitter-textobjects.swap').swap_next
      local swap_previous = require('nvim-treesitter-textobjects.swap').swap_previous
      local ts_repeat_move = require('nvim-treesitter-textobjects.repeatable_move')

      -- stylua: ignore start
      -- Keymaps
      ---
      --  ] next
      --  [ previous
      --  f function
      --  c class
      --  l loop
      --  s scope
      --  z fold
      --  i conditional
      --  t comment
      --  n assignment name
      --  v assignment value
      ---

      -- [[ around and inside ]]
      vim.keymap.set(xo , 'af',        function() select_textobject('@function.outer') end)
      vim.keymap.set(xo , 'if',        function() select_textobject('@function.inner') end)
      vim.keymap.set(xo , 'ac',        function() select_textobject('@class.outer') end)
      vim.keymap.set(xo , 'ic',        function() select_textobject('@class.inner') end)
      vim.keymap.set(xo , 'as',        function() select_textobject('@local.scope') end)

      -- [[ swapping ]] 
      vim.keymap.set('n', '<leader>a', function() swap_next('@parameter.inner') end)
      vim.keymap.set('n', '<leader>A', function() swap_previous('@parameter.outer') end)

      -- [[ motions ]]

      -- Functions
      vim.keymap.set(nxo, ']f',        function() goto_next_start('@function.outer') end)
      vim.keymap.set(nxo, ']F',        function() goto_next_end('@function.outer') end)
      vim.keymap.set(nxo, '[f',        function() goto_previous_start( '@function.outer') end)
      vim.keymap.set(nxo, '[F',        function() goto_previous_end( '@function.outer') end)

      -- Comment
      vim.keymap.set(nxo, ']t',        function() goto_next_start('@comment.outer') end)
      vim.keymap.set(nxo, ']T',        function() goto_next_end('@comment.outer') end)
      vim.keymap.set(nxo, '[t',        function() goto_previous_start( '@comment.outer') end)
      vim.keymap.set(nxo, '[T',        function() goto_previous_end( '@comment.outer') end)

      -- Conditional
      vim.keymap.set(nxo, ']i',        function() goto_next_start('@conditional.outer') end)
      vim.keymap.set(nxo, ']I',        function() goto_next_end('@conditional.outer') end)
      vim.keymap.set(nxo, '[i',        function() goto_previous_start( '@conditional.outer') end)
      vim.keymap.set(nxo, '[I',        function() goto_previous_end( '@conditional.outer') end)

      -- Classes
      vim.keymap.set(nxo, ']c',        function() goto_next_start('@class.outer') end)
      vim.keymap.set(nxo, ']C',        function() goto_next_end('@class.outer') end)
      vim.keymap.set(nxo, '[c',        function() goto_previous_start('@class.outer') end)
      vim.keymap.set(nxo, '[C',        function() goto_previous_end('@class.outer') end)

      -- Return
      vim.keymap.set(nxo, ']r',        function() goto_next_start('@return.outer') end)
      vim.keymap.set(nxo, ']R',        function() goto_next_end('@return.outer') end)
      vim.keymap.set(nxo, '[r',        function() goto_previous_start('@return.outer') end)
      vim.keymap.set(nxo, '[R',        function() goto_previous_end('@return.outer') end)

      -- Assignment (name)
      vim.keymap.set(nxo, ']n',        function() goto_next_start('@assignment.lhs') end)
      vim.keymap.set(nxo, ']N',        function() goto_next_end('@assignment.lhs') end)
      vim.keymap.set(nxo, '[n',        function() goto_previous_start('@assignment.lhs') end)
      vim.keymap.set(nxo, '[N',        function() goto_previous_end('@assignment.lhs') end)

      -- Assignment (value)
      vim.keymap.set(nxo, ']v',        function() goto_next_start('@assignment.rhs') end)
      vim.keymap.set(nxo, ']V',        function() goto_next_end('@assignment.rhs') end)
      vim.keymap.set(nxo, '[v',        function() goto_previous_start('@assignment.rhs') end)
      vim.keymap.set(nxo, '[V',        function() goto_previous_end('@assignment.rhs') end)

      -- Parameters
      vim.keymap.set(nxo, ']a',        function() goto_next_start('@parameter.inner') end)
      vim.keymap.set(nxo, ']A',        function() goto_next_end('@parameter.inner') end)

      -- Loops
      vim.keymap.set(nxo, ']l',        function() goto_next_start( { '@loop.inner', '@loop.outer' }) end)
      vim.keymap.set(nxo, '[l',        function() goto_previous_start( { '@loop.inner', '@loop.outer' }) end)

      -- Misc
      vim.keymap.set(nxo, ']s',        function() goto_next_start('@local.scope', 'locals') end)
      vim.keymap.set(nxo, ']z',        function() goto_next_start('@fold', 'folds') end)

    -- Repetitions

    -- Repeat movements with ; and , (follows vim motion direction)
      vim.keymap.set(nxo, ';',         ts_repeat_move.repeat_last_move)
      vim.keymap.set(nxo, ',',         ts_repeat_move.repeat_last_move_opposite)

      -- Makes builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set(nxo, 'f',         ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set(nxo, 'F',         ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set(nxo, 't',         ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set(nxo, 'T',         ts_repeat_move.builtin_T_expr, { expr = true })

      -- stylua: ignore end
    end,
  },

  {
    'nvim-treesitter-context',
    auto_enable = true,
    lazy = false,
    dep_of = { 'nvim-treesitter' },

    after = function(plugin)
      require('treesitter-context').setup({
        max_lines = 5, -- Don't pollute too much of the screen
        min_window_height = 20, -- Don't show unless there is enough space
        mode = 'topline', -- Only show context for out-of-view code
      })

      vim.keymap.set({ 'n', 'v' }, '<leader>tc', function()
        vim.cmd('TSContext toggle')
      end, { desc = 'Toggle Treesitter Context' })
      vim.keymap.set('n', '[c', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true, desc = 'Jump to previous treesitter context' })
    end,
  },
  {
    'nvim-ts-autotag',
    auto_enable = true,
    lazy = false,
    dep_of = { 'nvim-treesitter' },
    after = function(plugin)
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      })
    end,
  },
}
