-- Parsers must be installed manually via :TSInstall
-- need to install for treesitter:
-- 'stsewd/tree-sitter-comment',
-- 'the-mikedavis/tree-sitter-diff',
-- 'the-mikedavis/tree-sitter-git-commit',
-- 'camdencheek/tree-sitter-dockerfile',
-- 'connorlay/tree-sitter-eex',
-- 'tree-sitter/tree-sitter-go',
-- 'bkegley/tree-sitter-graphql',
-- 'phoenixframework/tree-sitter-heex',
-- 'tree-sitter/tree-sitter-html',
-- 'tree-sitter/tree-sitter-javascript',
-- 'alemuller/tree-sitter-make',
-- 'MDeiml/tree-sitter-markdown',
-- 'mitchellh/tree-sitter-proto',
-- 'tree-sitter/tree-sitter-python',
-- 'r-lib/tree-sitter-r',
-- 'tree-sitter/tree-sitter-regex',
-- 'tree-sitter/tree-sitter-rust',
-- 'derekstride/tree-sitter-sql',
-- 'ikatyang/tree-sitter-yaml'
-- 'tree-sitter/tree-sitter-json',
-- maybe need to install:
-- 'elixir-lang/tree-sitter-elixir',
-- 'elm-tooling/tree-sitter-elm',
-- 'WhatsApp/tree-sitter-erlang',
-- 'MunifTanjim/tree-sitter-lua',
-- 'tree-sitter/tree-sitter-ruby',
return {
  {'nvim-treesitter/nvim-treesitter', -- Highlight, edit, and navigate code
  config = function ()
    require('nvim-treesitter.configs').setup {
      highlight = {
        enable = true, -- false will disable the whole extension
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<M-space>',
        },
      },
      indent = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    }
  end},
  'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter
}


