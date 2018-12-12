call plug#begin('~/.local/share/nvim/plugged')

" Autocomplete
Plug 'Valloric/YouCompleteMe'

" file, buffers, navigating
Plug 'scrooloose/nerdtree'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }


" end certain structures automatically, e.g. begin/end etc.
Plug 'tpope/vim-endwise'
" automatic closing of quotes, parenthesis, brackets, etc.
Plug 'Raimondi/delimitMate'
" repeat motion with <Space>
Plug 'spiiph/vim-space'
" manipulation of surrounding parens, quotes, etc.
Plug 'tpope/vim-surround'
" replacement for the repeat mapping (.) to support plugins
Plug 'tpope/vim-repeat'
" better looking statusline
Plug 'bling/vim-airline'
" comments plugin
Plug 'tomtom/tcomment_vim'
" show index when searching
Plug 'google/vim-searchindex'
" plugin for visually displaying indent levels
Plug 'nathanaelkane/vim-indent-guides'
" Yank history
Plug 'bfredl/nvim-miniyank'

" run mix format
Plug 'mhinz/vim-mix-format'
" elixir support framework
Plug 'slashmili/alchemist.vim'

" syntax support
"
Plug 'othree/html5.vim'
Plug 'vim-ruby/vim-ruby'
Plug 'elzr/vim-json'
Plug 'tpope/vim-markdown'
Plug 'slim-template/vim-slim'
Plug 'elixir-lang/vim-elixir'
Plug 'leafgarland/typescript-vim'
Plug 'elmcast/elm-vim'
Plug 'fatih/vim-go'

" WARN: UNUSED
" text object based on indent level (ai, ii)
" Plug 'michaeljsmith/vim-indent-object'
" A custom text object for selecting ruby blocks (ar/ir)
" Plug 'nelstrom/vim-textobj-rubyblock'
" Support for user-defined text objects
" Plug 'kana/vim-textobj-user'
" proper CamelCase text objects
" Plug 'bkad/CamelCaseMotion'
" toggle ruby blocks style
" Plug 'vim-scripts/blockle.vim'
" switch segments of text with predefined replacements. e.g. '' -> ""
" Plug 'AndrewRadev/switch.vim'
" plugin for resolving three-way merge conflicts
" Plug 'sjl/splice.vim'
" rails support
" Plug 'tpope/vim-rails'
" bundler integration (e.g. :Bopen)
" Plug 'tpope/vim-bundler'
" rake integration
" Plug 'tpope/vim-rake'
" TextMate-style snippets
" Plug 'msanders/snipmate.vim'
" Syntax
" Plug 'othree/javascript-libraries-syntax.vim'
" Plug 'guns/vim-clojure-static'
" Plug 'tpope/vim-cucumber'
" Plug 'tpope/vim-haml'
" Plug 'kchmck/vim-coffee-script'
" Plug 'wting/rust.vim'

call plug#end()
