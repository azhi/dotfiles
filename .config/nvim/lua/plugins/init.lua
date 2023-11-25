-- plugins with no configs
return {
  'mhartington/oceanic-next', -- theme
  'tpope/vim-endwise', -- automatically insert ends
  'tpope/vim-surround', -- manipulation of surrounding parens, quotes, etc.
  'tpope/vim-repeat', -- replacement for the repeat mapping (.) to support plugins
  'Raimondi/delimitMate', -- automatic closing of quotes, parenthesis, brackets, etc.
  'spiiph/vim-space', -- repeat motion with <Space>

  'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
  {'AckslD/nvim-neoclip.lua', -- Yank history
    config = function() require('neoclip').setup() end},

  -- languages support
  'othree/html5.vim',
  'vim-ruby/vim-ruby',
  'elzr/vim-json',
  'tpope/vim-markdown',
  'slim-template/vim-slim',
  'elixir-lang/vim-elixir',
  'leafgarland/typescript-vim',
  'elmcast/elm-vim',
  'fatih/vim-go',
}
