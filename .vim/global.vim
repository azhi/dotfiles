colorscheme darkblue2

" be 'modern'
set nocompatible
syntax on
filetype plugin indent on

" utf-8/unicode support
" requires Vim to be compiled with Multibyte support, you can check that by
" running `vim --version` and checking for +multi_byte.
if has('multi_byte')
  scriptencoding utf-8
  set encoding=utf-8
end

" russian layout support
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

" presentation settings
set number              " precede each line with its line number
set numberwidth=3       " number of culumns for line numbers
set wrap
set textwidth=79
set formatoptions=qrn1
set showcmd             " Show (partial) command in status line.
set showmatch           " Show matching brackets.
set ruler               " line and column number of the cursor position
set linespace=2         " some more space between lines
set wildmenu            " enhanced command completion
set laststatus=2        " always show the status line
"set listchars=tab:▷⋅,trail:·,eol:$
set listchars=tab:▷⋅,trail:·
set list
set noerrorbells visualbell t_vb=    " no beeps
autocmd GUIEnter * set visualbell t_vb=

" highlight spell errors
hi SpellErrors guibg=red guifg=black ctermbg=red ctermfg=black

" behavior
                        " ignore these files when completing names and in
                        " explorer
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif
set shell=/bin/bash     " use bash for shell commands
set hidden              " enable multiple modified buffers
set history=10000
set autoread            " automatically read file that has been changed on disk and doesn't have changes in vim
set backspace=indent,eol,start
set guioptions-=T       " disable toolbar
set completeopt=menuone,preview
let bash_is_sh=1        " syntax shell files as bash scripts
set modelines=5         " number of lines to check for vim: directives at the start/end of file

set tabstop=2           " number of spaces in a tab
set shiftwidth=2        " number of spaces for indent
set softtabstop=2
set expandtab

" indenting
set autoindent
set smartindent
set cindent
set cinoptions=:0,(s,u0,U1,g0,t0 " some indentation options ':h cinoptions' for details

" mouse settings
if has("mouse")
  set mouse=a
endif
set mousehide           " Hide mouse pointer on insert mode."

" search settings
set incsearch           " Incremental search
set hlsearch            " Highlight search match
set ignorecase          " Do case insensitive matching
set smartcase           " do not ignore if search pattern has CAPS

" omni completion settings
set ofu=syntaxcomplete#Complete
let g:rubycomplete_buffer_loading = 0
let g:rubycomplete_classes_in_global = 1

" directory settings
silent !mkdir -vp ~/.backup/undo/ > /dev/null 2>&1
set backupdir=~/.backup,.       " list of directories for the backup file
set directory=~/.backup,~/tmp,. " list of directory names for the swap file
set undodir=~/.backup/undo/,~/tmp,.
set nobackup            " do not write backup files
set undofile

" folding
set foldcolumn=0        " columns for folding
set foldmethod=indent
set foldlevel=9
set nofoldenable        "dont fold by default

" set spell checking for text and tex files
autocmd FileType text set spell spelllang=ru_ru,en_us
autocmd FileType tex set spell spelllang=ru_ru,en_us

" extended '%' mapping for if/then/else/end etc
runtime macros/matchit.vim

let mapleader = ","
let maplocalleader = "\\"
