" ------------------ vim-searchindex ------------
" somebody overwrites searchindex mappings, restore them
silent! nmap <silent> n n<Plug>SearchIndex
silent! nmap <silent> N N<Plug>SearchIndex
" also swap * and # - make # use n for next, N for prev
silent! map *  <Plug>ImprovedStar_#<Plug>SearchIndex
silent! map #  <Plug>ImprovedStar_*<Plug>SearchIndex
silent! map g* <Plug>ImprovedStar_g#<Plug>SearchIndex
silent! map g# <Plug>ImprovedStar_g*<Plug>SearchIndex

" ------------------ bundled markdown -----------
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'elixir', 'bash=sh']

" ------------------ Gblame fugutive emulation -----
function! s:BlameSplit()
  let l:line = line('.')
  let l:firstline = line('w0')
  set scrollbind

  let rawcommand = 'git blame % | perl -pe ''s|^(\\w+ \\(.*?\\)).*$|\\1|'''
  let command = join(map(split(rawcommand), 'expand(v:val)'))
  silent! execute 'vnew ' . fnameescape(command)
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  setlocal readonly nomodifiable
  execute l:firstline . ' | normal zt'
  execute l:line . ' | syncbind'
  let l:linewidth = max([5, strlen(getline(1))])
  silent! execute 'vertical resize ' . l:linewidth
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'' | set scrollbind!'
  echo 'Shell command ' . command . ' executed.'
endfunction
command! Gblame call s:BlameSplit()
