" ------------------ coc ------------------
" extensions
let g:coc_global_extensions = ['coc-json', 'coc-solargraph', 'coc-yaml', 'coc-sql', 'coc-syntax']

" mappings

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" ------------------ nerdtree ------------------
" Ctrl-P to Display the file browser tree
nmap <C-T> :NERDTreeToggle<CR>

" ------------------ defx ------------------
command DefxToggle Defx -toggle -split=vertical -winwidth=40 .
nnoremap <C-P> :DefxToggle<CR>

autocmd FileType defx call s:defx_my_settings()
function! s:defx_my_settings() abort
nnoremap <silent><buffer><expr> <CR>
      \ defx#is_directory() ? defx#do_action('open_or_close_tree') : defx#do_action('open', 'wincmd w \| drop')
nnoremap <silent><buffer><expr> C
      \ defx#is_directory() ? defx#do_action('multi', [['open', 'wincmd w \| drop'], 'change_vim_cwd']) : ''
nnoremap <silent><buffer><expr> h
      \ defx#is_directory() ? defx#do_action('close_tree') : ''
nnoremap <silent><buffer><expr> l
      \ defx#is_directory() ? defx#do_action('open_tree') : ''
nnoremap <silent><buffer><expr> c
      \ defx#do_action('copy')
nnoremap <silent><buffer><expr> m
      \ defx#do_action('move')
nnoremap <silent><buffer><expr> p
      \ defx#do_action('paste')
nnoremap <silent><buffer><expr> E
      \ defx#do_action('open', 'vsplit')
nnoremap <silent><buffer><expr> P
      \ defx#do_action('open', 'pedit')
nnoremap <silent><buffer><expr> ND
      \ defx#do_action('new_directory')
nnoremap <silent><buffer><expr> N
      \ defx#do_action('new_file')
nnoremap <silent><buffer><expr> d
      \ defx#do_action('remove')
nnoremap <silent><buffer><expr> r
      \ defx#do_action('rename')
nnoremap <silent><buffer><expr> x
      \ defx#do_action('execute_system')
nnoremap <silent><buffer><expr> yy
      \ defx#do_action('yank_path')
nnoremap <silent><buffer><expr> .
      \ defx#do_action('toggle_ignored_files')
nnoremap <silent><buffer><expr> u
      \ defx#do_action('cd', ['..'])
nnoremap <silent><buffer><expr> ~
      \ defx#do_action('cd')
nnoremap <silent><buffer><expr> q
      \ defx#do_action('quit')
nnoremap <silent><buffer><expr> <Space>
      \ defx#do_action('toggle_select') . 'j'
nnoremap <silent><buffer><expr> *
      \ defx#do_action('toggle_select_all')
nnoremap <silent><buffer><expr> j
      \ line('.') == line('$') ? 'gg' : 'j'
nnoremap <silent><buffer><expr> k
      \ line('.') == 1 ? 'G' : 'k'
nnoremap <silent><buffer><expr> <C-r>
      \ defx#do_action('redraw')
nnoremap <silent><buffer><expr> <C-g>
      \ defx#do_action('print')
nnoremap <silent><buffer><expr> cd
      \ defx#do_action('change_vim_cwd')
endfunction

" ------------------ denite ------------------
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command', ['git', 'ls-files', '-co', '--exclude-standard'])

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <Esc> <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  inoremap <silent><buffer> <C-j> <Esc>
        \:call denite#move_to_parent()<CR>
        \:call cursor(line('.')+1,0)<CR>
        \:call denite#move_to_filter()<CR>A
  inoremap <silent><buffer> <C-k> <Esc>
        \:call denite#move_to_parent()<CR>
        \:call cursor(line('.')-1,0)<CR>
        \:call denite#move_to_filter()<CR>A
endfunction

function! DeniteFile()
  if isdirectory(getcwd() . '/.git')
    execute 'Denite -buffer-name=files -start-filter file/rec/git'
  else
    execute 'Denite -buffer-name=files -start-filter file/rec'
  endif
endfunction

nmap <leader>, :call DeniteFile()<CR>
nmap <leader>b :Denite -buffer-name=buffers -start-filter buffer<CR>

" make grep case-sensetive by default
call denite#custom#var('grep', 'default_opts', ['-nH'])

call denite#custom#alias('source', 'grep/exact', 'grep')
call denite#custom#var('grep/exact', 'default_opts', ['-nH'])
call denite#custom#var('grep/exact', 'pattern_opt', ['-F'])

call denite#custom#alias('source', 'grep/git', 'grep')
call denite#custom#var('grep/git', 'default_opts', ['--no-color', '-nH'])
call denite#custom#var('grep/git', 'command', ['git', 'grep'])
call denite#custom#var('grep/git', 'recursive_opts', [])

call denite#custom#alias('source', 'grep/git/exact', 'grep')
call denite#custom#var('grep/git/exact', 'default_opts', ['--no-color', '-nH'])
call denite#custom#var('grep/git/exact', 'command', ['git', 'grep'])
call denite#custom#var('grep/git/exact', 'recursive_opts', [])
call denite#custom#var('grep/git/exact', 'pattern_opt', ['-F'])

function! DeniteGrep(ignoreCase, word)
  let ignoreflag = (a:ignoreCase || a:word == '') ? '-i' : ''
  let exactsuffix = a:word == '' ? '' : '/exact'
  if isdirectory(getcwd() . '/.git')
    execute 'Denite -buffer-name=grep -smartcase grep/git' . exactsuffix . '::' . ignoreflag . ':' . "'" . a:word . "'"
  else
    execute 'Denite -buffer-name=grep -smartcase grep' . exactsuffix . '::' . ignoreflag . ':' . "'" . a:word . "'"
  endif
endfunction

nmap <leader>f :call DeniteGrep(1, '<C-R><C-W>')<CR>
nmap <leader>g :call DeniteGrep(0, '<C-R><C-W>')<CR>
vmap <leader>f "my :call DeniteGrep(1, '<C-R>m')<CR>
vmap <leader>g "my :call DeniteGrep(0, '<C-R>m')<CR>
nmap <leader>h :call DeniteGrep(0, '')<CR>
nmap <leader>r :Denite -buffer-name=grep -resume<CR>
nmap <leader>n :Denite -buffer-name=grep -resume -cursor-pos=+1 -immediately<CR>
nmap <leader>p :Denite -buffer-name=grep -resume -cursor-pos='-1' -immediately<CR>

" ------------------ tcomment -------------------
nmap // :TComment<CR>
vmap // :TComment<CR>

" ------------------ vim-searchindex ------------
let g:searchindex_star_case = 0

" ------------------ vim-indent-guides ------------------
let g:indent_guides_start_level = 2
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 5

" -------------------- vim-mix-format --------------
function! AutoMixFormat()
  if !get(g:, 'autocmd_disable_mix_format', 0) && !get(b:, 'autocmd_disable_mix_format', 0)
    execute 'noautocmd update | MixFormat'
  endif
endfunction
autocmd FileType elixir
\  augroup mix_format | exe "autocmd! mix_format BufWritePre <buffer> call AutoMixFormat()" | augroup END

command MixFormatDisable let b:autocmd_disable_mix_format = 1
command MixFormatEnable let b:autocmd_disable_mix_format = 0
command MixFormatGlobalDisable let g:autocmd_disable_mix_format = 1
command MixFormatGlobalEnable let g:autocmd_disable_mix_format = 0

" ------------------ json ------------------
let g:vim_json_syntax_conceal = 0

" ------------------ nvim-miniyank -----------------
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
" map <leader>p <Plug>(miniyank-cycle)
" map <leader>p <Plug>(miniyank-startput)
" map <leader>P <Plug>(miniyank-startPut)
map <leader>c <Plug>(miniyank-tochar)
map <leader>l <Plug>(miniyank-toline)
map <leader>' <Plug>(miniyank-toblock)
let g:miniyank_delete_maxlines = 500
let g:miniyank_maxitems = 20

nmap <leader>y :Denite miniyank<cr>

" ------------------ elm-vim -----------------
let g:elm_format_autosave = 1
