" content of this file is loaded BEFORE all the plugins
source ~/.config/nvim/global.vim          " general global configuration
source ~/.config/nvim/plugins.vim         " vim-plug plugins list
source ~/.config/nvim/plugins-config.vim  " configuration for plugins that needs to be set BEFORE plugins are loaded
if has('gui_running')
  source ~/.config/nvim/gui.vim           " gui specific settings
end

" after.vim is loaded from ./after/plugin/after.vim
" which should place it AFTER all the other plugins in the loading order
