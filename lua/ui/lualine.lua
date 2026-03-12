-- We use "traditional" neovim tabs, meaning it is a workspace not a file/buffer
-- Handling adapted from https://github.com/nvim-lualine/lualine.nvim/discussions/1404
-- Originally used taboo for renaming, but is archived.

local NO_NAME = '[No Name]'

-- utility function, returns true if buffer with specified
-- buf/filetype should be ignored by the tabline or not
local function ignore_buffer(bufnr)
  local ignored_buftypes = { 'prompt', 'nofile', 'terminal', 'quickfix' }
  local ignored_filetypes = { 'snacks_picker_preview' }

  local filetype = vim.bo[bufnr].filetype
  local buftype = vim.bo[bufnr].buftype
  local name = vim.api.nvim_buf_get_name(bufnr)

  return vim.tbl_contains(ignored_buftypes, buftype)
    or vim.tbl_contains(ignored_filetypes, filetype)
    or name == ''
end

-- Get buffer name, using alternate buffer or last visited buffer if necessary
local function get_buffer_name(bufnr, context)
  local function get_filename(buf)
    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')
  end

  -- rename tabs with <leader>r and (sessionoptions requires globals)
  local custom_name = vim.g['Lualine_tabname_' .. context.tabnr]
  if custom_name and custom_name ~= '' then
    return custom_name
  end

  -- this makes empty buffers/tabs show "[No Name]"
  if vim.api.nvim_buf_get_name(bufnr) == '' and vim.bo[bufnr].buflisted then
    return NO_NAME
  end

  if ignore_buffer(bufnr) then
    local alt_bufnr = vim.fn.bufnr('#')
    if alt_bufnr ~= -1 and alt_bufnr ~= bufnr and not ignore_buffer(alt_bufnr) then
      -- use name of alternate buffer
      return get_filename(alt_bufnr)
    end

    -- Try to use the name of a different window in the same tab
    local win_ids = vim.api.nvim_tabpage_list_wins(0)
    for _, win_id in ipairs(win_ids) do
      local found_bufnr = vim.api.nvim_win_get_buf(win_id)
      if not ignore_buffer(found_bufnr) then
        local name = get_filename(found_bufnr)
        return name ~= '' and name or NO_NAME
      end
    end
    return NO_NAME
  end

  return get_filename(bufnr)
end

return {
  {
    'lualine.nvim',
    event = 'DeferredUIEnter',
    after = function(plugin)
      require('lualine').setup({
        options = {
          always_show_tabline = true, -- only show tabline when >1 tabs
          refresh = {
            tabline = 10000, -- FIXME: Double check why
          },
          icons_enabled = false,
          component_separators = '|',
          section_separators = '',
          -- FIXME: Remove this probably, was for fixing status line
          -- disabled_filetypes = {
          --   statusline = { 'terminal', 'toggleterm' },
          --   winbar = { 'terminal' },
          -- },
        },
        sections = {
          lualine_c = {
            {
              'filename',
              path = 1,
              status = true,
            },
          },
        },
        inactive_sections = {
          lualine_b = {
            {
              'filename',
              path = 3,
              status = true,
            },
          },
          lualine_x = { 'filetype' },
        },

        -- Top bar
        tabline = {
          lualine_a = {
            {
              'tabs',
              show_modified_status = false,
              max_length = vim.o.columns - 2,
              mode = 1, -- Shows tab_name
              padding = 1,
              -- tabs_color = {
              --   -- Same values as the general color option can be used here.
              --   active = 'TabLineSel', -- Color for active tab.
              --   inactive = 'TabLineFill', -- Color for inactive tab.
              -- },

              -- FIXME: Revisit this
              -- fmt = function(name, context)
              --   local buflist = vim.fn.tabpagebuflist(context.tabnr)
              --   local winnr = vim.fn.tabpagewinnr(context.tabnr)
              --   local bufnr = buflist[winnr]
              --
              --   -- hard code 'scratch' name for Snacks scratch buffers
              --   if name:find('.scratch') then
              --     name = 'scratch'
              --   else
              --     name = get_buffer_name(bufnr, context)
              --   end
              --
              --   -- include tabnr only if # of tabs > 3
              --   return ((vim.fn.tabpagenr('$') > 3) and (context.tabnr .. ' ') or '') .. name
              -- end,
            },
          },
        },
      })

      vim.api.nvim_create_autocmd(
        { 'TabNew', 'TabEnter', 'TabClosed', 'WinEnter', 'BufWinEnter' },
        {
          callback = function()
            require('lualine').refresh({ scope = 'all', place = { 'tabline' } })
          end,
        }
      )
      vim.keymap.set({ 'n', 'v' }, '<leader><tab>r', function()
        vim.ui.input({ prompt = 'New Tab Name: ' }, function(input)
          if input or input == '' then
            vim.cmd.LualineRenameTab(input)
            require('lualine').refresh({ scope = 'all', place = { 'tabline' } })
          end
        end)
      end, { desc = 'Change tab name' })
    end,
  },
}
