set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" plugin management
Plugin 'gmarik/vundle'

" Autocomplete
"
Plugin 'Valloric/YouCompleteMe'

" file, buffers, navigating
"
" file tree
Plugin 'scrooloose/nerdtree'
" file tree and tabs interaction
Plugin 'jistr/vim-nerdtree-tabs'
" fuzzy file open
Plugin 'kien/ctrlp.vim'
" tags list navigation
" WARN: UNUSED
Plugin 'vim-scripts/taglist.vim'
" buffregator (managing buffers)
Plugin 'jeetsukumaran/vim-buffergator'
" session & tabs manager
Plugin 'szw/vim-ctrlspace'

" text objects, movement, refactor, etc
"
" text object based on indent level (ai, ii)
" WARN: UNUSED
Plugin 'michaeljsmith/vim-indent-object'
" A custom text object for selecting ruby blocks (ar/ir)
" WARN: UNUSED
Plugin 'nelstrom/vim-textobj-rubyblock'
" Support for user-defined text objects
" WARN: UNUSED
Plugin 'kana/vim-textobj-user'
" proper CamelCase text objects
Plugin 'bkad/CamelCaseMotion'
" toggle ruby blocks style
" WARN: UNUSED
Plugin 'vim-scripts/blockle.vim'
" end certain structures automatically, e.g. begin/end etc.
Plugin 'tpope/vim-endwise'
" automatic closing of quotes, parenthesis, brackets, etc.
Plugin 'Raimondi/delimitMate'
" repeat motion with <Space>
" WARN: UNUSED
Plugin 'scrooloose/vim-space'
" url based hyperlinks for text files
Plugin 'vim-scripts/utl.vim'
" switch segments of text with predefined replacements. e.g. '' -> ""
" WARN: UNUSED
Plugin 'AndrewRadev/switch.vim'
" ruby refactoring
" WARN: UNUSED
Plugin 'ecomba/vim-ruby-refactoring'

" external services integration
"
" git integration
Plugin 'tpope/vim-fugitive'
" plugin for resolving three-way merge conflicts
Plugin 'sjl/splice.vim'
" rails support
" WARN: UNUSED
Plugin 'tpope/vim-rails'
" bundler integration (e.g. :Bopen)
" WARN: UNUSED
Plugin 'tpope/vim-bundler'
" rake integration
" WARN: UNUSED
Plugin 'tpope/vim-rake'
" apidock.com docs integration
" WARN: UNUSED
Plugin 'mileszs/apidock.vim'

" other struff
"
" yank history
Plugin 'vim-scripts/YankRing.vim'
" syntax checking on save
Plugin 'scrooloose/syntastic'
" TextMate-style snippets
" WARN: UNUSED
Plugin 'msanders/snipmate.vim'
" manipulation of surrounding parens, quotes, etc.
Plugin 'tpope/vim-surround'
" global search & replace
Plugin 'vim-scripts/greplace.vim'
" better looking statusline
Plugin 'bling/vim-airline'
" comments plugin
Plugin 'vim-scripts/tComment'
" show index when searching
Plugin 'henrik/vim-indexed-search'
" plugin for visually displaying indent levels
Plugin 'nathanaelkane/vim-indent-guides'
" visual undo tree
" WARN: UNUSED
Plugin 'sjl/gundo.vim'
" replacement for the repeat mapping (.) to support plugins
Plugin 'tpope/vim-repeat'
" hide .gitignore-d files from vim
Plugin 'vitaly/vim-gitignore'

" syntax support
"
Plugin 'othree/html5.vim'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'guns/vim-clojure-static'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tsaleh/vim-tmux'
Plugin 'Puppet-Syntax-Highlighting'
Plugin 'JSON.vim'
Plugin 'tpope/vim-cucumber'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-markdown'
Plugin 'kchmck/vim-coffee-script'
Plugin 'vitaly/vim-syntastic-coffee'
Plugin 'wavded/vim-stylus'
Plugin 'vim-scripts/VimClojure'
Plugin 'slim-template/vim-slim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'wting/rust.vim'

call vundle#end()
filetype plugin indent on
