" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2013/10/07 09:06:46.
" --------------------------------------------------------------------------------------------------------

" INITIALIZE {{{
" --------------------------------------------------------------------------------------------------------
set nocompatible
filetype off
scriptencoding utf-8
set encoding=utf-8
if !executable(&shell) | set shell=sh | endif
let s:isunix = has('unix')
let s:iswin = has('win16') || has('win32') || has('win64')
let s:iscygwin = has('win32unix')
let s:ismac = !s:iswin && !s:iscygwin && (has('mac') || has('macunix') || has('guimacvim') || system('uname') =~? '^darwin')
let s:nosudo = $SUDO_USER == ''
augroup ESC
  autocmd!
augroup END
augroup SetLocal
  autocmd!
augroup END
function! CompleteNothing(findstart, base)
  return a:findstart ? -1 : []
endfunction
" }}}

" Bundles {{{
let $VIM = expand('~/.vim')
let $CACHE = $VIM.'/.cache'
let $BUNDLE = $VIM.'/bundle'
let s:neobundle_dir = $BUNDLE.'/neobundle.vim'
if filereadable($VIM.'/.vimrc.secret') | source $VIM/.vimrc.secret | endif
if !isdirectory(s:neobundle_dir)

" neobundle {{{
" --------------------------------------------------------------------------------------------------------
  if executable('git')
    echo 'Initializing neobundle'
    execute '!mkdir -p '.$BUNDLE
       \.' && git clone https://github.com/Shougo/neobundle.vim '.$BUNDLE.'/neobundle.vim'
       \.' && git clone https://github.com/Shougo/unite.vim '.$BUNDLE.'/unite.vim'
       \.' && git clone https://github.com/Shougo/vimproc '.$BUNDLE.'/vimproc'
    if s:ismac
      if executable('llvm-gcc')
        execute '!cd '.$BUNDLE.'/vimproc && make -f make_mac.mak'
      elseif executable('gcc')
        execute '!cd '.$BUNDLE.'/vimproc && '
              \.'gcc -O3 -W -Wall -Wno-unused -bundle -fPIC -arch x86_64 -arch '
              \.'i386 -o autoload/vimproc_mac.so autoload/proc.c -lutil'
      else
        echo 'gcc not found!'
      endif
    elseif s:iswin
      echo 'access https://github.com/Shougo/vimproc/downloads to get dll'
    else
      if executable('gcc')
        execute '!cd '.$BUNDLE.'/vimproc && make -f make_unix.mak'
      else
        echo 'gcc not found!'
      endif
    endif
  else
    echo 'git not found! Sorry, this .vimrc cannot be completely used without git.'
  endif
else
if has('vim_starting')
  execute 'set runtimepath+='.expand(s:neobundle_dir)
endif
call neobundle#rc(expand($BUNDLE))
NeoBundleFetch 'Shougo/neobundle.vim'
  " nnoremap <silent> <S-b><S-b> :<C-u>NeoBundleUpdate<CR>
  nnoremap <silent> <S-b><S-b> :<C-u>Unite neobundle/update<CR>
" }}}

" Colorscheme {{{
" --------------------------------------------------------------------------------------------------------
try
NeoBundle 'itchyny/landscape.vim', {'type': 'nosync'}
  colorscheme landscape
  let g:landscape_highlight_url = 1
  let g:landscape_highlight_todo = 1
  let g:landscape_highlight_full_space = 0
  let g:landscape_highlight_url_filetype = {'thumbnail': 0}
catch
  colorscheme wombat256
endtry
  let g:solarized_termcolors = 256
NeoBundleLazy 'xterm-color-table.vim', {'autoload': {'commands': [{'name': 'XtermColorTable', 'complete': 'customlist,CompleteNothing'}]}}
  " http://www.vim.org/scripts/script.php?script_id=3412
" }}}

" Lightline {{{
" --------------------------------------------------------------------------------------------------------
NeoBundle 'itchyny/lightline.vim', {'type': 'nosync'}
  let g:lightline = {
        \ 'colorscheme': 'landscape',
        \ 'mode_map': { 'c': 'NORMAL' },
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], [ 'ctrlpmark' ] ],
        \   'right': [ [ 'syntastic_error', 'syntastic_warning', 'lineinfo'], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'inactive': {
        \   'left': [ [ 'filename' ] ],
        \   'right': [ [ 'lineinfo' ], [ 'percent' ] ]
        \ },
        \ 'tabline': {
        \   'left': [ [ 'tabs' ] ],
        \   'right': [ [ 'close' ] ]
        \ },
        \ 'tab': {
        \   'active': [ 'tabnum', 'readonly', 'filename', 'modified' ],
        \   'inactive': [ 'tabnum', 'readonly', 'filename', 'modified' ]
        \ },
        \ 'component': {
        \   'close': printf('%%999X %s ', has('multi_byte') ? "\u2717" : 'x'),
        \ },
        \ 'component_function': {
        \   'fugitive': 'MyFugitive',
        \   'filename': 'MyFilename',
        \   'fileformat': 'MyFileformat',
        \   'filetype': 'MyFiletype',
        \   'fileencoding': 'MyFileencoding',
        \   'mode': 'MyMode',
        \   'ctrlpmark': 'CtrlPMark',
        \ },
        \ 'component_expand': {
        \   'syntastic_error': 'SyntasticStatuslineFlagError',
        \   'syntastic_warning': 'SyntasticStatuslineFlagWarning',
        \ },
        \ 'component_type': {
        \   'syntastic_error': 'error',
        \   'syntastic_warning': 'warning',
        \ },
        \ 'tab_component_function': {
        \   'filename': 'MyTabFilename',
        \   'readonly': 'MyTabReadonly',
        \ },
        \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
        \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
        \ }
  function! MyFilename()
    let fname = expand('%:t')
    let ret = fname == 'ControlP' ? g:lightline.ctrlp_item :
          \ fname == '__Tagbar__' ? g:lightline.fname :
          \ fname =~ '__Gundo\|NERD_tree' ? '' :
          \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
          \ &ft == 'unite' ? unite#get_status_string() :
          \ &ft == 'vimshell' ? substitute(b:vimshell.current_dir,expand('~'),'~','') :
          \ &ft == 'dictionary' ? (exists('b:dictionary.input') ? b:dictionary.input : '') :
          \ (&readonly ? "\u2b64 " : '') .
          \ ('' != fname ? fname : '[No Name]') .
          \ (&modified ? ' +' : &modifiable ? '' : ' -')
    return substitute(s:V.truncate_skipping(ret, winwidth(0) * 2 / 3, winwidth(0) / 2, ' .. '), '\s\+$', '', '')
  endfunction
  function! MyFugitive()
    try
      if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
        let _ = fugitive#head()
        return strlen(_) ? "\u2b60 "._ : ''
      endif
    catch
    endtry
    return ''
  endfunction
  function! MyFileformat()
    return &ft !~? 'vimfiler\|vimshell' && winwidth(0) > 70 ? &fileformat : ''
  endfunction
  function! MyFiletype()
    return &ft !~? 'vimfiler\|vimshell' && winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
  endfunction
  function! MyFileencoding()
    return &ft !~? 'vimfiler\|vimshell' && winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
  endfunction
  function! MyMode()
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? 'Tagbar' :
          \ fname == 'ControlP' ? 'CtrlP' :
          \ fname == '__Gundo__' ? 'Gundo' :
          \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
          \ fname =~ 'NERD_tree' ? 'NERDTree' :
          \ &ft == 'unite' ? 'Unite' :
          \ &ft == 'vimfiler' ? 'VimFiler' :
          \ &ft == 'vimshell' ? 'VimShell' :
          \ &ft == 'dictionary' ? 'Dictionary' :
          \ winwidth(0) > 60 ? lightline#mode() : ''
  endfunction
  function! CtrlPMark()
    if expand('%:t') =~ 'ControlP'
      call lightline#link('iR'[g:lightline.ctrlp_regex])
      return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item, g:lightline.ctrlp_next], 0)
    else
      return ''
    endif
  endfunction
  let g:ctrlp_status_func = {
    \ 'main': 'CtrlPStatusFunc_1',
    \ 'prog': 'CtrlPStatusFunc_2',
    \ }
  function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
    let g:lightline.ctrlp_regex = a:regex
    let g:lightline.ctrlp_prev = a:prev
    let g:lightline.ctrlp_item = a:item
    let g:lightline.ctrlp_next = a:next
    return lightline#statusline(0)
  endfunction
  function! CtrlPStatusFunc_2(str)
    return lightline#statusline(0)
  endfunction
  let g:tagbar_status_func = 'TagbarStatusFunc'
  function! TagbarStatusFunc(current, sort, fname, ...) abort
      let g:lightline.fname = a:fname
    return lightline#statusline(0)
  endfunction
  function! MyTabReadonly(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    return gettabwinvar(a:n, winnr, '&readonly') ? '⭤' : ''
  endfunction
  function! MyTabFilename(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let fname = expand("#".buflist[winnr - 1].":t")
    let ft = gettabwinvar(a:n, winnr, '&filetype')
    return fname == 'ControlP' ? 'CtrlP' :
          \ fname == '__Tagbar__' ? 'Tagbar' :
          \ fname =~ '__Gundo' ? 'Gundo' :
          \ fname =~ 'NERD_tree' ? 'NERDtree' :
          \ ft == 'vimfiler' ? 'VimFiler' :
          \ ft == 'unite' ? 'Unite' :
          \ ft == 'vimshell' ? 'VimShell' :
          \ ft == 'dictionary' ? 'Dictionary' :
          \ strlen(fname) ? fname : '[No Name]'
  endfunction
  function! SyntasticStatuslineFlagError()
    if exists('b:syntastic_loclist') && len(b:syntastic_loclist.errors())
      return substitute(substitute(b:syntastic_loclist.errors()[0].text, '%', '%%', 'g'), '\[.\{-}\]', '', 'g')
    endif
    return ''
  endfunction
  function! SyntasticStatuslineFlagWarning()
    if exists('b:syntastic_loclist') && len(b:syntastic_loclist.warnings()) && !len(b:syntastic_loclist.errors())
      return substitute(substitute(b:syntastic_loclist.warnings()[0].text, '%', '%%', 'g'), '\[.\{-}\]', '', 'g')
    endif
    return ''
  endfunction
  augroup LightLineColorscheme
    autocmd!
    autocmd ColorScheme * call s:lightline_update()
  augroup END
  function! s:lightline_update()
    if !exists('g:loaded_lightline') || !exists('g:loaded_vimrc')
      return
    endif
    try
      if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|Tomorrow'
        let g:lightline.colorscheme = substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '') .
              \ (g:colors_name ==# 'solarized' ? '_' . &background : '')
        call lightline#init()
        call lightline#colorscheme()
        call lightline#update()
      endif
    catch
    endtry
  endfunction
try
" --|  $ sudo apt-get install fontforge
" --|  $ sudo apt-get install python-fontforge
" --|  $ cd ~/.vim/bundle/vim-powerline/fontpatcher
" --|  $ wget http://levien.com/type/myfonts/Inconsolata.otf
" --|  $ python ./fontpatcher ./Inconsolata.otf
" --|  $ sudo cp ./Inconsolata-Powerline.otf /usr/share/fonts
if s:ismac
  set guifont=Inconsolata\ for\ Powerline:h15
elseif s:iswin
  set guifont=Inconsolata_for_Powerline:h13:cANSI
else
  set guifont=Inconsolata\ for\ Powerline\ 12
endif
if s:iswin
  set guifontwide=MS_Gothic:h11:cSHIFTJIS
endif
catch
endtry
" }}}

" Complement {{{
" --------------------------------------------------------------------------------------------------------
if has('lua') && v:version > 703
NeoBundle 'Shougo/neocomplete.vim'
NeoBundleLazy 'Shougo/neocomplcache'
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#max_list = 1000
  let g:neocomplete#skip_auto_completion_time = "0.50"
  let g:neocomplete#enable_auto_close_preview = 1
  let g:neocomplete#auto_completion_start_length = 1
  let g:neocomplete#max_keyword_width = 50
  let g:neocomplete#data_directory = $CACHE.'/neocomplete'
  if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_overwrite_completefunc = 1
  let g:neocomplete#force_omni_input_patterns.c =
              \ '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#force_omni_input_patterns.cpp =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#force_omni_input_patterns.objc =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#force_omni_input_patterns.objcpp =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  function! s:cancel_popup(key)
    return a:key . neocomplete#cancel_popup()
  endfunction
  function! s:cancel_popup_reverse(key)
    return neocomplete#cancel_popup() . a:key
  endfunction
  function! s:goback_insert(key)
    return "gi" . a:key . neocomplete#cancel_popup()
  endfunction
else
NeoBundle 'Shougo/neocomplcache'
NeoBundleLazy 'Shougo/neocomplete.vim'
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_enable_smart_case = 1
  let g:neocomplcache_enable_underbar_completion = 1
  let g:neocomplcache_enable_camel_case_completion = 1
  let g:neocomplcache_enable_cursor_hold_i = 0
  let g:neocomplcache_max_list = 350
  let g:neocomplcache_skip_auto_completion_time = "0.50"
  let g:neocomplcache_enable_auto_close_preview = 1
  let g:neocomplcache_auto_completion_start_length = 1
  let g:neocomplcache_max_menu_width = 20
  let g:neocomplcache_max_keyword_width = 50
  let g:neocomplcache_context_filetype_lists = {}
  let g:neocomplcache_temporary_dir = $CACHE.'/neocomplcache'
  if !exists('g:neocomplcache_force_omni_patterns')
      let g:neocomplcache_force_omni_patterns = {}
  endif
  let g:neocomplcache_force_overwrite_completefunc = 1
  let g:neocomplcache_force_omni_patterns.c =
              \ '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_force_omni_patterns.cpp =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplcache_force_omni_patterns.objc =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplcache_force_omni_patterns.objcpp =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  function! s:cancel_popup(key)
    return a:key . neocomplcache#cancel_popup()
  endfunction
  function! s:cancel_popup_reverse(key)
    return neocomplcache#cancel_popup() . a:key
  endfunction
  function! s:goback_insert(key)
    return "gi" . a:key . neocomplcache#cancel_popup()
  endfunction
endif
NeoBundle 'Shougo/neosnippet'
  let g:neosnippet#snippets_directory = expand($VIM.'/snippets')
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: "\<TAB>"
NeoBundle 'ujihisa/neco-look', {'disabled': !executable('look')}
" }}}

" Unite ( "," ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ","
if s:nosudo
NeoBundle 'Shougo/unite.vim'
  let g:unite_enable_start_insert = 1
  let g:unite_cursor_line_highlight = 'CursorLine'
  let g:unite_source_file_mru_limit = 1000
  let g:unite_source_file_mru_do_validate = 0
  let g:unite_source_file_mru_filename_format = ':~'
  let g:unite_force_overwrite_statusline = 0
  let g:unite_data_directory = $CACHE.'/unite'
  let g:unite_source_grep_command = 'grep'
  let g:unite_source_grep_default_opts = '-iHn'
  if s:ismac && has('multi_byte')
    let g:unite_marked_icon = '✓'
  else
    let g:unite_marked_icon = 'v'
  endif
  let g:unite_candidate_icon = '-'
  nnoremap <C-u> :Unite<SPACE>
  nnoremap <silent><C-p> :Unite buffer -buffer-name=buffer<CR>
  nnoremap <silent><C-n> :Unite file/new directory/new -buffer-name=file/new,directory/new<CR>
  nnoremap <silent><S-k> :Unite output:message -buffer-name=output<CR>
  nnoremap <silent><C-o> :execute 'Unite file:'.<SID>change_directory().' file/new -buffer-name=file'<CR>
  nnoremap <silent><C-z> :Unite file_mru -buffer-name=file_mru<CR>
  nnoremap <silent><S-l> :Unite line -buffer-name=line<CR>
  augroup Unite
    autocmd!
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-k> unite#do_action('vsplit')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-k> unite#do_action('vsplit')
    autocmd FileType unite inoremap <silent> <buffer> <C-z> <Nop>
    autocmd FileType unite inoremap <silent> <buffer> <C-o> <Nop>
    autocmd FileType unite nmap <buffer> <C-a> <Plug>(unite_insert_enter)
    autocmd FileType unite nmap <buffer> OA <Plug>(unite_rotate_previous_source)
    autocmd FileType unite nnoremap <buffer> OB <Down>
    autocmd FileType unite nmap <buffer> <Bs> <Plug>(unite_exit)
  augroup END
  autocmd ESC FileType unite nmap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
  let s:startfiletypes = '.*\.\(exe\|png\|gif\|jpg\|jpeg\|bmp\|eps\|pdf\|mp3\|mp4\|avi\|mkv\|tiff\)$'
  let s:auto_open = {
        \ 'description' : 'edit or open files',
        \ 'is_selectable' : 1,
        \ }
  function! s:auto_open.func(candidates)
    try
      for candidate in a:candidates
        call unite#take_action(candidate.word =~? s:startfiletypes ? 'start' : 'open', candidate)
      endfor
    catch
    endtry
  endfunction
  let s:eject = {
        \ 'description': 'eject',
        \ 'is_selectable': 0,
        \ }
  function! s:eject.func(candidate)
    try
      let c = 'sudo ' . (executable('eject') ? 'eject' : s:ismac ? 'diskutil umount' : '')
            \ . ' "' . a:candidate.action__path . '"'
      if strlen(c)
        let s:eject.path = a:candidate.action__path
        let s:eject.count = 0
        exe 'VimShellInteractive --split="split | resize 20" ' . c
      endif
    catch
    endtry
  endfunction
  let bundle = neobundle#get('unite.vim')
  function! bundle.hooks.on_post_source(bundle)
    if exists('*unite#custom_source')
      call unite#custom_source('file', 'ignore_pattern'
            \, '.*\.\(o\|exe\|dll\|bak\|sw[po]\|hi\|fff\|aux\|toc\|bbl\|blg\|DS_Store\)$')
      call unite#custom_source('haddock,hoogle', 'max_candidates', 20)
    endif
    if exists('*unite#custom_action')
      call unite#custom_action('file', 'auto_open', s:auto_open)
      call unite#custom_action('file', 'eject', s:eject)
    endif
    if exists('*unite#custom_default_action')
      call unite#custom_default_action('file', 'auto_open')
    endif
    let path = expand('~')
    for file in [$CACHE.'/unite/file_mru', $CACHE.'/unite/directory_mru']
      silent call writefile(map(readfile(file), "substitute(v:val, '^/home/\\a\\+', path, '')"), file)
    endfor
  endfunction
NeoBundleLazy 'Shougo/unite-build', {'autoload': {'unite_sources': ['build']}}
  nnoremap <silent><F5> :<C-u>Unite build -buffer-name=build<CR>
NeoBundleLazy 'unite-colorscheme', {'autoload': {'unite_sources': ['colorscheme']}}
NeoBundleLazy 'osyo-manga/unite-highlight', {'autoload': {'unite_sources': ['highlight']}}
NeoBundleLazy 'eagletmt/unite-haddock', {'autoload': {'unite_sources': ['hoogle']}, 'disabled': !executable('hoogle')}
  nnoremap <Leader>h :<C-u>Unite hoogle -buffer-name=hoogle<CR>
  " --| Requirement: hoogle
  " --|   $ cabal install hoogle
  " --|   $ hoogle data
NeoBundleLazy 'h1mesuke/unite-outline', {'autoload': {'unite_sources': ['outline']}}
NeoBundleLazy 'ujihisa/unite-haskellimport', {'autoload': {'unite_sources': ['haskellimport']}}
endif
" }}}

" QuickRun / Filer / Outer world of Vim ( "\\" ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = "\\"
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'unix' : 'make -f make_unix.mak',
  \   },
  \ }
NeoBundle 'thinca/vim-quickrun'
  let g:quickrun_config = {'_': {'runner': 'vimproc', 'runner/vimproc/updatetime': 60, 'split': 'vertical', 'into': 1}}
  let s:quickrun_command_list = map(split(
        \ 'quickrun;cat,javascript;node,roy;roy,qcl;qcl,haskell;runhaskell,bf;bf', ','), 'split(v:val, ";")')
  for [ft, exe] in s:quickrun_command_list
    execute printf('if executable("%s") | let g:quickrun_config.%s = {"command":"%s"} | endif', exe, ft, exe)
  endfor
  if executable('pandoc')
    let g:quickrun_config.markdown = {'type' : 'markdown/pandoc', 'outputter': 'browser', 'cmdopt': '-s'}
  endif
  if executable('autolatex')
    let g:quickrun_config.tex = {'command' : 'autolatex'}
  elseif executable('platex')
    let g:quickrun_config.tex = {'command' : 'platex'}
  endif
  if executable('man')
    let g:quickrun_config.nroff = {'command': 'man',
          \ 'args': " -P cat | tr '\b' '\1' | sed -e 's/.\1//g'", 'filetype': 'man'}
  endif
  if executable('autognuplot')
    let g:quickrun_config.gnuplot = {'command' : 'autognuplot'}
  elseif executable('gnuplot')
    let g:quickrun_config.gnuplot = {'command' : 'gnuplot'}
  endif
  let g:quickrun_config.objc = {'command': 'cc',
        \ 'exec': ['%c %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'],
        \ 'tempfile': '{tempname()}.m'}
  if executable('scad3.exe')
    let g:quickrun_config.spice = {'command': 'scad3.exe', 'exec': ['%c -b %s:t'] }
  endif
  if executable('abcm2ps')
    let g:quickrun_config.abc = {'command': 'abcm2ps',
          \ 'exec': ['%c %s -O %s:p:r.ps', 'ps2pdf %s:p:r.ps', 'open %s:p:r.pdf']}
    if executable('abc2midi')
      call extend(g:quickrun_config.abc.exec, ['abc2midi %s -o %s:p:r.mid', 'open %s:p:r.mid'])
    endif
  endif
  nnoremap <Leader>r :<C-u>QuickRun<CR>
  nnoremap <Leader><Leader>r :<C-u>QuickRun >file:temp.dat<CR>
  nnoremap <Leader>e :<C-u>QuickRun <i <CR>
  nnoremap <Leader>o :<C-u>QuickRun <i >file:output<CR>
  autocmd ESC FileType quickrun nnoremap <silent> <buffer> <ESC><ESC> <ESC>:q!<CR>
  autocmd ESC FileType quickrun vnoremap <silent> <buffer> <ESC><ESC> <ESC>:q!<CR>
  autocmd SetLocal FileType quickrun nnoremap <silent> <buffer> q :<C-u>bdelete!<CR>
if s:nosudo
NeoBundle 'Shougo/vimfiler'
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_sort_type = 'TIME'
  let g:vimfiler_safe_mode_by_default = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_data_directory = $CACHE.'/vimfiler'
  if s:iswin || !has('multi_byte')
    let g:vimfiler_tree_leaf_icon = '|'
    let g:vimfiler_tree_opened_icon = '-'
    let g:vimfiler_tree_closed_icon = '+'
  else
    let g:vimfiler_tree_leaf_icon = ' '
    let g:vimfiler_tree_opened_icon = '▾'
    let g:vimfiler_tree_closed_icon = '▸'
  endif
  let g:vimfiler_file_icon = '-'
  if s:ismac && has('multi_byte')
    let g:vimfiler_readonly_file_icon = '✗'
    let g:vimfiler_marked_file_icon = '✓'
  else
    let g:vimfiler_readonly_file_icon = 'x'
    let g:vimfiler_marked_file_icon = 'v'
  endif
  nnoremap <silent> <Leader>f :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  nnoremap <silent> <Leader><Leader> :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  nnoremap <silent> @<Leader> :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  nnoremap <silent>@@ :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  let g:vimfiler_execute_file_list = {}
  for ft in split('pdf,png,jpg,jpeg,gif,bmp,ico,ppt,html', ',')
    let g:vimfiler_execute_file_list[ft] = 'open'
  endfor
  function! s:changetime()
    let marked_files = vimfiler#get_marked_filenames()
    if !empty(marked_files)
      return
    endif
    let file = vimfiler#get_file()
    if empty(file)
      return
    endif
    let filepath = file.action__path
    let vimfiler_current_dir = get(unite#get_context(), 'vimfiler__current_directory', '')
    if vimfiler_current_dir == ''
      let vimfiler_current_dir = getcwd()
    endif
    let current_dir = getcwd()
    if system('stat -l . > /dev/null 2>&1; echo $?') =~ '^0'
      let atime = system('stat -lt "%Y/%m/%d %H:%M" "'.filepath
            \."\" | awk {'print $6\" \"$7'} | tr -d '\\n'")
    else
      let atime = system('stat --printf "%y" "'.filepath."\" | sed -e 's/\\..*//'")
    endif
    let atime = substitute(atime, '-', '/', 'g')
    try
      lcd `=vimfiler_current_dir`
      let newtime = input(printf('New time: %s -> ', atime))
      redraw
      if newtime == ''
        let newtime = atime
      endif
      let newtime = substitute(newtime, '\d\@<!\(\d\)$', '0\1', '')
      let newtime = substitute(newtime, '\d\@<!\(\d\)\d\@!', '0\1', 'g')
      let newtime = substitute(newtime, '[ -]', '', 'g')
      if newtime =~? '^\d\+/\d\+/\d\+$' || len(newtime) <= 8
        let newtime .= '0000'
      endif
      let newtime = substitute(newtime, '\(\d\+:\d\+\):\(\d\+\)$', '\1.\2', '')
      let newtime = substitute(newtime, '[/:]', '', 'g')
      call system('touch -at '.newtime.' -mt '.newtime.' "'.filepath.'"')
    finally
      lcd `=current_dir`
    endtry
  endfunction
  augroup Vimfiler
    autocmd!
    autocmd FileType vimfiler nunmap <buffer> <C-l>
    autocmd FileType vimfiler nunmap <buffer> \
    autocmd FileType vimfiler nnoremap <buffer> <C-l> <ESC><C-w>l
    autocmd FileType vimfiler nmap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
    autocmd FileType vimfiler nmap <buffer> O <Plug>(vimfiler_sync_with_another_vimfiler)
    autocmd FileType vimfiler nmap <buffer><expr> e
          \ vimfiler#smart_cursor_map("\<Plug>(vimfiler_cd_file)", "\<Plug>(vimfiler_edit_file)")
    autocmd FileType vimfiler nnoremap <buffer><expr> t <SID>changetime()
    autocmd FileType vimfiler if filereadable("Icon\r") | silent call delete("Icon\r") | endif
  augroup END
NeoBundle 'itchyny/vimfiler-preview', {'type': 'nosync'}
  let g:vimfiler_preview_action = 'auto_preview'
  let bundle = neobundle#get('vimfiler-preview')
  function! bundle.hooks.on_post_source(bundle)
    if exists('*unite#custom_action')
      call unite#custom_action('file', 'auto_preview', g:vimfiler_preview)
    endif
  endfunction
NeoBundle 'Shougo/vinarise'
endif
NeoBundleLazy 'eagletmt/ghci-vim', {'autoload': {'filetypes': ['haskell']}}
  let bundle = neobundle#get('ghci-vim')
  function! bundle.hooks.on_post_source(bundle)
    augroup Ghci
      autocmd!
      autocmd FileType haskell nnoremap <buffer> <Leader>l <expr> exec 'GhciLoad'
      autocmd FileType haskell nnoremap <buffer> <Leader>i <expr> exec 'GhciInfo'
      autocmd FileType haskell nnoremap <buffer> <Leader>t <expr> exec 'GhciType'
    augroup END
  endfunction
NeoBundle 'tyru/open-browser.vim', {'autoload' : {'mappings' : ['<Plug>(openbrowser-']}}
  nmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
  vmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
  nmap <silent> <Leader>s <Plug>(openbrowser-search)
NeoBundle 'mattn/webapi-vim'
NeoBundleLazy 'mattn/googletasks-vim', {'autoload': {'commands': [{'name': 'GoogleTasks', 'complete': 'customlist,CompleteNothing'}]}}
" }}}

" vimshell ( ";" ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ";"
NeoBundle 'Shougo/vimshell'
" --| Requirement: vimproc
" --| If you can't use sudo, do:
" --|  $ sudo chmod 4755 /usr/bin/sudo
  let g:vimshell_interactive_update_time = 150
  let g:vimshell_popup_command = 'top new'
  let g:vimshell_split_command = 'vsplit'
  " let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
  " let g:vimshell_prompt = ' $ '
  let g:vimshell_prompt_expr = 'escape(fnamemodify(getcwd(), ":~"), "\\[]()?! ")." "'
  let g:vimshell_prompt_pattern = (s:iswin ? '\%(^\f:' : '\%(^[~/]') . '\%(\f\|\\.\)* \|^[a-zA-Z][a-zA-Z .0-9]\+> \|^>>> \)'
  let g:vimshell_scrollback_limit = 1000000000
  let g:vimshell_disable_escape_highlight = 0
  let g:vimshell_force_overwrite_statusline = 0
  let g:vimshell_temporary_directory = $CACHE.'/vimshell'
  let g:vimshell_max_command_history = 1000000
  let g:vimshell_vimshrc_path = expand('~/Dropbox/dotfiles/.vimshrc')
  augroup Vimshell
    autocmd!
    " for easy window moving, unmap C-[hjkl]
    autocmd FileType vimshell iunmap <buffer> <C-h>
    autocmd FileType vimshell iunmap <buffer> <C-k>
    autocmd FileType vimshell iunmap <buffer> <C-l>
    autocmd FileType vimshell iunmap <buffer> <C-w>
    autocmd FileType vimshell nunmap <buffer> <C-k>
    autocmd FileType vimshell nunmap <buffer> <C-l>
    autocmd FileType vimshell nnoremap <buffer> <C-a> <Nop>
    autocmd FileType vimshell nnoremap <buffer> <C-m> <ESC><C-w>j
    autocmd FileType vimshell inoremap <buffer> <C-h> <ESC><C-w>h
    autocmd FileType vimshell inoremap <buffer> <C-j> <ESC><C-w>j
    autocmd FileType vimshell inoremap <buffer> <C-k> <ESC><C-w>k
    autocmd FileType vimshell inoremap <buffer> <C-l> <ESC><C-w>l
    autocmd FileType vimshell inoremap <silent><buffer> ^
          \ <ESC>:call vimshell#execute('cd ../')<CR>
          \:call vimshell#print_prompt()<CR>
          \:call vimshell#start_insert()<CR>
    autocmd FileType vimshell vnoremap <buffer> a <ESC><ESC>GA
    autocmd FileType vimshell vnoremap <buffer> y yGA
    autocmd FileType vimshell inoremap <buffer> <C-^> <ESC><C-^>
    let s:start_complete = ' "\<ESC>GA" . unite#sources#vimshell_history#start_complete(!0)'
    for s:key in ['<UP>', '<Down>', 'OA', 'OB']
      execute "autocmd FileType vimshell inoremap <buffer> <expr><silent> ".s:key.s:start_complete
      execute "autocmd FileType vimshell nnoremap <buffer> <expr><silent> ".s:key.s:start_complete
    endfor
  augroup END
  nnoremap <silent> <Leader><Leader>s :<C-u>VimShell -split<CR>
  nnoremap <silent> <Leader>s :<C-u>VimShellBufferDir<CR>
  nnoremap <silent> <S-h> :<C-u>VimShellBufferDir -popup<CR>
  nnoremap <Leader>z :<C-u>VimShellInteractive zsh<CR>
  nnoremap <Leader>p :<C-u>VimShellInteractive python<CR>
  nnoremap <silent> s :<C-u>VimShellBufferDir<CR>
NeoBundleLazy 'ujihisa/neco-ghc', {'autoload': {'filetypes': ['haskell']}, 'disabled': !executable('ghc-mod')}
  let g:necoghc_enable_detailed_browse = 1
NeoBundleLazy 'eagletmt/ghcmod-vim', {'autoload': {'filetypes': ['haskell']}, 'disabled': !executable('ghc-mod')}
  nnoremap <Leader>g :<C-u>GhcModCheckAsync<CR>
  " --| Requirement: ghc-mod
  " --|  $ cabal install ghc-mod
" }}}

" Commenter / Utility / Matching ( "," ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ","
NeoBundle 'tpope/vim-surround'
  let g:surround_{char2nr('$')} = "$\r$" " for LaTeX
NeoBundle 'tComment'
  augroup tComment
    autocmd!
    autocmd FileType gnuplot call tcomment#DefineType('gnuplot', '# %s')
    autocmd FileType haxe call tcomment#DefineType('haxe', '// %s')
    autocmd FileType meissa call tcomment#DefineType('meissa', '# %s')
    autocmd FileType spice call tcomment#DefineType('spice', '* %s')
  augroup END
  nnoremap <silent> __ :TComment<CR>
  vnoremap <silent> __ :TComment<CR>
  let g:tcommentMapLeader1 = ''
NeoBundleLazy 'Align', {'autoload': {'commands': [{'name': 'Align', 'complete': 'customlist,CompleteNothing'}]}}
NeoBundleLazy 'mattn/calendar-vim', {'autoload': {'commands': ['Calendar', 'CalendarH', 'CalendarT']}}
  autocmd ESC FileType calendar nnoremap <silent> <buffer> <ESC><ESC> :<C-u>q<CR>
  nnoremap <silent> <Leader>c :<C-u>CalendarT<CR>
  let g:calendar_keys = { 'goto_next_year': '<Down>', 'goto_prev_year': '<Up>'}
  let calendar_no_mappings = 1
NeoBundle 'autodate.vim'
  let g:autodate_format = '%Y/%m/%d %H:%M:%S'
NeoBundleLazy 'sjl/gundo.vim', {'autoload': {'commands': [{'name': 'GundoToggle', 'complete': 'customlist,CompleteNothing'}]}, 'disabled': !has('python')}
  nnoremap <Leader>g :<C-u>GundoToggle<CR>
  autocmd ESC FileType gundo nnoremap <silent> <buffer> <ESC><ESC> :<C-u>GundoToggle<CR>
NeoBundleLazy 'VimCalc', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Calc', 'complete': 'customlist,CompleteNothing'}]}, 'disabled': !has('python')}
  autocmd ESC FileType vimcalc nnoremap <silent> <buffer> <ESC><ESC><ESC> :<C-u>q<CR>
  nnoremap <silent> <Leader>a :<C-u>Calc<CR>
NeoBundleLazy 'kana/vim-fakeclip'
NeoBundle 'gregsexton/MatchTag'
NeoBundle 'matchit.zip'
NeoBundleLazy 'thinca/vim-scouter', {'autoload': {'commands': [{'name': 'Scouter', 'complete': 'customlist,CompleteNothing'}]}}
NeoBundle 'thinca/vim-ambicmd'
  cnoremap <expr><SPACE> ambicmd#expand("\<SPACE>")
NeoBundle 'terryma/vim-multiple-cursors'
  let g:multi_cursor_use_default_mapping = 0
  let g:multi_cursor_next_key = "\<C-g>"
  let g:multi_cursor_prev_key = "\<C-y>"
  let g:multi_cursor_skip_key = "\<C-x>"
  let g:multi_cursor_exit_key = "\<Esc>"
  let g:multi_cursor_quit_key = "\<Esc>"
NeoBundle 'Lokaltog/vim-easymotion'
  let g:EasyMotion_leader_key = '<Leader>'
  let g:EasyMotion_keys = 'asdfwertxcvuiopbnmhjkl'
  let g:EasyMotion_do_shade = 0
  let g:EasyMotion_do_mapping = 0
  nnoremap <silent> <Leader>f :<C-u>call EasyMotion#F(0, 0)<CR>
  nnoremap <silent> <Leader>F :<C-u>call EasyMotion#F(0, 1)<CR>
  nnoremap <silent> <Leader>e :<C-u>call EasyMotion#E(0, 0)<CR>
  nnoremap <silent> <Leader>E :<C-u>call EasyMotion#E(0, 1)<CR>
  nnoremap <silent> <Leader>w :<C-u>call EasyMotion#WB(0, 0)<CR>
  nnoremap <silent> <Leader>W :<C-u>call EasyMotion#WBW(0, 1)<CR>
  nnoremap <silent> <Leader>j :<C-u>call EasyMotion#JK(0, 0)<CR>
  nnoremap <silent> <Leader>k :<C-u>call EasyMotion#JK(0, 1)<CR>
NeoBundleLazy 'pasela/unite-webcolorname', {'autoload': {'unite_sources': ['webcolorname']}}
NeoBundleLazy 'osyo-manga/vim-anzu', {'autoload' : {'mappings' : ['<Plug>(anzu-']}}
  nmap n <Plug>(anzu-n-with-echo)zv
  nmap N <Plug>(anzu-N-with-echo)zv
  nnoremap * :<C-u>set hlsearch<CR>:<C-u>call feedkeys("\<Plug>(anzu-star-with-echo)zv", 'm')<CR>
  let g:anzu_status_format = '%p (%i/%l)'
  let g:anzu_no_match_word = ''
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kien/ctrlp.vim'
  let g:ctrlp_cmd = 'CtrlPMRUFiles'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_max_depth = 5
  let g:ctrlp_max_files = 300
  let g:ctrlp_mruf_max = 300
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|swp|pdf|DS_Store)$',
    \ }
  let g:ctrlp_open_new_file = 'r'
  let g:ctrlp_use_caching = 1
  let g:ctrlp_cache_dir = $CACHE.'/ctrlp'
  let bundle = neobundle#get('ctrlp.vim')
  function! bundle.hooks.on_post_source(bundle)
    let path = expand('~')
    let file = g:ctrlp_cache_dir . '/mru/cache.txt'
    silent call writefile(map(readfile(file), "substitute(v:val, '^/home/\\a\\+', path, '')"), file)
  endfunction
NeoBundleLazy 'majutsushi/tagbar', {'autoload': {'commands': [{'name': 'Tagbar', 'complete': 'customlist,CompleteNothing'}]}}
NeoBundleLazy 'scrooloose/nerdtree', {'autoload': {'commands': [{'name': 'NERDTree', 'complete': 'dir'}]}}
NeoBundleLazy 'mattn/benchvimrc-vim', {'autoload': {'commands': [{'name': 'BenchVimrc', 'complete': 'customlist,CompleteNothing'}]}}
NeoBundle 'basyura/bitly.vim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'basyura/TweetVim'
  let g:tweetvim_display_separator = 0
  let g:tweetvim_display_icon = 1
  let g:tweetvim_display_source = 1
  let g:tweetvim_display_time = 1
  let g:tweetvim_display_username = 0
  let g:tweetvim_align_right = 1
  let g:tweetvim_include_rts = 1
  let g:tweetvim_expand_t_co = 1
  let g:tweetvim_async_post = 1
  let g:tweetvim_open_say_cmd = 'below split'
  let g:tweetvim_config_dir = $CACHE.'/tweetvim'
  function! TweetVim_say()
    for w in range(1, winnr('$'))
      if bufname(winbufnr(w)) =~ 'tweetvim_say'
        execute w 'wincmd w'
        return
      endif
    endfor
    silent TweetVimSay
  endfunction
  augroup TweetVim
    autocmd!
    autocmd FileType tweetvim nmap <buffer> h <Plug>(tweetvim_action_user_timeline)
    autocmd FileType tweetvim nmap <buffer> l <Plug>(tweetvim_action_open_links)
    autocmd FileType tweetvim nmap <buffer> f <Plug>(tweetvim_action_favorite)
    autocmd FileType tweetvim nmap <buffer> <CR> <Plug>(tweetvim_action_reply)
    autocmd FileType tweetvim nmap <silent> <buffer> q :<C-u>bdelete!<CR>
    autocmd FileType tweetvim nmap <silent> <buffer> <Tab> :<C-u>call TweetVim_say()<CR>
    autocmd FileType tweetvim_say imap <silent> <buffer> <CR> <ESC><CR>
    autocmd FileType tweetvim_say inoremap <silent> <buffer> <Tab> <ESC>:<C-u>wincmd p<CR>
    autocmd FileType tweetvim_say nnoremap <silent> <buffer> <Tab> :<C-u>wincmd p<CR>
  augroup END
NeoBundleLazy 'itchyny/thumbnail.vim', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Thumbnail', 'complete': 'customlist,thumbnail#complete'}]}}
  nnoremap <silent> <Leader>t :<C-u>Thumbnail -here<CR>
  augroup ThumbnailKey
    autocmd!
    autocmd FileType thumbnail nmap <buffer> v <Plug>(thumbnail_start_line_visual)
    autocmd FileType thumbnail nmap <buffer> V <Plug>(thumbnail_start_visual)
    autocmd FileType thumbnail call clearmatches()
  augroup END
NeoBundleLazy 'itchyny/calen.vim', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Calen', 'complete': 'customlist,calen#complete'}]}}
  nnoremap <silent> <Leader>z :<C-u>Calen<CR>
NeoBundleLazy 'itchyny/dictionary.vim', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Dictionary', 'complete': 'customlist,dictionary#complete'}]}}
  nnoremap <silent> <Leader>y :<C-u>Dictionary<CR>
  let g:dictionary_executable_path = '~/Dropbox/bin/'
NeoBundle 'vim-jp/vital.vim'
  let vital = neobundle#get('vital.vim')
  function! vital.hooks.on_post_source(bundle)
    let s:V = vital#of('vital')
  endfunction
" }}}

" Syntax {{{
" --------------------------------------------------------------------------------------------------------
NeoBundleLazy 'scrooloose/syntastic', {'autoload': {'filetypes': ['c', 'cpp'], 'functions': ['SyntasticStatuslineFlag']}}
  let g:syntastic_mode_map = { 'mode': 'passive' }
  let g:syntastic_echo_current_error = 0
  let g:syntastic_enable_highlighting = 0
  augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp call s:syntastic()
  augroup END
  function! s:syntastic()
    if exists(':SyntasticCheck') | exec 'SyntasticCheck' | endif
    if exists('*lightline#update') | call lightline#update() | endif
  endfunction
NeoBundleLazy 'mattn/emmet-vim', {'autoload': {'filetypes': ['html']}}
  let g:user_emmet_settings = { 'indentation' : '  ' }
  augroup Emmet
    autocmd!
    autocmd FileType html,css imap <tab> <plug>(EmmetExpandAbbr)
  augroup END
NeoBundleLazy 'itspriddle/vim-javascript-indent', {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'JSON.vim', {'autoload': {'filetypes': ['json']}}
NeoBundleLazy 'html5.vim', {'autoload': {'filetypes': ['html']}}
NeoBundleLazy 'wavded/vim-stylus', {'autoload': {'filetypes': ['stylus']}}
NeoBundleLazy 'groenewege/vim-less', {'autoload': {'filetypes': ['less']}}
NeoBundleLazy 'less.vim', {'autoload': {'filetypes': ['less']}}
NeoBundleLazy 'syntaxm4.vim', {'autoload': {'filetypes': ['m4']}}
NeoBundleLazy 'vim-scripts/jade.vim', {'autoload': {'filetypes': ['jade']}}
NeoBundleLazy 'vim-coffee-script', {'autoload': {'filetypes': ['coffee']}}
NeoBundleLazy 'rest.vim', {'autoload': {'filetypes': ['rest']}}
NeoBundleLazy 'vim-scripts/indenthaskell.vim', {'autoload': {'filetypes': ['haskell']}}
  let hs_highlight_boolean = 1
  let hs_highlight_types = 1
  let hs_highlight_more_types = 1
NeoBundleLazy 'tpope/vim-markdown', {'autoload': {'filetypes': ['m4']}}
NeoBundleLazy 'motemen/hatena-vim', {'autoload': {'filetypes': ['hatena']}}
  let g:hatena_upload_on_write = 0
  let g:hatena_user = 'itchyny'
NeoBundleLazy 'syngan/vim-vimlint', { 'depends' : 'ynkdir/vim-vimlparser', 'autoload' : { 'functions' : 'vimlint#vimlint'}}
" }}}

endif
" }}} Bundles

" ENCODING {{{
" --------------------------------------------------------------------------------------------------------
" SET {{{
set encoding=utf-8
set fenc=utf-8
set fileencodings=utf-8,euc-jp,sjis,jis,iso-2022-jp,cp932,latin
set formatoptions+=mM       " 日本語の行の連結時には空白を入力しない
" ☆や□や○の文字があってもカーソル位置がずれないようにする
" ambiwidthの設定のみでは, 解決しない場合がある
" Ubuntuでは, gnome-terminal, terminatorを以下のコマンドに貼り替えると解決する
"   /bin/sh -c "VTE_CJK_WIDTH=1 terminator -m"
"   /bin/sh -c "VTE_CJK_WIDTH=1 gnome-terminal --disable-factory"
" MacのiTermでは, Profiles>Text>Double-Width Characters
"                 >Treat ambiguous-width characters as double widthにチェック
set ambiwidth=double
" }}}

" 書類を開くことができませんでした。テキストエンコーディング日本語(Mac OS)には対応していません。 {{{
" http://d.hatena.ne.jp/uasi/20110523/1306079612
augroup SetUTF8Xattr
  autocmd!
  autocmd BufWritePost * call SetUTF8Xattr(escape(expand("<afile>"), "*[]?{}' "))
augroup END
function! SetUTF8Xattr(file)
  let isutf8 = &fileencoding == "utf-8" || (&fileencoding == "" && &encoding == "utf-8")
  if s:ismac && isutf8
    let c = "xattr -w com.apple.TextEncoding 'utf-8;134217984' \"".a:file."\" &"
    if exists('vimproc#system')
      call vimproc#system(c)
    else
      call system(c)
    endif
  endif
endfunction
" }}}

" 文字コードの自動認識 {{{
" http://www.kawaz.jp/pukiwiki/?vim#cb691f26
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc " .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding = &encoding
    endif
  endfunction
  augroup AU_ReCheck_FENC
    autocmd!
    autocmd BufReadPost * call AU_ReCheck_FENC()
  augroup END
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" }}}
" }}} ENCODING

" APPERANCE {{{
" --------------------------------------------------------------------------------------------------------
" Frame appearance {{{
" set showcmd
set noshowmode " https://github.com/vim-jp/issues/issues/100
" }}}

" Main appearance {{{
set list
if s:iswin || !has('multi_byte')
  set listchars=tab:^I,extends:>,precedes:<,nbsp:%
else
  try
    set listchars=tab:▸\ ,extends:»,precedes:«,nbsp:%
  catch
    set listchars=tab:^I,extends:>,precedes:<,nbsp:%
    let g:vimfiler_tree_leaf_icon = '|'
    let g:vimfiler_tree_opened_icon = '-'
    let g:vimfiler_tree_closed_icon = '+'
  endtry
endif
if exists('&breakindent')
  set breakindent
endif
set shortmess+=I            " disable start up message
set number
  autocmd SetLocal FileType vimshell,vimcalc,quickrun,int-ghci setlocal nonumber buftype=nofile
set cursorline
  augroup CursorLine
    autocmd!
    autocmd WinLeave * setlocal nocursorline
    autocmd BufEnter,WinEnter * setlocal cursorline
  augroup END
  autocmd SetLocal FileType calendar,vimcalc,vimshell,quickrun,int-ghci,cam setlocal nocursorline
        \ | autocmd SetLocal BufEnter,WinEnter <buffer> setlocal nocursorline
set nocursorcolumn
" http://blog.remora.cx/2012/10/spotlight-cursor-line.html
if &term =~ "screen"
  let &t_SI = "\eP\e]50;CursorShape=1\x7\e\\"
  let &t_EI = "\eP\e]50;CursorShape=0\x7\e\\"
elseif &term =~ "xterm"
  let &t_SI = "\e]50;CursorShape=1\x7"
  let &t_EI = "\e]50;CursorShape=0\x7"
endif
set showmatch
set showtabline=1
set previewheight=20
set pumheight=10
set history=100
set helplang=en
language C
set nospell
  function! s:myspell()
    if !exists('b:myspell_done') || b:myspell_done != &l:spell
      if &l:spell
        let spellbads = [ '^\(\S\+ \+\)\{30,}\S\+[,.]\?$', '\<a\> [aiueo]', '^\$', '\<figure..\?\\', '\\ref{eq:'
              \ , '^\\end{align}', '[^\~]\\\(eq\)\?ref\>', 'does not [a-z]*s ', 's [a-z][a-z]\+s ', '\<a \S\+s ', 'in default']
        let b:myspell_id = []
        for s in spellbads
          call add(b:myspell_id, matchadd('SpellBad', s))
        endfor
      elseif exists('b:myspell_id')
        for i in b:myspell_id
          call matchdelete(i)
        endfor
        unlet b:myspell_id
      endif
      let b:myspell_done = &l:spell
    endif
  endfunction
  function! s:autospell()
    if !exists('b:autospell_done')
      if search("[^\x01-\x7e]", 'n') == 0 && line('$') > 5
        setlocal spell
        call s:myspell()
      else
        setlocal nospell
      endif
      let b:autospell_done = 1
    endif
  endfunction
  augroup autospell
    autocmd!
    autocmd FileType tex,markdown call s:autospell()
    autocmd BufWritePost * call s:myspell()
  augroup END
set modeline
set modelines=1
set completeopt-=preview
if has('conceal')
  set concealcursor=nvc
  augroup SetConceal
    autocmd!
    autocmd FileType vimfiler set concealcursor=nvc
  augroup END
endif
" }}}

" Status line {{{
set ruler
set laststatus=2
set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}]
      \[%{&ff}][%3l,%3c,%3p][%{strftime(\"%m/%d\ %H:%M\")}]
" }}}

" Color {{{
syntax enable
set background=dark
set synmaxcol=9999
if !has('gui_running')
  set t_Co=256
endif
" }}}

" Statusline color {{{
let s:hi_sl = 'highlight StatusLine '
let s:hi_gui_common = 'guifg=black gui=none '
let s:hi_cterm_common = 'ctermfg=black cterm=none '
let s:hi_normal = s:hi_sl.s:hi_gui_common.s:hi_cterm_common.'guibg=blue ctermbg=blue'
let s:hi_insert = s:hi_sl.s:hi_gui_common.s:hi_cterm_common.'guibg=darkmagenta ctermbg=darkmagenta'
silent execute s:hi_normal
augroup InsertStatus
  autocmd!
  autocmd InsertEnter * execute s:hi_insert
  autocmd InsertLeave * execute s:hi_normal
augroup END
if has('unix') && !has('gui_running')
  " ESC後にすぐ反映されない対策(実際これいる)
  inoremap <silent> <ESC> <ESC>
endif
" }}}
" }}} APPERANCE

" FILE READING {{{
" --------------------------------------------------------------------------------------------------------
" SET {{{
set autoread
" }}}

" Filetype {{{
augroup SetLocalFiletype
  let filetypes1 = map(split('bf,gnuplot,jade,json,less,r,roy,tex,meissa,coffee', ','), '[v:val, v:val]')
  let filetypes2 = map(split('cls;tex,hs;haskell,hx;haxe,md;markdown,cir;spice,asc;spice,m;objc', ','), 'split(v:val, ";")')
  autocmd!
  for [ex, ft] in extend(filetypes1, filetypes2)
    execute 'autocmd BufNewFile,BufReadPost *.' . ex . ' setlocal filetype=' . ft
  endfor
  autocmd BufReadPost,BufWrite,CursorHold,CursorHoldI * call s:filetype()
augroup END
function! s:filetype()
  let newft = ''
  for [pat, ft] in map(split('*[;hatena,#include;c,\documentclass;tex,import;haskell,main =;haskell', ','), 'split(v:val, ";")')
    if getline(1)[:strlen(pat) - 1] ==# pat | let newft = ft | endif
  endfor
  if newft != '' && (&filetype == '' || &filetype == newft)  | exec 'setlocal filetype=' . newft | endif
endfunction
" }}}

" }}} FILE READING

" EDIT {{{
" --------------------------------------------------------------------------------------------------------
" Search {{{
set infercase
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch
set magic
" }}}

" Indent {{{
filetype plugin indent on
set autoindent
  autocmd SetLocal FileType tex,hatena setlocal noautoindent
  let g:tex_indent_items=0
set smartindent
  autocmd SetLocal FileType tex,hatena setlocal nosmartindent
set shiftwidth=2
  autocmd SetLocal FileType markdown setlocal shiftwidth=4
" }}}

" Special keys (tab, backspace) {{{
set textwidth=0   " No auto breking line
  autocmd SetLocal FileType rest setlocal textwidth=50
set expandtab
  function! s:autotab()
    if search('^\t.*\n\t.*\n\t', 'n') > 0
      setlocal noexpandtab
    else
      setlocal expandtab
    endif
  endfunction
  augroup Autotab
    autocmd!
    autocmd FileType * call s:autotab()
  augroup END
set tabstop=2
retab
set backspace=indent,eol,start
" }}}

" Sequencial keys {{{
set timeoutlen=500
" }}}

" Clipboard {{{
if exists('&clipboard')
  set clipboard=unnamed
  if has('unnamedplus')
    set clipboard+=unnamedplus
  endif
endif
" }}}

" IME {{{
set iminsert=0
set imsearch=-1
" }}}

" Increment {{{
set nrformats-=ocral
"}}}

" Generated files {{{
set swapfile
set nobackup
set viminfo='1000,:1000,n$CACHE/.viminfo
" }}}

" }}} EDIT

" UTILITY {{{
" --------------------------------------------------------------------------------------------------------
" On starting vim {{{
function! s:enter()
  if argc() == 0
    silent exec ':VimFiler -status -buffer-name=vimfiler -auto-cd'
  endif
endfunction
augroup Enter
  autocmd!
  " autocmd VimEnter * call s:enter()
  if s:iswin
    autocmd GUIEnter * simalt ~x
  endif
augroup END
" }}}

" Move to the directory for each buffer, current directory functions {{{
function! s:escape(directory)
  return escape(a:directory, '*[]()?! ')
endfunction
function! s:current_directory_raw()
  return substitute(expand('%:p:h'), '\*\(vinarise\|bitmapview\)\* - ', '', '')
endfunction
function! s:current_directory_escape()
  return s:escape(s:current_directory_raw())
endfunction
function! s:current_directory_auto()
  if &filetype ==# 'vimfiler' && exists('b:vimfiler')
    return s:escape(b:vimfiler.current_dir)
  else
    return s:current_directory_escape()
  endif
endfunction
function! s:substitute_path_slash(path)
  return substitute(a:path, '\\', '/', 'g')
endfunction
function! s:current_directory_abbr()
  let path = s:current_directory_auto()
  let rawpath = s:current_directory_escape()
  if s:iswin
    if &filetype !=# 'vimfiler'
      let path = s:substitute_path_slash(path)
    endif
    let rawpath = s:substitute_path_slash(rawpath)
  endif
  return substitute(substitute(substitute(path, escape(rawpath, '~'), '.', ''), '^./', '', ''), '^.$', '', '')
endfunction
function! s:change_directory()
  try
    if &filetype !=# 'vimfiler'
      execute ':lcd '.s:current_directory_auto()
    endif
  catch
  endtry
  return s:current_directory_abbr()
endfunction
augroup ChangeDirectory
  autocmd!
  autocmd BufEnter * call s:change_directory()
augroup END
" }}}

" Enable omni completation {{{
augroup Omnifunc
  autocmd!
  autocmd FileType c          setlocal omnifunc=ccomplete#Complete
  autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
  autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType haskell    setlocal omnifunc=necoghc#omnifunc
augroup END
setlocal omnifunc=syntaxcomplete#Complete
" }}}

" Make with S-F5 key (user omake) {{{
function! Automake()
  if filereadable('OMakefile') && executable('omake')
    execute '!omake'
  elseif filereadable('Makefile') || filereadable('makefile')
    execute '!make all'
  endif
endfunction
nnoremap <silent> <S-F5> :<C-u>call Automake()<CR>
" }}}

" GCJTemplate {{{
function! GCJ()
  call append( 0, 'main = interact $ format . map solve . parseInput')
  call append( 1, '')
  call append( 2, 'parseInput = tail . map (map read . words :: String -> [Int]) . lines')
  call append( 3, '')
  call append( 4, 'format :: (Show a) => [a] -> String')
  call append( 5, 'format = unlines . map f . zip [1..]')
  call append( 6, '  where s x | ((==''"'') . head . show) x = init $ tail $ show x')
  call append( 8, '            | otherwise                   = show x')
  call append( 9, '        f x = "Case #" ++ show (fst x) ++ ": " ++ s (snd x)')
  call append(10, '')
  call append(11, 'solve (x:_) =')
endfunction
nnoremap ,p :<C-u>call GCJ()<CR><S-g>
" }}}

" Vim script header {{{
function! Header()
  let filename = substitute(expand('%:p'), expand('~/Dropbox/.vim/bundle/').'[^/]\+/', '', '')
  if search(repeat('=', 77))
    call setline(search('" Filename:'), '" ' . 'Filename: ' . filename)
  else
    let [s, f] = [[], []]
    call add(s, '" ' . repeat('=', 77))
    call add(s, '" ' . 'Filename: ' . filename)
    call add(s, '" ' . 'Author: itchyny')
    call add(s, '" ' . 'License: MIT License')
    call add(s, '" ' . 'Last Change: .')
    call add(s, '" ' . repeat('=', 77))
    call add(s, '')
    if !search('save_cpo')
      call add(s, 'let s:save_cpo = &cpo')
      call add(s, 'set cpo&vim')
      call add(s, '')
      if getline(line('$')) != '' | call add(f, '') | endif
      call add(f, 'let &cpo = s:save_cpo')
      call add(f, 'unlet s:save_cpo')
    endif
    call append(0, s)
    call append(line('$'), f)
  endif
endfunction
command! Header call Header()
" }}}

" Open file explorer at current directory {{{
function! Explorer()
  silent call system((s:ismac ? 'open -a Finder' : s:iswin ? 'start' : 'nautilus') .'. &')
endfunction
nnoremap <silent> \n :call Explorer()<CR>
nnoremap <silent> ge :call Explorer()<CR>
" }}}

" Quickly open with outer text editor {{{
function! TextEdit()
  silent call system((s:ismac ? 'open -a TextEdit ' : s:iswin ? 'notepad ' : 'gedit ') . s:escape(expand('%:p')) . ' &')
endfunction
nnoremap <silent> \g :call TextEdit()<CR>
" }}}

" view syntax name under cursor {{{
function! Syntax()
  :echo synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction
command! Syntax call Syntax()
command! S call Syntax()
" }}}

" Quick open dot files {{{
if filereadable(expand('~/Dropbox/dotfiles/.vimrc'))
  nnoremap \. :e ~/Dropbox/dotfiles/.vimrc<CR>
elseif filereadable(expand('~/.vimrc'))
  nnoremap \. :e ~/.vimrc<CR>
endif
if filereadable(expand('~/Dropbox/dotfiles/.zshrc'))
  nnoremap ;. :e ~/Dropbox/dotfiles/.zshrc<CR>
elseif filereadable(expand('~/.zshrc'))
  nnoremap ;. :e ~/.zshrc<CR>
endif
" }}}

" template for blog {{{
nnoremap ,cpp i>\|cpp\|<CR>\|\|<<ESC>
nnoremap ,sh i>\|sh\|<CR>\|\|<<ESC>
nnoremap ,hs i>\|haskell\|<CR>\|\|<<ESC>
nnoremap ,js i>\|javascript\|<CR>\|\|<<ESC>
" }}}

" }}} UTILITY

" OTHERS {{{
" --------------------------------------------------------------------------------------------------------
" Performance {{{
set ttyfast
set updatetime=300
set vb t_vb=
" }}}

" Command line {{{
set wildmode=list:longest
set wildignore+=*.sw?,*.bak,*.?~,*.??~,*.???~,*.~
let s:cmdlist = 'vps;vsp,vp;vsp,nbi;NeoBundleInstall,nbc;NeoBundleClean,nbd;NeoBundleDocs,di;Dictionary<SPACE>-cursor-word,tvs;TweetVimSay,tvus;TweetVimUserStream,qa1;qa!,q1;q!,nvew;vnew'
for [s:cmd, s:exp] in map(split(s:cmdlist, ','), 'split(v:val, ";")')
  exec 'cabbrev <expr> '.s:cmd.' (getcmdtype() == ":" && getcmdline() ==# "'.s:cmd.'") ? "'.s:exp.'" : "'.s:cmd.'"'
endfor
" }}}

" }}} OTHERS

" KEY MAPPING {{{
" --------------------------------------------------------------------------------------------------------

" edit {{{
" Increment and decrement
nnoremap + <C-a>
nnoremap - <C-x>

" fold by indentation
nnoremap [ zak
nnoremap ] <S>j

" indentation in visual mode
vnoremap < <gv
vnoremap > >gv|

" swap line/normal visual mode
noremap <S-v> v
noremap v <S-v>

" yank to the end of line
nnoremap Y y$

" remove spaces at the end of lines
nnoremap ,<Space> ma:%s/  *$//<CR>`a<ESC>

" selecting all
nnoremap <C-a> gg<S-v><S-g>
inoremap <C-a> <ESC>gg<S-v><S-g>
vnoremap <C-a> <ESC>gg<S-v><S-g>

" smart Enter
inoremap <silent> <expr> <CR> (pumvisible()?"\<ESC>o":"\<C-g>u\<CR>")

" split by 80 characters
nnoremap <silent> ,80 :s/\(.\{80}\)/\1<c-v><Enter>/g<Enter><ESC>:<C-u>set nohlsearch<CR>
vnoremap <silent> ,80 :s/\(.\{80}\)/\1<c-v><Enter>/g<Enter><ESC>:<C-u>set nohlsearch<CR>

" diff
nnoremap ,d :<C-u>diffthis<CR>

" undo filetype
nnoremap <silent> <expr> u (line('$')==1&&getline(1)=='' ? ":setl filetype=\<CR>" : "u")
" }}}

" file {{{
" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
" }}}

" search {{{
nnoremap <silent> <Esc><Esc> :<C-u>set nohlsearch<CR>:<C-u>set nopaste<CR>
nnoremap <silent> / :<C-u>set hlsearch<CR>/
nnoremap <silent> ? :<C-u>set hlsearch<CR>?
" nnoremap <silent> * :<C-u>set hlsearch<CR>*
nnoremap <silent> # :<C-u>set hlsearch<CR>#
nnoremap <silent> ,n :<C-u>cn<CR>
nnoremap <silent> ,p :<C-u>cp<CR>
" }}}

" Navigation {{{
" window
" <C-j> doesn't work, without the setting of <C-m>
inoremap <C-h> <ESC><C-w>h
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k
inoremap <C-l> <ESC><C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]') ? "<CR>" : "<C-w>j"
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-x> <C-w>x
vnoremap <C-h> <C-w>h
vnoremap <C-j> <C-w>j
vnoremap <C-m> <C-w>j
vnoremap <C-k> <C-w>k
vnoremap <C-l> <C-w>l
vnoremap <C-x> <C-w>x
inoremap <C-q> <ESC><C-w>
nnoremap <C-q> <C-w>
vnoremap <C-q> <ESC><C-w>

" close buffer
let s:winwid = winwidth(0)
function! AutoClose()
  try
    if &filetype == 'quickrun'
      silent bd!
    elseif &filetype == 'gundo'
      silent call feedkeys('q')
    elseif expand('%:t') == '__XtermColorTable__'
      silent bd!
    elseif winwidth(0) < 2 * s:winwid / 3
      silent q
    elseif &filetype == '' && !&modified
      silent q!
    elseif &modified
    elseif &filetype == 'vimshell'
      silent q
    else
      silent bd!
    endif
  catch
  endtry
endfunction
inoremap <silent> <C-w> <ESC>:<C-u>call AutoClose()<CR>
nnoremap <silent> <C-w> :<C-u>call AutoClose()<CR>
vnoremap <silent> <C-w> :<C-u>call AutoClose()<CR>

" tag
augroup HelpTag
  autocmd!
  autocmd FileType help nnoremap <C-[> <C-t>
augroup END

" tab
nnoremap <C-t> :<C-u>tabnew<CR>
inoremap <C-t> <ESC>:<C-u>tabnew<CR>
inoremap <C-Left> <ESC>gT
inoremap <C-Right> <ESC>gt
nnoremap <C-Left> gT
nnoremap <C-Right> gt
vnoremap <C-Left> gT
vnoremap <C-Right> gt

" select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" quit help with escape key
autocmd ESC FileType help,qf nnoremap <silent> <buffer> <expr> <ESC><ESC>
      \ &modifiable ? ":\<C-u>set nohlsearch\<CR>" : ":\<C-u>q\<CR>"

" disable EX-mode
map <S-q> <Nop>

" move within insert mode
imap <expr><C-o> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
inoremap <expr> <C-p> <SID>cancel_popup("\<Up>")
inoremap <expr> <C-n> <SID>cancel_popup("\<Down>")
inoremap <expr> <C-b> <SID>cancel_popup("\<Left>")
inoremap <expr> <C-f> <SID>cancel_popup("\<Right>")
inoremap <expr> <C-e> <SID>cancel_popup("\<End>")
inoremap <expr> <C-a> <SID>cancel_popup("\<Home>")
inoremap <expr> <C-d> <SID>cancel_popup("\<Del>")
inoremap <expr> <C-h> <SID>cancel_popup("\<BS>")
inoremap <expr> <C-u> <SID>cancel_popup_reverse("\<C-u>")
inoremap <expr> <Up> <SID>cancel_popup("\<Up>")
inoremap <expr> <Down> <SID>cancel_popup("\<Down>")
inoremap <expr> <Left> <SID>cancel_popup("\<Left>")
inoremap <expr> <Right> <SID>cancel_popup("\<Right>")
nnoremap <expr> OA <SID>goback_insert("\<Up>")
nnoremap <expr> OB <SID>goback_insert("\<Down>")
nnoremap <expr> OC <SID>goback_insert("\<Right>")
nnoremap <expr> OD <SID>goback_insert("\<Left>")
nnoremap <expr> OF <SID>goback_insert("\<End>")
nnoremap <expr> OH <SID>goback_insert("\<Home>")
nnoremap <expr> [3~ <SID>goback_insert("\<Del>")
nnoremap <expr> [5~ <SID>goback_insert("\<PageUp>")
nnoremap <expr> [6~ <SID>goback_insert("\<PageDown>")

" navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>
" }}}

" }}} KEY MAPPING

" {{{ VIMRC LOADED
let g:loaded_vimrc = 1
" }}} VIMRC LOADED

" REFERENCE TO KEY MAPPING {{{
" --------------------------------------------------------------------------------------------------------
" normal mode
" +=========+=====================+==========+==================+===================+=================+
" | Leader  |         \           |    ;     |        ,         |      <S-          |     <C-         |
" |         | Outer world of Vim  | vimshell |     utility      |                   |                 |
" +=========+=====================+==========+==================+===================+=================+
" |    a    |                     |          | Calc             |    default        | gg<S-v><S-g>    |
" |    b    | OpenBrowser         |          |                  | NeoBundleInstall! |  default        |
" |    c    |                     |          | Calendar         |    default        |                 |
" |    d    |                     |          |                  |    default        |                 |
" |    e    | QuickRun <i         |          |                  |                   |                 |
" +---------+---------------------+----------+------------------+-------------------+-----------------+
" |    f    | VimFiler            |          |                  |                   |  default        |
" |    g    | gedit / Textedit    | Ghci     | GundoToggle      |    default        |                 |
" |    h    |                     |          | Unite ref/hoogle |   VimshellPop     | <C-w>h          |
" |    i    |                     |          |                  |    default        |                 |
" |    j    |                     |          |                  |    default        | <C-w>j          |
" +---------+---------------------+----------+------------------+-------------------+-----------------+
" |    k    |                     |          |                  |                   | <C-w>k          |
" |    l    |                     |          |                  |                   | <C-w>l          |
" |    m    |                     |          |                  |                   |                 |
" |    n    | nautilus / Finder   |          |                  |                   | Unite file/new  |
" |    o    | QuickRun <i >output |          |                  |    default        | Unite file      |
" +---------+---------------------+----------+------------------+-------------------+-----------------+
" |    p    |                     | Python   |                  |                   | CtrlP           |
" |    q    |                     |          |                  |                   | <C-w>(default)  |
" |    r    | QuickRun            |          |                  |    default        |  default        |
" |    s    | OpenBrowser         | VimShell |                  |                   | :w<CR>          |
" |    t    |                     |          |                  |                   | tabnew          |
" +---------+---------------------+----------+------------------+-------------------+-----------------+
" |    u    |                     |          |                  |                   | Unite           |
" |    v    |                     |          |                  |    default        |  default        |
" |    w    |                     |          |                  |                   | :q<CR> :bd<CR>  |
" |    x    |                     |          |                  |                   |                 |
" |    y    |                     |          |                  |    y$             |                 |
" +---------+---------------------+----------+------------------+-------------------+-----------------+
" |    z    |                     | zsh      |                  |                   | Unite file_mru  |
" |    .    | .vimrc              | .zshrc   |                  |                   |                 |
" +=========+=====================+==========+==================+===================+=================+
" }}} REFERENCE TO KEY MAPPING

" vim:foldmethod=marker
