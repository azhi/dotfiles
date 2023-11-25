return {
  -- Fuzzy Finder (files, lsp, etc)
  {'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim', 'AckslD/nvim-neoclip.lua' },
  config = function ()
    require('telescope').setup { }

    -- Enable telescope fzf native and neoclip
    require('telescope').load_extension 'fzf'
    require('telescope').load_extension('neoclip')

    --Add leader shortcuts
    vim.keymap.set('n', '<leader>b', function() require('telescope.builtin').buffers({ sort_lastused = true }) end)
    vim.keymap.set('n', '<leader>,', function() require('telescope.builtin').find_files() end)
    vim.keymap.set('n', '<leader>f', function() require('telescope.builtin').grep_string({ initial_mode = 'normal' }) end)
    vim.keymap.set('n', '<leader>h', function() require('telescope.builtin').live_grep() end)
    vim.keymap.set('n', '<leader>r', function() require('telescope.builtin').resume({ initial_mode = 'normal' }) end)
    vim.keymap.set('n', '<leader>y', function() require('telescope').extensions.neoclip.default({ initial_mode = 'normal' }) end)


    -- vim.keymap.set('n', '<leader>st', function() require('telescope.builtin').tags() end)
    -- vim.keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags() end)
    -- vim.keymap.set('n', '<leader>sb', function() require('telescope.builtin').current_buffer_fuzzy_find() end)
    -- vim.keymap.set('n', '<leader>?', function() require('telescope.builtin').oldfiles() end)
  end},
  {'nvim-telescope/telescope-fzf-native.nvim',
  build = 'make'},
}
