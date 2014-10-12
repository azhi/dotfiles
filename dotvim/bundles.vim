set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" plugin management
Plugin 'gmarik/vundle'

" file tree
Plugin 'scrooloose/nerdtree'
" file tree and tabs interaction
Plugin 'jistr/vim-nerdtree-tabs'
" commenting
Plugin 'scrooloose/nerdcommenter'
" fuzzy file open
Plugin 'kien/ctrlp.vim'
" popup completion menu
Plugin 'AutoComplPop'
" tags list navigation
Plugin 'taglist.vim'
" yank history
Plugin 'YankRing.vim'
" git integration
Plugin 'tpope/vim-fugitive'
" syntax checking on save
Plugin 'scrooloose/syntastic'
" TextMate-style snippets
Plugin 'msanders/snipmate.vim'
" manipulation of surraunding parens, quotes, etc.
Plugin 'tpope/vim-surround'
" vertical alignment tool
Plugin 'tsaleh/vim-align'
" 'ack' searching integration
Plugin 'mileszs/ack.vim'
" text object based on indent level (ai, ii)
Plugin 'austintaylor/vim-indentobject'
" global search & replace
Plugin 'greplace.vim'
" better looking statusline
Plugin 'astrails/vim-powerline'
" surround plugin
Plugin 'vim-scripts/surround.vim'
" comments plugin
Plugin 'vim-scripts/tComment'
" proper CamelCase text objects
Plugin 'bkad/CamelCaseMotion'
" HTML 5 omnicomplete and syntax
Plugin 'othree/html5.vim'
" auto close paired characters (parenthesis, etc.)
Plugin 'vim-scripts/AutoClose'
" buffregator (managing buffers)
Plugin 'jeetsukumaran/vim-buffergator'
" show index when searching
Plugin 'vim-scripts/IndexedSearch'
" jQuery syntax support
Plugin 'vim-scripts/jQuery'
" plugin for resolving three-way merge conflicts
Plugin 'sjl/threesome.vim'
" plugin for visually displaying indent levels
Plugin 'Indent-Guides'
" end certain structures automatically, e.g. begin/end etc.
Plugin 'tpope/vim-endwise'
" automatic closing of quotes, parenthesis, brackets, etc.
Plugin 'Raimondi/delimitMate'
" calendar, duh!
Plugin 'calendar.vim--Matsumoto'
" A Narrow Region Plugin (similar to Emacs)
Plugin 'chrisbra/NrrwRgn'
" url based hyperlinks for text files
Plugin 'utl.vim'
" A clone of Emacs' Org-mode for Vim
Plugin 'hsitz/VimOrganizer'
" visual undo tree
Plugin 'sjl/gundo.vim'
" switch segments of text with predefined replacements. e.g. '' -> ""
Plugin 'AndrewRadev/switch.vim'
" session & tabs manager
Plugin 'szw/vim-ctrlspace'

" Ruby/Rails

" rails support
Plugin 'tpope/vim-rails'
" bundler integration (e.g. :Bopen)
Plugin 'tpope/vim-bundler'
" rake integration
Plugin 'tpope/vim-rake'
" A custom text object for selecting ruby blocks (ar/ir)
Plugin 'nelstrom/vim-textobj-rubyblock'
" ruby refactoring
Plugin 'ecomba/vim-ruby-refactoring'
" apidock.com docs integration
Plugin 'apidock.vim'
" toggle ruby blocks style
Plugin 'vim-scripts/blockle.vim'

" color themes
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-vividchalk'
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

" syntax support

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
Plugin 'vim-scripts/jade.vim'
Plugin 'wavded/vim-stylus'
Plugin 'VimClojure'
Plugin 'slim-template/vim-slim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'rust-lang/rust', {'rtp': 'src/etc/vim/'}

" Support and minor

" Support for user-defined text objects
Plugin 'kana/vim-textobj-user'
" replacement for the repeat mapping (.) to support plugins
Plugin 'tpope/vim-repeat'
" hide .gitignore-d files from vim
Plugin 'vitaly/vim-gitignore'
" repeat motion with <Space>
Plugin 'scrooloose/vim-space'
" Github's gist support
Plugin 'mattn/gist-vim'
" web APIs support
Plugin 'mattn/webapi-vim'

"Plugin 'ShowMarks'
"Plugin 'tpope/vim-unimpaired'
"Plugin 'reinh/vim-makegreen'

call vundle#end()
filetype plugin indent on
