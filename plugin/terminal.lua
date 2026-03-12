if nixInfo(false, 'settings', 'terminalMode') then
  -- Allow infinite scrollback in terminal
  vim.o.scrollback = -1
  vim.o.cmdheight = 0

  local function term_settings()
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.foldcolumn = '0'

    -- NOTE:: We keep this to avoid reflow issues on mode changes. We make the
    -- columns invisible using sync_terminal_ui() below. If we ever fixed it so
    -- SIGWINCH reflow or whatever causes the issues goes away, we could set this
    -- to false
    vim.opt_local.relativenumber = true

    -- This is scheduled as it needs to come after lualine
    vim.schedule(function()
      -- FIXME: 0 would be nice for "clean terminal" look but doesn't work with split
      -- terminals anyway, so becomes inconsistent. Could make it only apply if
      -- there is only one split open and it's a terminal though
      vim.opt.laststatus = 2
    end)

    -- FIXME: Some people unset this for terminal, but I can't get mouse to work
    -- at all in neovide, so leaving for now
    -- vim.opt.mouse = vim.opt.mouse - 'a'
  end

  --  NOTE: This function prevents relative numbers showing up in normal
  --  terminal We can't shut it off because it messes with p10k redraw logic and
  --  spams prompts/newlines so we opt to "hide" the color of the numbers and
  --  reset them. But without using this namespace, it was glitchy and sometimes
  --  coming back
  local term_ns = vim.api.nvim_create_namespace('terminal_gutter_hide')
  local function sync_terminal_ui()
    if vim.bo.buftype ~= 'terminal' then
      return
    end

    local mode = vim.api.nvim_get_mode().mode
    local bg_color = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg

    if mode == 't' then
      -- Force the gutter to be invisible by overriding the namespace
      vim.api.nvim_set_hl(term_ns, 'LineNr', { fg = bg_color, bg = bg_color })
      vim.api.nvim_set_hl(term_ns, 'CursorLineNr', { fg = bg_color, bg = bg_color })
      vim.api.nvim_set_hl(term_ns, 'SignColumn', { bg = bg_color })
      vim.api.nvim_win_set_hl_ns(0, term_ns)
    else
      -- Reset to default namespace (showing normal numbers)
      vim.api.nvim_win_set_hl_ns(0, 0)
    end
  end

  local terminal_group = vim.api.nvim_create_augroup('Terminal', { clear = true })
  -- Enter terminal mode when opening a new terminal buffer
  vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
      vim.cmd('startinsert')
      vim.opt_local.spell = false
      term_settings()

      -- FIXME: this doesn't work afaik. Also given the mode caching we do
      -- we likely want this to just focus the screen, rather than insert anyway
      -- if we do want insert, we ought to run startinsert cmd vs keymap
      -- insert mode when clicking in terminal
      -- https://vi.stackexchange.com/questions/22307/neovim-go-into-insert-mode-when-clicking-in-a-terminal-in-a-pane
      vim.api.nvim_buf_set_keymap(0, 'n', '<LeftRelease>', '<LeftRelease>i', { noremap = true })
    end,
    group = terminal_group,
    pattern = 'term://*',
  })

  -- Not sure if we need this for TermEnter or can use the same below for Buf/Win enter?
  -- vim.api.nvim_create_autocmd('TermEnter', {
  --   callback = function()
  --     term_settings()
  --   end,
  --   group = terminal_group,
  --   pattern = 'term://*',
  -- })

  local term_status_grp = vim.api.nvim_create_augroup('TerminalStatus', { clear = true })

  vim.api.nvim_create_autocmd({ 'ModeChanged', 'BufWinEnter', 'WinEnter' }, {
    group = term_status_grp,
    callback = function()
      -- FIXME: This sometimes doesn't reset the colors, so just living with numbers for now
      -- sync_terminal_ui()
      local bg_color = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg
      if vim.bo.buftype == 'terminal' and vim.api.nvim_get_mode().mode == 't' then
        term_settings()
      else
        -- FIXME: Set this to a global we set for laststatus elsewhere, in case
        -- we eventually set this to 3
        vim.opt_local.laststatus = 2
        vim.opt_local.relativenumber = true
        vim.opt_local.signcolumn = 'yes'

        vim.opt_local.winhl = ''
      end
    end,
  })

  -- -- terminal
  vim.api.nvim_create_autocmd('TermLeave', {
    pattern = 'term://*',
    callback = function()
      local cursor = vim.api.nvim_win_get_cursor(0)
      -- Store the cursor, so we can check if we should switch back to terminal mode
      vim.api.nvim_buf_set_var(0, 'terminal_cursor_line', cursor[1])
    end,
    group = terminal_group,
  })

  -- We want to retain the correct mode we were in in the terminal if we moved
  -- splits, so track the state so we don't always end up coming back into
  -- insert mode, which we only want sometimes
  vim.api.nvim_create_autocmd('ModeChanged', {
    group = terminal_group,
    pattern = 't:*', -- Leaving Terminal mode
    callback = function()
      if vim.bo.buftype == 'terminal' then
        vim.b.last_terminal_mode = 'n'
      end
    end,
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = '*:t', -- Entering Terminal mode
    callback = function()
      if vim.bo.buftype == 'terminal' then
        vim.b.last_terminal_mode = 't'
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    pattern = 'term://*',
    group = terminal_group,
    callback = function()
      local last_mode = vim.b.last_terminal_mode or 't'

      if last_mode == 't' then
        vim.cmd('startinsert')
      else
        vim.cmd('stopinsert')
      end
    end,
  })

  -- stylua: ignore start
  vim.keymap.set({ 't', }, '<C-o>', '<C-\\><C-n>', { desc = 'Convenience from breaking out of terminal mode' })
  -- stylua: ignore end

  vim.o.showtabline = 2 -- Always show tabline
  local function split_and_follow(direction)
    local cmd
    if direction == 'h' then
      cmd = 'leftabove vsplit'
    elseif direction == 'j' then
      cmd = 'belowright split'
    elseif direction == 'k' then
      cmd = 'leftabove split'
    elseif direction == 'l' then
      cmd = 'belowright vsplit'
    end

    if cmd then
      vim.cmd(cmd)
    end
  end

  local modes = { 't', 'n', 'v' }

  for i = 1, 9 do
    vim.keymap.set({ 'n', 'v', 't', 'i' }, '<A-' .. i .. '>', function()
      pcall(vim.api.nvim_set_current_tabpage, i)
    end, { desc = 'Go to tab ' .. i })
  end

  for _, dir in ipairs({ 'h', 'j', 'k', 'l' }) do
    -- Using p to match zellij panes for now
    vim.keymap.set(modes, '<A-p>' .. dir, function()
      split_and_follow(dir)
    end, { desc = 'Split window ' .. dir })

    -- Spawn terminal in direction
    vim.keymap.set(modes, '<A-t>' .. dir, function()
      split_and_follow(dir)
      vim.cmd('term')
    end, { desc = 'Spawn terminal to' .. dir })
  end

  -- Toggle fullscreen (zen mode)
  vim.keymap.set({ 't', 'n', 'v' }, '<A-f>', function()
    vim.cmd('ZenMode')
  end, { noremap = true, silent = true, desc = 'Toggle full screen (zen)' })

  -- Spawn new terminal
  vim.keymap.set('n', '<A-t>n', function()
    vim.cmd('term')
  end)

  -- Allow scrolling back as an escape out of terminal
  -- stylua: ignore
  vim.keymap.set('t', '<C-b>', '<C-\\><C-n><C-b>', { desc = 'Leave terminal mode and scroll back in buffer' })
end
