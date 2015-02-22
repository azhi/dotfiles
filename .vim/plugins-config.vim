" ------------------ youcompleteme ------------------
let g:ycm_show_diagnostics_ui = 0 " disable ycm diagnostics
let g:ycm_complete_in_comments = 1 " enable completion in comments
let g:ycm_collect_identifiers_from_tags_files = 0 " disable tags collecting (make sure to enable if ctags would be configured)
let g:ycm_add_preview_to_completeopt = 1 " enable current completion additional info UI
let g:ycm_autoclose_preview_window_after_completion = 1 " autoclose additional info UI
let g:ycm_autoclose_preview_window_after_insertion = 1 " autoclose on leaving INSERT mode

" ------------------ nerdtree ------------------
" Ctrl-P to Display the file browser tree
nmap <C-P> :NERDTreeTabsToggle<CR>
" ,p to show current file in the tree
nmap <leader>p :NERDTreeFind<CR>

" ------------------ ctrlp ------------------
let g:ctrlp_map = '<leader>,'
let g:ctrlp_cmd = 'CtrlP'

let g:ctrlp_clear_cache_on_exit = 1
" ctrlp leaves stale caches behind if there is another vim process runnin
" which didn't use ctrlp. so we clear all caches on each new vim invocation
cal ctrlp#clra()

let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'

" jump to buffer in the same tab if already open
let g:ctrlp_switch_buffer = 1

" if in git repo - use git file listing command, should be faster
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files --exclude-standard -cod']

" open multiple files with <c-z> to mark and <c-o> to open. v - opening in
" vertical splits; j - jump to first open buffer; r - open first in current buffer
let g:ctrlp_open_multiple_files = 'vjr'

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'mixed', 'line']


" ------------------ taglist ------------------
nnoremap <silent> <F8> :TlistToggle<CR>

" ------------------ vim-indent-object ------------------
" add Markdown to the list of indentation based languages
let g:indentobject_meaningful_indentation = ["haml", "sass", "python", "yaml", "markdown"]

" ------------------ ctrlspace ------------------
let g:ctrlspace_use_tabline = 1

" ------------------ blockle ------------------
let g:blockle_mapping = '<Leader>{' " remap cause ,b is taken by ctrlp

" ------------------ utl ------------------
if has("mac")
  let g:utl_cfg_hdl_scm_http_system = "!open '%u'"
end
nmap <leader>o :Utl

" ------------------ switch ------------------
let g:switch_mapping = "_"

" ------------------ fugitive ------------------
nmap <leader>g :silent Ggrep<space>
" ,f for global git serach for word under the cursor (with highlight)
nmap <leader>f :let @/="\\<<C-R><C-W>\\>"<CR>:set hls<CR>:silent Ggrep -w "<C-R><C-W>"<CR>:ccl<CR>:cw<CR><CR>
" same in visual mode
:vmap <leader>f y:let @/=escape(@", '\\[]$^*.')<CR>:set hls<CR>:silent Ggrep -F "<C-R>=escape(@", '\\"#')<CR>"<CR>:ccl<CR>:cw<CR><CR>

" ------------------ vim-rails ------------------
" completing Rails hangs a lot
" let g:rubycomplete_rails = 1

" ------------------ yankring ------------------
let g:yankring_replace_n_pkey = '<leader>['
let g:yankring_replace_n_nkey = '<leader>]'
" ,y to show the yankring
nmap <leader>y :YRShow<cr>
" put the yankring_history file in ~/.backup
let g:yankring_history_dir = '~/.backup'

" ------------------ syntastic ------------------
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" ------------------ vim-indent-guides ------------------
let g:indent_guides_start_level = 2
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 5

" ------------------ gundo ------------------
nmap <leader>u :GundoToggle<CR>
let g:gundo_close_on_revert = 1

" ------------------ tcomment ------------------
nmap // :TComment<CR>
vmap // :TComment<CR>

" ------------------ vimclojure ------------------
let g:vimclojure#ParenRainbow = 1
let g:vimclojure#DynamicHighlighting = 1
