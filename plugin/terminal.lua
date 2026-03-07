if nixInfo(false, 'settings', 'terminalMode') then
  -- Allow infinite scrollback in terminal
  vim.o.scrollback = -1
  vim.o.cmdheight = 0

  local function term_settings()
    vim.opt_local.laststatus = 0 -- Hide statusline
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.number = false
  end

  local terminal_group = vim.api.nvim_create_augroup('Terminal', { clear = true })
  -- Enter terminal mode when opening a new terminal buffer
  vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
      vim.cmd('startinsert')
      vim.opt_local.spell = false
      term_settings()

      -- insert mode when clicking in terminal
      -- https://vi.stackexchange.com/questions/22307/neovim-go-into-insert-mode-when-clicking-in-a-terminal-in-a-pane
      -- vim.api.nvim_buf_set_keymap(0, 'n', '<LeftRelease>', '<LeftRelease>i', { noremap = true })
    end,
    group = terminal_group,
    pattern = 'term://*',
  })

  local term_status_grp = vim.api.nvim_create_augroup('TerminalStatus', { clear = true })

  vim.api.nvim_create_autocmd({ 'ModeChanged', 'BufWinEnter', 'WinEnter' }, {
    group = term_status_grp,
    callback = function()
      if vim.bo.buftype == 'terminal' and vim.api.nvim_get_mode().mode == 't' then
        term_settings()
      else
        -- FIXME: Set this to a global we set for laststatus elsewhere
        vim.opt_local.laststatus = 2 -- Show global statusline (or 2 for split-local)
        vim.opt_local.number = false
        vim.opt_local.signcolumn = 'yes'
      end
    end,
  })
  -- If the original terminal buffer was in terminal mode at the time we left.
  -- It's mostly useful if your using splits and regularly switching out of a
  -- terminal
  vim.api.nvim_create_autocmd('TermLeave', {
    pattern = 'term://*',
    callback = function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      -- Store the cursor, so we can check if we should switch back to terminal mode
      vim.api.nvim_buf_set_var(0, 'terminal_cursor_line', cursor[1])
    end,
    group = terminal_group,
  })

  vim.api.nvim_create_autocmd('BufLeave', {
    pattern = 'term://*',
    callback = function()
      -- We can't trust vim.fn.mode() here, because in order to switch
      -- splits we will end up having to switch to normal mode in the
      -- process, and then back to terminal mode.
      -- Instead, we check whether or not the cursor is on the last line
      -- of the buffer, implying we came from the terminal line
      local cursor = vim.api.nvim_win_get_cursor(0)
      local ok, terminal_cursor_line = pcall(vim.api.nvim_buf_get_var, 0, 'terminal_cursor_line')
      if ok then
        if cursor[1] == terminal_cursor_line then
          vim.api.nvim_buf_set_var(0, 'terminal_mode', 1)
        end
      end
    end,
    group = terminal_group,
  })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = 'term://*',
    callback = function()
      local ok, terminal_mode = pcall(vim.api.nvim_buf_get_var, 0, 'terminal_mode')
      if ok then
        if terminal_mode == 1 then
          vim.api.nvim_buf_set_var(0, 'terminal_mode', 0)
          vim.cmd('startinsert')
        end
      end
    end,
    group = terminal_group,
  })
end
