local lsp_servers = { 'elixirls', 'elmls', 'jsonls', 'ruby_ls', 'yamlls' }

return {
  {'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client
  dependencies = { 'williamboman/mason-lspconfig.nvim', 'folke/neodev.nvim', 'hrsh7th/nvim-cmp', 'nvim-telescope/telescope.nvim' },
  config = function ()
    require('mason-lspconfig').setup({ensure_installed = lsp_servers})

    local lspconfig = require 'lspconfig'
    local on_attach = function(_, bufnr)
      local attach_opts = { silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
      vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
      vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
      vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
      vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, attach_opts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
      vim.keymap.set('n', 'so', function() require('telescope.builtin').lsp_references({ initial_mode = 'normal' }) end, attach_opts)
    end

    -- nvim-cmp supports additional completion capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    for _, lsp in ipairs(lsp_servers) do
      lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end

    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
    }
  end},
  {'williamboman/mason.nvim', -- Automatically install LSPs to stdpath for neovim
  build = ":MasonUpdate",
  config = true},
  {'williamboman/mason-lspconfig.nvim', -- ibid
  dependencies = { 'williamboman/mason.nvim' },
  config = function ()
    -- noop, will be loaded as part of vim-lspconfig to enforce proper loading order
    return nil
  end},
  'folke/neodev.nvim', -- Lua language server configuration for nvim
}
