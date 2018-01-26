" This file is loaded from after/plugin/after.vim
" which means it loads AFTER the rest of the plugins

source ~/.vim/bindings.vim
source ~/.vim/plugins-override.vim

au BufWrite * :Autoformat

cd ~/develop
