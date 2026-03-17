-- Two important keymaps to use while in telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist(
    'git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel'
  )[1]
  if vim.v.shell_error ~= 0 then
    print('Not a git repository. Searching on current working directory')
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = { git_root },
    })
  end
end

local telescope_ignore_patterns = {
  -- Ignore nix lock files
  '%.lock',
}

-- Allows you to toggle the search to include hidden files
-- From https://github.com/nvim-telescope/telescope.nvim/issues/2874#issuecomment-1900967890
local function custom_find_files(opts, no_ignore)
  opts = opts or {}
  no_ignore = vim.F.if_nil(no_ignore, false)
  opts.attach_mappings = function(_, map)
    map({ 'n', 'i' }, '<C-h>', function(prompt_bufnr) -- <C-h> to toggle modes
      local prompt = require('telescope.actions.state').get_current_line()
      require('telescope.actions').close(prompt_bufnr)
      no_ignore = not no_ignore
      custom_find_files({ default_text = prompt }, no_ignore)
    end)
    return true
  end

  if no_ignore then
    opts.no_ignore = true
    opts.hidden = true
    opts.prompt_title = 'Find Files <ALL>'
    require('telescope.builtin').find_files(opts)
  else
    opts.prompt_title = 'Find Files'
    require('telescope.builtin').find_files(opts)
  end
end

local t = '<leader>f'

return {
  {
    'telescope-luasnip',
    lazy = true,
    dep_of = { 'telescope.nvim', 'luasnip' },
    -- stylua: ignore
    keys = {
      {
        t .. 'L', function() require('telescope').extensions.luasnip.luasnip({}) end, mode = { 'n' }, desc = '[F]ind Snippets',
      },
    },
  },
  {
    'telescope-toggleterm',
    dep_of = { 'telescope.nvim' },
  },
  {
    'telescope-zoxide',
    dep_of = { 'telescope.nvim' },
  },
  {
    'telescope.nvim',
    category = 'search',
    cmd = { 'Telescope', 'LiveGrepGitRoot' },
    -- NOTE: our on attach function defines keybinds that call telescope.
    -- so, the on_require handler will load telescope when we use those.
    on_require = { 'telescope' },
    -- stylua: ignore
    keys = {
      {
        "<leader>/",
        function()
          -- Slightly advanced example of overriding default behavior and theme
          -- You can pass additional configuration to telescope to change theme, layout, etc.
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        mode = { "n" },
        desc = '[/] Fuzzily search in current buffer',
      },
      {
        t .. "/",
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        mode = { "n" },
        desc = '[F]ind [/] in Open Files'
      },

      -- IMPORTANT: s from flash.nvim conflicts with <leader>, so don't map for now
      { t .. ".", function() return require('telescope.builtin').oldfiles() end,    mode = { "n" }, desc = '[F]ind Recent Files ("." for repeat)', },
      { t .. "b", function() return require('telescope.builtin').buffers() end,     mode = { "n" }, desc = '[F]ind existing [B]uffers', },
      { t .. "B", function() return require('telescope.builtin').builtin() end,     mode = { "n" }, desc = '[F]ind telescope builtins', },
      { t .. 'd', '<cmd>Telescope zoxide list<CR>', mode = { 'n' }, desc = '[F]ind [Z]oxide', },
      { t .. "f", custom_find_files,  mode = { "n" }, desc = '[F]ind [F]iles', },
      { t .. "g", function() return require('telescope.builtin').live_grep() end,   mode = { "n" }, desc = '[F]ind by [G]rep', },
      { t .. "G", live_grep_git_root,                                               mode = { "n" }, desc = '[F]ind git [P]roject root', },
      { t .. "h", function() return require('telescope.builtin').help_tags() end,   mode = { "n" }, desc = '[F]ind [H]elp', },
      { t .. "H", function() return require('telescope.builtin').highlights() end,   mode = { "n" }, desc = '[F]ind [H]ighlights / color map', },
      { t .. "k", function() return require('telescope.builtin').keymaps() end,     mode = { "n" }, desc = '[F]ind [K]eymaps', },
      { t .. "l", function() return require('telescope.builtin').builtin({include_extensions = true}) end, mode = { "n" }, desc = "[F]ind telescope commands", },
      { t .. "n", '<cmd>Telescope notify<CR>',                                      mode = { "n" }, desc = '[F]ind [N]otifications', },
      { t .. "P", function() return require('telescope.builtin').git_files() end,   mode = { "n" }, desc = '[F]ind [P]roject Root Files', },
      { t .. "r", function() return require('telescope.builtin').resume() end,      mode = { "n" }, desc = '[F]ind [R]esume', },
      { t .. 'S', '<cmd>Telescope resession<CR>', mode = { 'n' }, desc = '[F]ind sessions', },
      { t .. "t", '<cmd>Telescope toggleterm<CR>', mode = { "n" }, desc = '[F]ind [T]erminals', },
      { t .. "w", function() return require('telescope.builtin').grep_string() end, mode = { "n" }, desc = '[F]ind current [W]ord', },
      -- Because <leader>xx toggles diagnostic quicklist
      { t .. "x", function() return require('telescope.builtin').diagnostics() end, mode = { "n" }, desc = '[F]ind Diagnostics', },
      { t .. "z", function() return require('telescope.builtin').spell_suggest() end, mode = { "n" }, desc = '[F]ind spelling suggestion', }, -- z because of z=
    },
    load = function(name)
      nixInfo.lze.loaders.multi({
        name,
        'telescope-fzf-native.nvim',
        'telescope-ui-select.nvim',
        'telescope-luasnip',
        'telescope-toggleterm.nvim',
        'telescope-zoxide.nvim',
        'pick-resession',
      })
    end,

    after = function(_)
      require('telescope').setup({
        defaults = {
          mappings = {
            i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          },
          file_ignore_patterns = telescope_ignore_patterns,
          layout_strategy = 'flex', -- Change layout depending on if on laptop screen or dualup
          -- FIXME: Still need to test this on the laptop... may be better to
          -- just make the layout_strategy a function that checks for monitors
          -- or something eventually?
          layout_config = {
            flex = {
              flip_columns = 180,
              flip_lines = 50,
            },
            vertical = {
              preview_height = 0.75,
              height = 0.95,
            },
          },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          zoxide = {
            mappings = {
              default = {
                action = function(selection)
                  -- Prefer tab page path changes by default
                  vim.cmd.tcd(selection.path)
                end,
                ['<C-l>'] = {
                  action = function(selection)
                    vim.cmd.lcd(selection.path)
                  end,
                },
                ['<C-g>'] = {
                  action = function(selection)
                    vim.cmd.cd(selection.path)
                  end,
                },
              },
            },
          },
        },
      })

      -- Enable telescope extensions, if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      -- WARNING: If you do this in the after for luasnip entry above, you get
      -- a stack overflow
      pcall(require('telescope').load_extension, 'luasnip')
      pcall(require('telescope').load_extension, 'toggleterm')
      pcall(require('telescope').load_extension, 'zoxide')
      pcall(require('telescope').load_extension, 'resession')

      vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
    end,
  },
}
