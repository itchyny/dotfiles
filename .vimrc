" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2013/06/13 01:34:41.
" --------------------------------------------------------------------------------------------------------

" INITIALIZE {{{
" --------------------------------------------------------------------------------------------------------
set nocompatible
filetype off
scriptencoding utf-8
let s:isunix = has('unix')
let s:iswin = has('win16') || has('win32') || has('win64')
let s:iscygwin = has('win32unix')
let s:ismac = !s:iswin && !s:iscygwin &&
      \ (has('mac') || has('macunix') || has('guimacvim') || system('uname') =~? '^darwin')
let s:nosudo = $SUDO_USER == ''
augroup ESC
  autocmd!
augroup END
augroup SetLocal
  autocmd!
augroup END
function! s:safeexecute(s, ...)
  if a:0
    let check = a:1
  else
    let check = a:s
  endif
  if exists(check)
    try
      silent execute a:s
    catch
      try
        silent execute 'call '.a:s
      catch
      endtry
    endtry
  endif
endfunction
" }}}

" Bundles {{{
let $VIM = $HOME.'/.vim'
let $BUNDLE = $VIM.'/bundle'
let s:neobundle_dir = $BUNDLE.'/neobundle.vim'
if !isdirectory(s:neobundle_dir)

" neobundle {{{
" --------------------------------------------------------------------------------------------------------
  if executable('git')
    echo 'Initializing neobundle'
    execute '!mkdir -p '.$BUNDLE
       \.' && git clone git@github.com:Shougo/neobundle.vim.git '.$BUNDLE.'/neobundle.vim'
       \.' && git clone git@github.com:Shougo/unite.vim.git '.$BUNDLE.'/unite.vim'
       \.' && git clone git@github.com:Shougo/neocomplcache.git '.$BUNDLE.'/neocomplcache'
       \.' && git clone git@github.com:Shougo/vimproc.git '.$BUNDLE.'/vimproc'
       \.' && git clone git@github.com:Shougo/vimfiler.git '.$BUNDLE.'/vimfiler'
       \.' && git clone git@github.com:thinca/vim-quickrun.git '.$BUNDLE.'/vim-quickrun'
       \.' && git clone git@github.com:Shougo/vimshell.git '.$BUNDLE.'/vimshell'
    if s:ismac
      if executable('llvm-gcc')
        execute '!cd '.$BUNDLE.'/vimproc && make -f make_mac.mak'
      elseif executable('gcc')
        execute '!cd '.$BUNDLE.'/vimproc && '
              \.'gcc -O2 -W -Wall -Wno-unused -bundle -fPIC -arch x86_64 -arch '
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
execute 'set runtimepath+='.expand(s:neobundle_dir)
call neobundle#rc(expand($BUNDLE))
NeoBundleFetch 'Shougo/neobundle.vim'
  " nnoremap <silent> <S-b><S-b> :<C-u>NeoBundleUpdate<CR>
  nnoremap <silent> <S-b><S-b> :<C-u>Unite neobundle/update<CR>
" }}}

" Powerline {{{
" --------------------------------------------------------------------------------------------------------
NeoBundle 'Lokaltog/vim-powerline', {'type': 'nosync'}
" NeoBundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
try
" --|  $ sudo apt-get install fontforge
" --|  $ sudo apt-get install python-fontforge
" --|  $ cd ~/.vim/bundle/vim-powerline/fontpatcher
" --|  $ wget http://levien.com/type/myfonts/Inconsolata.otf
" --|  $ python ./fontpatcher ./Inconsolata.otf
" --|  $ sudo cp ./Inconsolata-Powerline.otf /usr/share/fonts
set guifont=Inconsolata\ for\ Powerline:h15
if s:iswin
  set guifontwide=MS_Gothic:h11:cSHIFTJIS
endif
if has('multi_byte')
  let g:Powerline_symbols = 'fancy'
endif
let g:Powerline_mode_n = 'NORMAL'
catch
endtry
" }}}

" Colorscheme {{{
" --------------------------------------------------------------------------------------------------------
try
NeoBundle 'itchyny/landscape.vim', {'type': 'nosync'}
  colorscheme landscape
  let g:landscape_highlight_url = 1
  let g:landscape_highlight_todo = 1
  let g:landscape_highlight_full_space = 1
  let g:landscape_highlight_url_filetype = {'thumbnail': 0}
  let g:Powerline_theme = 'landscape'
  let g:Powerline_colorscheme = 'landscape'
catch
  colorscheme wombat
endtry
NeoBundle 'xterm-color-table.vim'
  " http://www.vim.org/scripts/script.php?script_id=3412
" }}}

" Complement {{{
" --------------------------------------------------------------------------------------------------------
if s:nosudo
NeoBundle 'Shougo/neocomplcache'
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
NeoBundle 'Shougo/neosnippet'
  let g:neosnippet#snippets_directory = expand($VIM.'/snippets')
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: "\<TAB>"
NeoBundle 'ujihisa/neco-look'
  " --| Requirement: look commnad
endif
" }}}

" Unite ( "," ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ","
if s:nosudo
NeoBundle 'Shougo/unite.vim', {'type': 'nosync'}
  let g:unite_enable_start_insert = 1
  let g:unite_cursor_line_highlight = 'CursorLine'
  let g:unite_source_file_mru_limit = 1000
  let g:unite_force_overwrite_statusline = 0
  if s:ismac && has('multi_byte')
    let g:unite_marked_icon = '✓'
  else
    let g:unite_marked_icon = 'v'
  endif
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
    autocmd FileType unite imap <buffer> OB <Plug>(unite_select_next_line)
  augroup END
  autocmd ESC FileType unite nmap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
  let s:startfiletypes = '.*\.\(exe\|png\|gif\|jpg\|jpeg\|bmp\|eps\|pdf\|mp3\|mp4\|avi\|mkv\)$'
  call unite#custom_source('file', 'ignore_pattern'
        \, '.*\.\(o\|exe\|dll\|bak\|sw[po]\|hi\|fff\|aux\|toc\|bbl\|blg\|DS_Store\)$')
  let auto_open = {
        \ 'description' : 'edit or open files',
        \ 'is_selectable' : 1,
        \ }
  function! auto_open.func(candidates)
    try
      for candidate in a:candidates
        if candidate.word =~? s:startfiletypes
          call unite#take_action('start', candidate)
        else
          call unite#take_action('open', candidate)
        endif
      endfor
    catch
    endtry
  endfunction
  call unite#custom_action('file', 'auto_open', auto_open)
  call unite#custom_default_action('file', 'auto_open')
  unlet auto_open
NeoBundle 'Shougo/unite-build'
  nnoremap <silent><F5> :<C-u>Unite build -buffer-name=build<CR>
NeoBundle 'unite-colorscheme'
NeoBundle 'ujihisa/vim-ref'
if executable('hoogle')
NeoBundle 'eagletmt/unite-haddock'
  call unite#custom_source('haddock,hoogle', 'max_candidates', 20)
  nnoremap <Leader>h :<C-u>Unite hoogle -buffer-name=hoogle<CR>
  " --| Requirement: hoogle
  " --|   $ cabal install hoogle
  " --|   $ hoogle data
endif
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'ujihisa/unite-haskellimport'
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
  let g:quickrun_config = {'_': {'runner': 'vimproc', 'runner/vimproc/updatetime' : 60, 'split': 'vertical', 'into': 1}}
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
  nnoremap <Leader>r :<C-u>QuickRun  <CR>
  nnoremap <Leader><Leader>r :<C-u>QuickRun >file:temp.dat<CR>
  nnoremap <Leader>e :<C-u>QuickRun <i <CR>
  nnoremap <Leader>o :<C-u>QuickRun <i >file:output<CR>
  autocmd ESC FileType quickrun inoremap <silent> <buffer> <ESC><ESC><ESC> <ESC>:q<CR>
  autocmd ESC FileType quickrun nnoremap <silent> <buffer> <ESC><ESC><ESC> <ESC>:q<CR>
  autocmd ESC FileType quickrun vnoremap <silent> <buffer> <ESC><ESC><ESC> <ESC>:q<CR>
if s:nosudo
NeoBundle 'Shougo/vimfiler'
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_sort_type = 'TIME'
  let g:vimfiler_safe_mode_by_default = 0
  let g:vimfiler_force_overwrite_statusline = 0
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
  " nnoremap <silent> s :<C-u>execute 'VimShellCreate '.<SID>current_directory_auto()<CR>
  nnoremap <silent> s :<C-u>VimShellBufferDir<CR>
  let g:vimfiler_execute_file_list = {}
  for ft in split('pdf,png,jpg,jpeg,gif,bmp,ico,ppt,html', ',')
    let g:vimfiler_execute_file_list[ft] = 'open'
  endfor
  let s:usestatl = system('stat -l . > /dev/null 2>&1; echo $?') =~ '^0'
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
    if s:usestatl
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
    autocmd FileType vimfiler nmap <buffer> <C-l> <ESC><C-q>l
    autocmd FileType vimfiler nmap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
    autocmd FileType vimfiler nmap <buffer> O <Plug>(vimfiler_sync_with_another_vimfiler)
    autocmd FileType vimfiler nmap <buffer><expr> e
          \ vimfiler#smart_cursor_map("\<Plug>(vimfiler_cd_file)", "\<Plug>(vimfiler_edit_file)")
    autocmd FileType vimfiler nmap <buffer><expr> t <SID>changetime()
  augroup END
NeoBundle 'itchyny/vimfiler-preview', {'type': 'nosync'}
  let g:vimfiler_preview_action = 'auto_preview'
NeoBundle 'Shougo/vinarise'
endif
NeoBundle 'eagletmt/ghci-vim'
  augroup Ghci
    autocmd!
    autocmd FileType haskell nnoremap <buffer> <Leader>l <expr> call s:safeexecute(':GhciLoad')
    autocmd FileType haskell nnoremap <buffer> <Leader>i <expr> call s:safeexecute(':GhciInfo')
    autocmd FileType haskell nnoremap <buffer> <Leader>t <expr> call s:safeexecute(':GhciType')
  augroup END
NeoBundle 'tyru/open-browser.vim'
  nmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
  vmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
  nmap <silent> <Leader>s <Plug>(openbrowser-search)
NeoBundle 'mattn/webapi-vim'
" }}}

" vimshell ( ";" ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ";"
if s:nosudo
NeoBundle 'Shougo/vimshell'
" --| Requirement: vimproc
" --| If you can't use sudo, do:
" --|  $ sudo chmod 4755 /usr/bin/sudo
  let g:vimshell_interactive_update_time = 150
  let g:vimshell_popup_command = 'split'
  let g:vimshell_split_command = 'vsplit'
  " let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
  let g:vimshell_prompt = ' $ '
  let g:vimshell_disable_escape_highlight = 1
  let g:vimshell_scrollback_limit = 5000
  let g:vimshell_disable_escape_highlight = 1
  let g:vimshell_force_overwrite_statusline = 0
  augroup Vimshell
    autocmd!
    " for easy window moving, unmap C-[hjkl]
    autocmd FileType vimshell iunmap <buffer> <C-h>
    autocmd FileType vimshell iunmap <buffer> <C-k>
    autocmd FileType vimshell iunmap <buffer> <C-l>
    autocmd FileType vimshell iunmap <buffer> <C-w>
    autocmd FileType vimshell nunmap <buffer> <C-k>
    autocmd FileType vimshell nunmap <buffer> <C-l>
    autocmd FileType vimshell nmap <buffer> <C-a> <Nop>
    autocmd FileType vimshell nmap <buffer> <C-m> <ESC><C-q>j
    autocmd FileType vimshell inoremap <buffer> <C-h> <ESC><C-w>h
    autocmd FileType vimshell inoremap <buffer> <C-j> <ESC><C-w>j
    autocmd FileType vimshell inoremap <buffer> <C-k> <ESC><C-w>k
    autocmd FileType vimshell inoremap <buffer> <C-l> <ESC><C-w>l
    autocmd FileType vimshell inoremap <silent><buffer> ^
          \ <ESC>:call vimshell#execute('cd ../')<CR>
          \:call vimshell#print_prompt()<CR>
          \:call vimshell#start_insert()<CR>
    " disable unexpected deleting
    autocmd FileType vimshell nnoremap <buffer> dj <Nop>
    autocmd FileType vimshell nnoremap <buffer> dk <Nop>
    autocmd FileType vimshell nnoremap <buffer> dg <Nop>
    autocmd FileType vimshell vnoremap <buffer> dj <Nop>
    autocmd FileType vimshell vnoremap <buffer> dk <Nop>
    autocmd FileType vimshell vnoremap <buffer> dg <Nop>
    autocmd FileType vimshell vnoremap <buffer> c <Nop>
    autocmd FileType vimshell vnoremap <buffer> <delete> <Nop>
    autocmd FileType vimshell vnoremap <buffer> a <ESC><ESC>GA
    autocmd FileType vimshell vnoremap <buffer> y yGA
    autocmd FileType vimshell imap <buffer> <C-^> <ESC><C-^>
    " <Up><Down>の設定では効かないので, エスケープ文字で設定してます.
    let s:start_complete = " unite#sources#vimshell_history#start_complete(!0)"
    for s:key in ['<UP>', '<Down>', 'OA', 'OB']
      execute "autocmd FileType vimshell inoremap <buffer> <expr><silent> ".s:key.s:start_complete
      execute "autocmd FileType vimshell nnoremap <buffer> <expr><silent> ".s:key.s:start_complete
    endfor
  augroup END
  nnoremap <silent> <Leader><Leader>s :<C-u>VimShell -split<CR>
  " nnoremap <silent> <Leader>s :<C-u>execute 'VimShellCreate '.<SID>current_directory_auto()<CR>
  " nnoremap <silent> <S-h> :<C-u>execute 'VimShell -popup '.<SID>current_directory_auto()<CR>
  nnoremap <silent> <Leader>s :<C-u>VimShellBufferDir<CR>
  nnoremap <silent> <S-h> :<C-u>VimShellBufferDir -popup<CR>
  nnoremap <Leader>z :<C-u>VimShellInteractive zsh<CR>
  " nnoremap <Leader>g :<C-u>VimShellInteractive ghci<CR>
  nnoremap <Leader>p :<C-u>VimShellInteractive python<CR>
if executable('ghc-mod')
  " neocomplcache (neco-ghc) throws fatal error when ghc-mod is not found
NeoBundle 'ujihisa/neco-ghc'
  let g:necoghc_enable_detailed_browse = 1
NeoBundle 'eagletmt/ghcmod-vim'
  nnoremap <Leader>g :<C-u>GhcModCheckAsync<CR>
  " --| Requirement: ghc-mod
  " --|  $ cabal install ghc-mod
endif
endif
" }}}

" Commenter / Utility / Matching ( "," ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ","
NeoBundle 'tpope/vim-surround'
  let g:surround_{char2nr('$')} = "$\r$" " for LaTeX
NeoBundle 't9md/vim-surround_custom_mapping'
NeoBundle 'tComment'
  augroup tComment
    autocmd!
    autocmd FileType gnuplot call tcomment#DefineType('gnuplot', '# %s')
    autocmd FileType haxe call tcomment#DefineType('haxe', '// %s')
    autocmd FileType meissa call tcomment#DefineType('meissa', '# %s')
  augroup END
  nnoremap <silent> __ :TComment<CR>
  vnoremap <silent> __ :TComment<CR>
NeoBundle 'Align'
NeoBundle 'errormarker.vim'
NeoBundle 'mattn/calendar-vim'
  autocmd ESC FileType calendar nnoremap <silent> <buffer> <ESC><ESC> :<C-u>q<CR>
  nnoremap <Leader>c :<C-u>Calendar<CR>
NeoBundle 'autodate.vim'
  let g:autodate_format = '%Y/%m/%d %H:%M:%S'
if has('python')
NeoBundle 'sjl/gundo.vim'
  " --| Requirement: +python
  nnoremap <Leader>g :<C-u>GundoToggle<CR>
  autocmd ESC FileType gundo nnoremap <silent> <buffer> <ESC><ESC> :<C-u>GundoToggle<CR>
NeoBundle 'VimCalc', {'type': 'nosync'}
  " --| Requirement: +python
  autocmd ESC FileType vimcalc nnoremap <silent> <buffer> <ESC><ESC><ESC> :<C-u>q<CR>
  nnoremap <silent> <Leader>a :<C-u>Calc<CR>
endif
NeoBundle 'kana/vim-fakeclip'
NeoBundle 'gregsexton/MatchTag'
NeoBundle 'matchit.zip'
NeoBundle 'thinca/vim-scouter'
NeoBundle 'thinca/vim-ambicmd'
  cnoremap <expr><SPACE> ambicmd#expand("\<SPACE>")
NeoBundle 'motemen/git-vim'
NeoBundle 'terryma/vim-multiple-cursors'
  let g:multi_cursor_use_default_mapping = 0
  let g:multi_cursor_next_key = "\<C-g>"
  let g:multi_cursor_prev_key = "\<C-y>"
  let g:multi_cursor_skip_key = "\<C-x>"
  let g:multi_cursor_exit_key = "\<Esc>"
  let g:multi_cursor_quit_key = "\<Esc>"
if exists('##InsertCharPre')
  NeoBundle 'mattn/multi-vim'
  nnoremap <Leader>m :<C-u>Multi<SPACE>
endif
NeoBundle 'itchyny/thumbnail.vim', {'type': 'nosync'}
  nnoremap <silent> <Leader>t :<C-u>Thumbnail -here<CR>
  augroup ThumbnailKey
    autocmd!
    autocmd FileType thumbnail nmap <buffer> v <Plug>(thumbnail_start_line_visual)
    autocmd FileType thumbnail nmap <buffer> V <Plug>(thumbnail_start_visual)
    autocmd FileType thumbnail call clearmatches()
  augroup END
NeoBundle 'vim-jp/vital.vim'
" }}}

" Syntax {{{
" --------------------------------------------------------------------------------------------------------
if has('multi_byte')
NeoBundle 'scrooloose/syntastic'
  let g:syntastic_mode_map = { 'mode': 'passive',
                             \ 'active_filetypes': ['c', 'cpp'] }
  let g:syntastic_echo_current_error = 0
  let g:syntastic_enable_highlighting = 0
endif
" NeoBundle 'mattn/zencoding-vim'
"   let g:user_zen_expandabbr_key = '<c-e>'
"   let g:user_zen_settings = { 'html' : { 'indentation' : '  ' }, }
NeoBundle 'itspriddle/vim-javascript-indent'
NeoBundle 'JSON.vim'
NeoBundle 'html5.vim'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'groenewege/vim-less'
NeoBundle 'less.vim'
NeoBundle 'syntaxm4.vim'
NeoBundle 'vim-scripts/jade.vim'
NeoBundle 'vim-coffee-script'
NeoBundle 'rest.vim'
NeoBundle 'vim-scripts/indenthaskell.vim'
  let hs_highlight_boolean = 1
  let hs_highlight_types = 1
  let hs_highlight_more_types = 1
NeoBundle 'tpope/vim-markdown'
NeoBundle 'haxe.vim'
NeoBundle 'motemen/hatena-vim'
  let g:hatena_upload_on_write = 0
  let g:hatena_user = 'itchyny'
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
    call system("xattr -w com.apple.TextEncoding 'utf-8;134217984' \"".a:file."\"")
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
  " 定数を処分
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
  set listchars=tab:▸\ ,extends:»,precedes:«,nbsp:%
endif
set shortmess+=I            " disable start up message
set number
  autocmd SetLocal FileType vimshell,vimcalc,quickrun,int-ghci setlocal nonumber
set cursorline
  autocmd SetLocal FileType calendar,vimcalc,vimshell,quickrun,int-ghci setlocal nocursorline
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
set history=300
set helplang=en
language C
set nospell
  function! s:autospell()
    let spellbads = [ '^\(\S\+ \+\)\{30,}\S\+[,.]\?$', '\<a\> [aiueo]', '^\$', '\<figure..\?\\', '\\ref{eq:'
          \ , '^\\end{align}', '[^\~]\\\(eq\)\?ref', 'does not [a-z]*s ', 's [a-z][a-z]\+s ' ]
    if !exists('b:autospell_done')
      if search("[^\x01-\x7e]", 'n') == 0 && line('$') > 5
        setlocal spell
        for s in spellbads
          call matchadd('SpellBad', s)
        endfor
      else
        setlocal nospell
      endif
      let b:autospell_done = 1
    endif
  endfunction
  augroup autospell
    autocmd!
    autocmd FileType tex,markdown call s:autospell()
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
if !exists('g:Powerline_loaded')
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
endif
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
  let s:filetypes1 = map(split('bf,gnuplot,jade,json,less,r,roy,tex,meissa', ','), '[v:val, v:val]')
  let s:filetypes2 = map(split('cls;tex,hs;haskell,hx;haxe,md;markdown,cir;spice', ','), 'split(v:val, ";")')
  autocmd!
  for [ex, ft] in extend(s:filetypes1, s:filetypes2)
    execute 'autocmd BufNewFile,BufReadPost *.' . ex . ' setlocal filetype=' . ft
  endfor
  autocmd BufNewFile,BufReadPost * execute "setlocal filetype=".&filetype
augroup END
" }}}

" }}} FILE READING

" EDIT {{{
" --------------------------------------------------------------------------------------------------------
" Search {{{
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
      set noexpandtab
    else
      set expandtab
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
set clipboard=autoselect,unnamed,unnamedplus
" }}}

" IME {{{
set iminsert=0
set imsearch=-1
" }}}

" Increment {{{
set nrformats-=ocral
"}}}

" Windows specific {{{
if s:iswin
  set noswapfile
endif
" }}}

" Gui specific {{{
map <LeftMouse> <Nop>
map <RightMouse> <Nop>
map <LeftRelease> <Nop>
" }}}

" }}} EDIT

" UTILITY {{{
" --------------------------------------------------------------------------------------------------------
" On starting vim {{{
function! s:enter()
  silent call s:safeexecute('Pl#UpdateStatusline(1)', 'g:Powerline_colorscheme')
  if argc() == 0
    silent call s:safeexecute(':VimFiler -status -buffer-name=vimfiler -auto-cd', ':VimFiler')
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
function! s:directory_escape(directory)
  return escape(a:directory, '*[]? ')
endfunction
function! s:current_directory_raw()
  return substitute(expand('%:p:h'), '\*\(vinarise\|bitmapview\)\* - ', '', '')
endfunction
function! s:current_directory_escape()
  return s:directory_escape(s:current_directory_raw())
endfunction
function! s:current_directory_auto()
  if &filetype ==# 'vimfiler' && exists('b:vimfiler')
    return s:directory_escape(b:vimfiler.current_dir)
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

" AOJ template {{{
function! AOJtemplate()
  call append( 0, '#include <cstdio>')
  call append( 1, '#include <iostream>')
  call append( 2, '#include <cmath>')
  call append( 3, '#include <stack>')
  call append( 4, '#include <vector>')
  call append( 5, '#include <algorithm>')
  call append( 6, '#include <string>')
  call append( 8, 'typedef long long ll;')
  call append( 9, 'using namespace std;')
  call append(10, '')
  call append(11, 'int main () {')
  call append(12, '  int i = 0, j = 0, k = 0, l = 0, m = 0, n = 0;')
  call append(13, '}')
endfunction
nnoremap ,,, :set ft=c<CR>:call AOJtemplate()<CR>zRjjjjjo
"}}}

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

" Open file explorer at current directory {{{
function! Explorer()
  if s:ismac
    execute '! open -a Finder .'
  elseif s:iswin
    silent execute '! start .'
  else
    execute '! nautilus .'
  endif
endfunction
nnoremap \n :call Explorer()<CR>
nnoremap ge :call Explorer()<CR>
" }}}

" Quickly open with outer text editor {{{
function! TextEdit()
  if s:ismac
    execute '! open -a TextEdit %'
  elseif s:iswin
    silent execute '! notepad %'
  else
    execute '! gedit %'
  endif
endfunction
nnoremap \g :call TextEdit()<CR>
" }}}

" view syntax name under cursor {{{
function! Syntax()
  :echo synIDattr(synID(line('.'), col('.'), 0), 'name')
endfunction
command! Syntax call Syntax()
command! S call Syntax()
nnoremap ss :Syntax<CR>
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

" remove Icon\r file {{{
if s:ismac
  silent call system('echo -e "Icon\\r" | xargs cat && echo -e "Icon\\r" | xargs rm')
endif
" }}}
" }}} UTILITY

" OTHERS {{{
" --------------------------------------------------------------------------------------------------------
" Performance {{{
set ttyfast
set updatetime=300
" }}}

" Command line {{{
set wildmode=list:longest
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

" forward delete
imap <C-x> <Del>

" diff
nnoremap ,d :<C-u>diffthis<CR>

" }}}

" file {{{
" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
" }}}

" search {{{
nnoremap <silent> <Esc><Esc> :<C-u>set nohlsearch<CR>
nnoremap <silent> / :<C-u>set hlsearch<CR>/
nnoremap <silent> ? :<C-u>set hlsearch<CR>?
nnoremap <silent> * :<C-u>set hlsearch<CR>*
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
      silent q!
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

" quit help with escapae key
autocmd ESC FileType help,qf nnoremap <silent> <buffer> <ESC><ESC> :<C-u>q<CR>

" disable EX-mode
map <S-q> <Nop>

" move within insert mode
imap <expr><C-o> neosnippet#expandable_or_jumpable() ? "<TAB>" : "<ESC>o"
function! s:cancel_popup(key)
  return a:key . neocomplcache#cancel_popup() 
endfunction
inoremap <expr> <C-p> <SID>cancel_popup("\<Up>")
inoremap <expr> <C-n> <SID>cancel_popup("\<Down>")
inoremap <expr> <C-b> <SID>cancel_popup("\<Left>")
inoremap <expr> <C-f> <SID>cancel_popup("\<Right>")
inoremap <expr> <C-e> <SID>cancel_popup("\<End>")
inoremap <expr> <C-a> <SID>cancel_popup("\<Home>")
inoremap <expr> <C-d> <SID>cancel_popup("\<Del>")
inoremap <expr> <C-h> <SID>cancel_popup("\<BS>")
inoremap <C-_> <ESC>ugi
function! s:goback_insert(key)
  return "gi" . a:key . neocomplcache#cancel_popup() 
endfunction
nnoremap <expr> OA <SID>goback_insert("\<Up>")
nnoremap <expr> OB <SID>goback_insert("\<Down>")
nnoremap <expr> OC <SID>goback_insert("\<Right>")
nnoremap <expr> OD <SID>goback_insert("\<Left>")
nnoremap <expr> OF <SID>goback_insert("\<End>")
nnoremap <expr> OH <SID>goback_insert("\<Home>")
nnoremap <expr> [3~ <SID>goback_insert("\<Del>")
nnoremap <expr> [5~ <SID>goback_insert("\<PageUp>")
nnoremap <expr> [6~ <SID>goback_insert("\<PageDown>")
" }}}

" }}} KEY MAPPING

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
" |    e    | QuickRun <i         |          |                  |                   | zencoding       |
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
" |    p    |                     | Python   |                  |                   | Unite buffer    |
" |    q    |                     |          |                  |                   | <C-w>(default)  |
" |    r    | QuickRun            |          |                  |    default        |  default        |
" |    s    | OpenBrowser         | VimShell |                  |                   | :w<CR>          |
" |    t    |                     |          |                  |                   | tabnew          |
" +---------+---------------------+----------+------------------+-------------------+-----------------+
" |    u    |                     |          |                  |                   | Unite           |
" |    v    |                     |          |                  |    default        |  default        |
" |    w    |                     |          |                  |                   | :q<CR> :bd<CR>  |
" |    x    |                     |          |                  |                   |                 |
" |    y    |                     |          |                  |                   |                 |
" +---------+---------------------+----------+------------------+-------------------+-----------------+
" |    z    |                     | zsh      |                  |                   | Unite file_mru  |
" |    .    | .vimrc              | .zshrc   |                  |                   |                 |
" +=========+=====================+==========+==================+===================+=================+
" }}} REFERENCE TO KEY MAPPING

" vim:foldmethod=marker
