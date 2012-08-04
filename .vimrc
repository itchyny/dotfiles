" --------------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2012/08/04 18:13:39.
" --------------------------------------------------------------------------------------------------------------

" INITIALIZE {{{
" --------------------------------------------------------------------------------------------------------------
set nocompatible
filetype off
let s:ismac = has('mac') || system('uname') =~? 'Darwin'
let s:nosudo = $SUDO_USER == ''
augroup ESC
  autocmd!
augroup END
" }}}

" Bundles {{{
" neobundle {{{
" --------------------------------------------------------------------------------------------------------------
let $VIM = $HOME.'/.vim'
let $BUNDLE = $VIM.'/bundle'
let s:neobundle_dir = $BUNDLE.'/neobundle.vim'
if !isdirectory(s:neobundle_dir)
  if !executable('git')
    echo 'git not found! Sorry, this .vimrc cannot be completely used without git.'
  else
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
      if !executable('llvm-gcc')
        execute '!cd '.$BUNDLE.'/vimproc && gcc -O2 -W -Wall -Wno-unused -bundle -fPIC -arch x86_64 -arch '
              \.'i386 -o autoload/vimproc_mac.so autoload/proc.c -lutil'
      else
        execute '!cd '.$BUNDLE.'/vimproc && make -f make_mac.mak'
      endif
    else
      execute '!cd '.$BUNDLE.'/vimproc && make -f make_unix.mak'
    endif
  endif
else
execute 'set runtimepath+='.expand(s:neobundle_dir)
call neobundle#rc(expand($BUNDLE))
NeoBundle 'Shougo/neobundle.vim'
  " nnoremap <silent> <S-b><S-b> :<C-u>NeoBundleUpdate<CR>
  nnoremap <silent> <S-b><S-b> :<C-u>Unite neobundle/install:!<CR>
" }}}

" Complement {{{
" --------------------------------------------------------------------------------------------------------------
if s:nosudo
NeoBundle 'Shougo/neocomplcache'
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_enable_smart_case = 1
  let g:neocomplcache_enable_underbar_completion = 1
  let g:neocomplcache_enable_camel_case_completion = 1
  let g:neocomplcache_enable_cursor_hold_i = 0
NeoBundle 'Shougo/neocomplcache-snippets-complete'
  let g:neocomplcache_snippets_dir = expand($VIM.'/snippets')
  imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ?
        \     "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
  imap <expr><C-l> neocomplcache#sources#snippets_complete#expandable() ?
        \     "\<Plug>(neocomplcache_snippets_expand)" : "\<C-w>l"
" NeoBundle 'ujihisa/neco-look'
  " --| Requirement: look commnad
endif
" }}}

" Unite ( "," ) {{{
" --------------------------------------------------------------------------------------------------------------
let mapleader=","
if s:nosudo
NeoBundle 'Shougo/unite.vim'
  let g:unite_enable_start_insert=1
  nnoremap <C-u> :Unite<SPACE>
  nnoremap <C-p> :Unite buffer<CR>
  nnoremap <C-n> :Unite -buffer-name=file file<CR>
  nnoremap <S-k> :Unite output:message<CR>
  nnoremap <C-o> :Unite -buffer-name=file file<CR>
  nnoremap <C-z> :Unite file_mru<CR>
  augroup Unite
    autocmd!
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
  augroup END
  autocmd ESC FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
  autocmd ESC FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
NeoBundle 'Shougo/unite-build'
  nnoremap <F5> :<C-u>Unite build<CR>
NeoBundle 'unite-colorscheme'
NeoBundle 'ujihisa/vim-ref'
NeoBundle 'ujihisa/ref-hoogle'
  " --| Requirement: hoogle
  " --|   $ cabal install hoogle
  " --|   $ hoogle data
  nnoremap <Leader>h :<C-u>Unite ref/hoogle<CR>
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'ujihisa/unite-haskellimport'
endif
" }}}

" QuickRun / Filer / Outer world of Vim ( "\\" ) {{{
" --------------------------------------------------------------------------------------------------------------
let mapleader="\\"
NeoBundle 'Shougo/vimproc'
NeoBundle 'thinca/vim-quickrun'
  let g:quickrun_config = {'*': {'runmode': 'async:vimproc', 'split': 'vertical'}}
  let g:quickrun_config.javascript = {'command' : 'node'}
  let g:quickrun_config.roy = {'command' : 'roy'}
  let g:quickrun_config.hss = {'command' : 'runhaskell'}
  let g:quickrun_config.markdown = { 'type' : 'markdown/pandoc', 'outputter': 'browser', 'cmdopt': '-s' }
  let g:quickrun_config.qcl = { 'command': 'qcl' }
  let g:quickrun_config.lhaskell = {'command' : 'runhaskell'}
  let g:quickrun_config.tex = {'command' : 'autolatex'}
  let g:quickrun_config.nroff = { 'command': 'man', 'args': '-P cat'}
  nnoremap <Leader>r :<C-u>QuickRun  <CR>
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
  let g:vimfiler_tree_leaf_icon = ' '
  let g:vimfiler_tree_opened_icon = '▾'
  let g:vimfiler_tree_closed_icon = '▸'
  let g:vimfiler_file_icon = '-'
  let g:vimfiler_marked_file_icon = '*'
  nnoremap <Leader>f :<C-u>VimFilerCurrentDir<CR>
  nnoremap <Leader><Leader> :<C-u>VimFilerCurrentDir<CR>
  nnoremap @<Leader> :<C-u>VimFilerCurrentDir<CR>
  nnoremap @@ :<C-u>VimFilerCurrentDir<CR>
  let g:vimfiler_execute_file_list = { 'pdf': 'open', 'PDF': 'open',
                                     \ 'png': 'open', 'PNG': 'open',
                                     \ 'jpg': 'open', 'JPG': 'open',
                                     \ 'jpeg': 'open', 'JPEG': 'open',
                                     \ 'gif': 'open', 'GIF': 'open',
                                     \ 'bmp': 'open', 'BMP': 'open',
                                     \ 'ico': 'open', 'ICO': 'open',
                                     \ 'ppt': 'open', 'PPT': 'open',
                                     \ 'html': 'open', 'HTML': 'open',
                                     \ }
  augroup Vimfiler
    autocmd!
    autocmd FileType vimfiler nunmap <buffer> <C-l>
    autocmd FileType vimfiler nunmap <buffer> \
    autocmd FileType vimfiler nmap <buffer> <C-l> <ESC><C-q>l
    autocmd FileType vimfiler nmap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
    autocmd FileType vimfiler nmap <buffer> O <Plug>(vimfiler_sync_with_another_vimfiler)
    autocmd FileType vimfiler nmap <buffer><expr> e vimfiler#smart_cursor_map("\<Plug>(vimfiler_cd_file)","\<Plug>(vimfiler_edit_file)")
    autocmd VimEnter * VimFiler
  augroup END
NeoBundle 'Shougo/vinarise'
endif
NeoBundle 'eagletmt/ghci-vim'
  augroup Ghci
    autocmd!
    autocmd Filetype haskell nnoremap <Leader>l :GhciLoad<CR>
    autocmd Filetype haskell nnoremap <Leader>i :GhciInfo<CR>
    autocmd Filetype haskell nnoremap <Leader>t :GhciType<CR>
  augroup END
NeoBundle 'tyru/open-browser.vim'
  nmap <Leader>b <Plug>(openbrowser-smart-search)
  vmap <Leader>b <Plug>(openbrowser-smart-search)
  nmap <Leader>s <Plug>(openbrowser-search)
NeoBundle 'mattn/webapi-vim'
" }}}

" vimshell ( ";" ) {{{
" --------------------------------------------------------------------------------------------------------------
let mapleader=";"
if s:nosudo
NeoBundle 'Shougo/vimshell'
" --| Requirement: vimproc
" --| If you can't use sudo, do:
" --|  $ sudo chmod 4755 /usr/bin/sudo
  let g:vimshell_interactive_update_time = 150
  let g:vimshell_popup_command = "split"
  let g:vimshell_split_command = "vsplit"
  let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
  let g:vimshell_prompt = ' $ '
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
    autocmd FileType vimshell nmap <buffer> a GA
    autocmd FileType vimshell nmap <buffer> <C-m> <ESC><C-q>j
    autocmd FileType vimshell inoremap <buffer> <C-h> <ESC><C-w>h
    autocmd FileType vimshell inoremap <buffer> <C-j> <ESC><C-w>j
    autocmd FileType vimshell inoremap <buffer> <C-k> <ESC><C-w>k
    autocmd FileType vimshell inoremap <buffer> <C-l> <ESC><C-w>l
    " disable unexpected deleting
    autocmd FileType vimshell nnoremap <buffer> dj <Nop>
    autocmd FileType vimshell nnoremap <buffer> dk <Nop>
    autocmd FileType vimshell nnoremap <buffer> dG <Nop>
    autocmd FileType vimshell nnoremap <buffer> dg <Nop>
    autocmd FileType vimshell vnoremap <buffer> dj <Nop>
    autocmd FileType vimshell vnoremap <buffer> dk <Nop>
    autocmd FileType vimshell vnoremap <buffer> dG <Nop>
    autocmd FileType vimshell vnoremap <buffer> dg <Nop>
    autocmd FileType vimshell vnoremap <buffer> c <Nop>
    autocmd FileType vimshell vnoremap <buffer> <delete> <Nop>
    autocmd FileType vimshell vnoremap <buffer> a <ESC><ESC>GA
    autocmd FileType vimshell vnoremap <buffer> y yGA
    autocmd FileType vimshell imap <buffer> <C-^> <ESC><C-^>
    " <Up><Down>の設定では効かないので, エスケープ文字で設定してます.
    autocmd FileType vimshell inoremap <buffer> <expr><silent> OA unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell inoremap <buffer> <expr><silent> OB unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> OA unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> OB unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell inoremap <buffer> <expr><silent> <Up> unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell inoremap <buffer> <expr><silent> <Down> unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> <Up> unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> <Down> unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell autocmd BufEnter * call vimshell#start_insert(1)
  augroup END
  nnoremap <silent> <Leader><Leader>s :<C-u>VimShell -split<CR>
  nnoremap <silent> <Leader>s :<C-u>execute 'VimShellCreate '.<SID>current_directory()<CR>
  nnoremap <silent> <S-h> :<C-u>execute 'VimShellPop '.<SID>current_directory()<CR>
  nnoremap <Leader>z :<C-u>VimShellInteractive zsh<CR>
  nnoremap <Leader>g :<C-u>VimShellInteractive ghci<CR>
  nnoremap <Leader>p :<C-u>VimShellInteractive python<CR>
if executable('ghc-mod')
  " neocomplcache (neco-ghc) throws fatal error when ghc-mod is not found"
NeoBundle 'neco-ghc'
NeoBundle 'eagletmt/ghcmod-vim'
  " --| Requirement: ghc-mod
  " --|  $ cabal install ghc-mod
endif
endif
" }}}

" Commenter / Utility ( "," ) {{{
" --------------------------------------------------------------------------------------------------------------
let mapleader=","
NeoBundle 'tpope/vim-surround'
NeoBundle 't9md/vim-surround_custom_mapping'
NeoBundle 'tComment'
NeoBundle 'Align'
NeoBundle 'errormarker.vim'
NeoBundle 'mattn/calendar-vim'
  autocmd ESC FileType calendar nnoremap <silent> <buffer> <ESC><ESC> :<C-u>q<CR>
  nnoremap <Leader>c :<C-u>Calendar<CR>
NeoBundle 'autodate.vim'
  let g:autodate_format="%Y/%m/%d %H:%M:%S"
if has('python')
NeoBundle 'sjl/gundo.vim'
  " --| Requirement: +python
  nnoremap <Leader>g :<C-u>GundoToggle<CR>
  autocmd ESC FileType gundo nnoremap <silent> <buffer> <ESC><ESC> :<C-u>GundoToggle<CR>
" NeoBundle 'VimCalc'
"   " --| Requirement: +python
"   autocmd ESC FileType vimcalc nnoremap <silent> <buffer> <ESC><ESC><ESC> :<C-u>q<CR>
"   nnoremap <Leader>a :<C-u>Calc<CR>
endif
" }}}

" Syntax {{{
" --------------------------------------------------------------------------------------------------------------
NeoBundle 'scrooloose/syntastic'
NeoBundle 'mattn/zencoding-vim'
  let g:user_zen_expandabbr_key = '<c-e>'
  let g:user_zen_settings = { 'html' : { 'indentation' : '  ' }, }
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'JavaScript-syntax'
NeoBundle 'itspriddle/vim-javascript-indent'
NeoBundle 'JSON.vim'
NeoBundle 'html5.vim'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'colorizer'
  " augroup colorizer
  "   autocmd!
  "   autocmd BufNewFile,BufReadPost *.css ColorHighlight
  " augroup END
NeoBundle 'groenewege/vim-less'
NeoBundle 'less.vim'
NeoBundle 'syntaxm4.vim'
NeoBundle 'vim-scripts/jade.vim'
NeoBundle 'vim-coffee-script'
NeoBundle 'rest.vim'
NeoBundle 'VST'
NeoBundle 'syntaxm4.vim'
NeoBundle 'syntaxhaskell.vim'
NeoBundle 'haskell.vim'
NeoBundle 'tpope/vim-markdown'
" }}}

" Colorscheme {{{
" --------------------------------------------------------------------------------------------------------------
try
NeoBundle 'itchyny/landscape.vim'
  colorscheme landscape
catch
endtry
NeoBundle 'xterm-color-table.vim'
  " http://www.vim.org/scripts/script.php?script_id=3412
" }}}

" Powerline {{{
" --------------------------------------------------------------------------------------------------------------
NeoBundle 'Lokaltog/vim-powerline'
try
" --|  $ sudo apt-get install fontforge
" --|  $ sudo apt-get install python-fontforge
" --|  $ cd ~/.vim/bundle/vim-powerline/fontpatcher
" --|  $ wget http://levien.com/type/myfonts/Inconsolata.otf
" --|  $ python ./fontpatcher ./Iconsolata.otf
" --|  $ sudo cp ./Iconsolata-Powerline.otf /usr/share/fonts
set guifont=Iconsolata-Powerline.otf
let g:Powerline_symbols='fancy'
call Pl#Hi#Allocate({
  \ 'black'          : 16,
  \ 'white'          : 231,
  \
  \ 'darkestgreen'   : 22,
  \ 'darkgreen'      : 28,
  \
  \ 'darkestcyan'    : 20,
  \ 'mediumcyan'     : 117,
  \
  \ 'darkestblue'    : 24,
  \ 'darkblue'       : 31,
  \
  \ 'darkestred'     : 52,
  \ 'darkred'        : 88,
  \ 'mediumred'      : 124,
  \ 'brightred'      : 160,
  \ 'brightestred'   : 196,
  \
  \ 'darkestyellow'  : 59,
  \ 'darkyellow'     : 100,
  \ 'darkestpurple'  : 55,
  \ 'mediumpurple'   : 98,
  \ 'brightpurple'   : 189,
  \
  \ 'brightorange'   : 208,
  \ 'brightestorange': 214,
  \
  \ 'gray0'          : 233,
  \ 'gray1'          : 235,
  \ 'gray2'          : 236,
  \ 'gray3'          : 239,
  \ 'gray4'          : 240,
  \ 'gray5'          : 241,
  \ 'gray6'          : 244,
  \ 'gray7'          : 245,
  \ 'gray8'          : 247,
  \ 'gray9'          : 250,
  \ 'gray10'         : 252,
  \ })
" 'n': normal mode
" 'i': insert mode
" 'v': visual mode
" 'r': replace mode
" 'N': not active
let g:Powerline#Colorschemes#my#colorscheme = Pl#Colorscheme#Init([
  \ Pl#Hi#Segments(['SPLIT'], {
    \ 'n': ['white', 'gray2'],
    \ 'N': ['gray0', 'gray0'],
    \ }),
  \
  \ Pl#Hi#Segments(['mode_indicator'], {
    \ 'i': ['darkestgreen', 'white', ['bold']],
    \ 'n': ['darkestcyan', 'white', ['bold']],
    \ 'v': ['darkestpurple', 'white', ['bold']],
    \ 'r': ['mediumred', 'white', ['bold']],
    \ 's': ['white', 'gray5', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['fileinfo', 'filename'], {
    \ 'i': ['white', 'darkestgreen', ['bold']],
    \ 'n': ['white', 'darkestcyan', ['bold']],
    \ 'v': ['white', 'darkestpurple', ['bold']],
    \ 'r': ['white', 'mediumred', ['bold']],
    \ 'N': ['gray0', 'gray2', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['branch', 'scrollpercent', 'raw', 'filesize'], {
    \ 'n': ['gray2', 'gray7'],
    \ 'N': ['gray0', 'gray2'],
    \ }),
  \
  \ Pl#Hi#Segments(['fileinfo.filepath', 'status'], {
    \ 'n': ['gray10'],
    \ 'N': ['gray5'],
    \ }),
  \
  \ Pl#Hi#Segments(['static_str'], {
    \ 'n': ['white', 'gray4'],
    \ 'N': ['gray1', 'gray1'],
    \ }),
  \
  \ Pl#Hi#Segments(['fileinfo.flags'], {
    \ 'n': ['white'],
    \ 'N': ['gray4'],
    \ }),
  \
  \ Pl#Hi#Segments(['currenttag', 'fileformat', 'fileencoding', 'pwd', 'filetype', 'rvm:string', 'rvm:statusline', 'virtualenv:statusline', 'charcode', 'currhigroup'], {
    \ 'n': ['gray9', 'gray4'],
    \ }),
  \
  \ Pl#Hi#Segments(['lineinfo'], {
    \ 'n': ['gray2', 'gray10'],
    \ 'N': ['gray2', 'gray4'],
    \ }),
  \
  \ Pl#Hi#Segments(['errors'], {
    \ 'n': ['white', 'gray2'],
    \ }),
  \
  \ Pl#Hi#Segments(['lineinfo.line.tot'], {
    \ 'n': ['gray2'],
    \ 'N': ['gray2'],
    \ }),
  \
  \ Pl#Hi#Segments(['paste_indicator', 'ws_marker'], {
    \ 'n': ['white', 'brightred', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['gundo:static_str.name', 'command_t:static_str.name'], {
    \ 'n': ['white', 'mediumred', ['bold']],
    \ 'N': ['brightred', 'darkestred', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['gundo:static_str.buffer', 'command_t:raw.line'], {
    \ 'n': ['white', 'darkred'],
    \ 'N': ['brightred', 'darkestred'],
    \ }),
  \
  \ Pl#Hi#Segments(['gundo:SPLIT', 'command_t:SPLIT'], {
    \ 'n': ['white', 'darkred'],
    \ 'N': ['white', 'darkestred'],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:focus', 'ctrlp:byfname'], {
    \ 'n': ['brightpurple', 'darkestpurple'],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:prev', 'ctrlp:next', 'ctrlp:pwd'], {
    \ 'n': ['white', 'mediumpurple'],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:item'], {
    \ 'n': ['darkestpurple', 'white', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:marked'], {
    \ 'n': ['brightestred', 'darkestpurple', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:count'], {
    \ 'n': ['darkestpurple', 'white'],
    \ }),
  \
  \ Pl#Hi#Segments(['ctrlp:SPLIT'], {
    \ 'n': ['white', 'darkestpurple'],
    \ }),
  \ ])
let g:Powerline_colorscheme='my'
catch
endtry
" }}}

endif
" }}} Bundles

" ENCODING {{{
" --------------------------------------------------------------------------------------------------------------
set encoding=utf-8
set fenc=utf-8
set fileencodings=utf-8,euc-jp,sjis,jis,iso-2022-jp,cp932,latin
set formatoptions+=mM       " 日本語の行の連結時には空白を入力しない
" ☆や□や○の文字があってもカーソル位置がずれないようにする
" ambiwidthの設定のみでは, 解決しない場合がある
" Ubuntuでは, gnome-terminal, terminatorを以下のコマンドに貼り替えると解決する
"   /bin/sh -c "VTE_CJK_WIDTH=1 terminator -m"
"   /bin/sh -c "VTE_CJK_WIDTH=1 gnome-terminal --disable-factory"
set ambiwidth=double

" 書類を開くことができませんでした。テキストエンコーディング日本語(Mac OS)には対応していません。 {{{
" http://d.hatena.ne.jp/uasi/20110523/1306079612
autocmd BufWritePost * call SetUTF8Xattr(expand("<afile>"))
function! SetUTF8Xattr(file)
  let isutf8 = &fileencoding == "utf-8" || (&fileencoding == "" && &encoding == "utf-8")
  if s:ismac && isutf8
    call system("xattr -w com.apple.TextEncoding 'utf-8;134217984' '".a:file."'")
  endif
endfunction
" }}}

" }}} ENCODING

" APPERANCE {{{
" --------------------------------------------------------------------------------------------------------------
" Frame appearance {{{
" set showcmd
set noshowmode " https://github.com/vim-jp/issues/issues/100
" }}}

" Main appearance {{{
set list
set listchars=tab:▸\ ,extends:»,precedes:«,nbsp:%
set shortmess+=I            " disable start up message
set number
autocmd FileType vimshell setlocal nonumber
autocmd FileType vimcalc setlocal nonumber
autocmd FileType quickrun setlocal nonumber
set cursorline
autocmd FileType calendar setlocal nocursorline
autocmd FileType vimcalc setlocal nocursorline
autocmd FileType vimshell setlocal nocursorline
autocmd FileType quickrun setlocal nocursorline
set nocursorcolumn
set showmatch
set showtabline=1
set previewheight=20
" }}}

" Status line {{{
set ruler                   " show the cursor position (needless if you set 'statusline' later)
set laststatus=2            " ステータスラインを常に表示
set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p][%{strftime(\"%m/%d\ %H:%M\")}]
" }}}

" Color {{{
syntax enable
set background=dark
if !has("gui_running")
  set t_Co=256
endif
" }}}

" Highlight {{{
"}}}

" Statusline color {{{
if !exists('g:Powerline_colorscheme')
let s:hi_normal = 'highlight StatusLine guifg=black guibg=blue gui=none ctermfg=black ctermbg=blue cterm=none'
let s:hi_insert = 'highlight StatusLine guifg=black guibg=darkmagenta gui=none ctermfg=black ctermbg=darkmagenta cterm=none'
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
" --------------------------------------------------------------------------------------------------------------
set autoread

" Filetype {{{
augroup Filetype
  autocmd!
  autocmd BufNewFile,BufReadPost,BufEnter *.hs   set filetype=haskell
  autocmd BufNewFile,BufReadPost,BufEnter *.json set filetype=json
  autocmd BufNewFile,BufReadPost,BufEnter *.less set filetype=less
  autocmd BufNewFile,BufReadPost,BufEnter *.md   set filetype=markdown
  autocmd BufNewFile,BufReadPost,BufEnter *.mkd  set filetype=markdown
  autocmd BufNewFile,BufReadPost,BufEnter *.qcl  set filetype=qcl
  autocmd BufNewFile,BufReadPost,BufEnter *.r    set filetype=r
  autocmd BufNewFile,BufReadPost,BufEnter *.roy  set filetype=roy
  autocmd BufNewFile,BufReadPost,BufEnter *.rst  set filetype=rest
  autocmd BufNewFile,BufReadPost,BufEnter *.tex  set filetype=tex
  autocmd BufNewFile,BufReadPost,BufEnter *.tex  set noautoindent
  autocmd BufNewFile,BufReadPost,BufEnter *.tex  set nosmartindent
  autocmd BufNewFile,BufReadPost,BufEnter *.y    set filetype=haskell
augroup END
" }}}

" Binary editor {{{
" http://d.hatena.ne.jp/goth_wrist_cut/20090809/1249800323
let $BINS="*.bin,*.exe,*.png,*.gif,*.jpg,*.jpeg,*.bmp,*.PNG,*.JPG,*.JPEG,*.BMP,*.ico,*.pdf,*.dvi,*.pyc,*.mp3"
augroup Binary
  autocmd!
  autocmd FileType xxd nnoremap <silent> <buffer> ,b :%!xxd <CR><CR>
  autocmd FileType xxd nnoremap <silent> <buffer> ,r :%!xxd -r <CR><CR>
  autocmd BufReadPre $BINS let &binary = 1
  autocmd BufReadPost $BINS call BinReadPost()
  " autocmd BufWritePre $BINS call BinWritePre()
  " autocmd BufWritePost $BINS call BinWritePost()
  " autocmd CursorHold $BINS call BinReHex()
  function! BinReadPost()
    set filetype=xxd
    " execute '%!xxd'
    " let &binary = 1
  endfunction
  function! BinWritePre()
    let s:saved_pos = getpos('.')
    silent %!xxd -r
  endfunction
  function! BinWritePost()
    silent %!xxd -g1
    call setpos('.', s:saved_pos)
    set nomod
  endfunction
  function! BinReHex()
    let s:saved_pos = getpos('.')
    let s:modified = &modified
    silent %!xxd -r
    silent %!xxd -g1
    call setpos('.', s:saved_pos)
    let &modified = s:modified
  endfunction
augroup END
" }}}

" }}} FILE READING

" EDIT {{{
" --------------------------------------------------------------------------------------------------------------
" Search {{{
set wrapscan                " 最後まで検索したら先頭へ戻る
set ignorecase              " 大文字小文字無視
set smartcase               " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch               " インクリメンタルサーチ
set hlsearch                " 検索文字をハイライト
set magic                   " パターン中で.[*の特殊文字を使用する
" }}}

" Indent {{{
filetype plugin indent on
set autoindent
set smartindent
set shiftwidth=2
  autocmd FileType markdown setlocal shiftwidth=4
" }}}

" Special keys (tab, backspace) {{{
augroup Textwidth
  autocmd!
  autocmd FileType * set textwidth=0   " No auto breking line
  autocmd FileType *.rest set textwidth=50
augroup END
set expandtab               " insert spaces with <Tab>
set tabstop=2
retab
set backspace=indent,eol,start
" }}}

" Clipboard {{{
set clipboard=unnamed
set clipboard+=autoselect
" }}}

" }}} EDIT

" UTILITY {{{
" --------------------------------------------------------------------------------------------------------------
" Move to the directory for each buffer {{{
function! s:current_directory()
  if &filetype ==# 'vimfiler'
    let path = b:vimfiler.current_dir
  else
    let path = substitute(expand("%:p:h"),'\*vinarise\* - ','','')
  endif
  return escape(path, '*[]?{} ')
endfunction
augroup ChangeDirectory
  autocmd!
  function! s:change_directory()
    try
      execute ':lcd '.s:current_directory()
    catch
    endtry
  endfunction
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
  if(filereadable('./OMakefile') && executable('omake'))
    execute '!omake'
  else
    execute '!make all'
  endif
endfunction
nnoremap <S-F5> :<C-u>call Automake()<CR>
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
nnoremap ,,, :call AOJtemplate()<CR>zRjjjjjo
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
  else
    execute '! gedit %'
  endif
endfunction
nnoremap \g :call TextEdit()<CR>
" }}}

" 新型戦闘力計測器 {{{
" http://d.hatena.ne.jp/thinca/20091031/1257001194
function! Scouter(file, ...)
  let pat = '^\s*$\|^\s*"'
  let lines = readfile(a:file)
  if !a:0 || !a:1
    let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
  endif
  return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
\        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)
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
nnoremap \. :e ~/.vimrc<CR>
nnoremap \v :so ~/.vimrc<CR>
nnoremap ;. :e ~/.zshrc<CR>
" }}}

" template for blog {{{
nnoremap ,cpp i>\|cpp\|<CR>\|\|<<ESC>O<ESC>
nnoremap ,sh i>\|sh\|<CR>\|\|<<ESC>O<ESC>
nnoremap ,hs i>\|haskell\|<CR>\|\|<<ESC>O<ESC>
" }}}

" }}} UTILITY

" OTHERS {{{
" --------------------------------------------------------------------------------------------------------------
" Performance {{{
set ttyfast
" }}}

" Command line {{{
set wildmode=list:longest   " コマンドライン補間をシェルっぽく
" }}}

" }}} OTHERS

" KEY MAPPING {{{
" --------------------------------------------------------------------------------------------------------------

" edit {{{
" Increment and decrement of alphabets, numbers
" set nrformats+=alpha
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

" easy copy, paste
vnoremap <C-c> y
inoremap <C-p> <ESC>:<C-u>set paste<CR>p:<C-u>set nopaste<CR>
if s:ismac
  nmap \pp :r !pbpaste<CR><CR>
  nmap \pb :.w !pbcopy<CR><CR>
  vmap \pb :w !pbcopy<CR><CR>
endif

" remove spaces at the end of lines
nnoremap ,<Space> ma:%s/  *$//<CR>`a<ESC>

" selecting all
nnoremap <C-a> gg<S-v><S-g>
inoremap <C-a> <ESC>gg<S-v><S-g>
vnoremap <C-a> gg<S-v><S-g>

" smart Enter
inoremap <silent> <expr> <CR> (pumvisible()?"\<ESC>o":"\<C-g>u\<CR>")
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
nnoremap <C-m> <C-w>j
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
inoremap <C-w> <ESC>:<C-u>q<CR>
nnoremap <C-w> :<C-u>q<CR>
vnoremap <C-w> :<C-u>q<CR>

" tab
nnoremap <C-t> :<C-u>tabnew<CR>
inoremap <C-Left> <ESC>gT
inoremap <C-Right> <ESC>gt
nnoremap <C-Left> gT
nnoremap <C-Right> gt
vnoremap <C-Left> gT
vnoremap <C-Right> gt

" assign arrow keys to page-(up|down)
nnoremap <Down> <C-d>
nnoremap <Up>  <C-u>

" select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" quit help with escapae key
autocmd ESC FileType help nnoremap <silent> <buffer> <ESC><ESC> :<C-u>q<CR>
" }}}

" }}} KEY MAPPING

" REFERENCE TO KEY MAPPING {{{
" --------------------------------------------------------------------------------------------------------------
" normal mode
" +=========+======================+============+====================+===================+====================+
" | Leader  |          \           |     ;      |         ,          |      <S-          |      <C-           |
" |         |  Outer world of Vim  |  vimshell  |      utility       |                   |                    |
" +=========+======================+============+====================+===================+====================+
" |    a    |                      |            |  Calc              |   -default        |   gg<S-v><S-g>     |
" |    b    |  OpenBrowser         |            |                    | NeoBundleInstall! |   -default         |
" |    c    |                      |            |  Calendar          |   -default        |                    |
" |    d    |                      |            |                    |   -default        |                    |
" |    e    |  QuickRun <i         |            |                    |                   |   zencoding        |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    f    |  VimFiler            |            |                    |                   |   -default         |
" |    g    |  gedit / Textedit    |  Ghci      |  GundoToggle       |   -default        |                    |
" |    h    |                      |            |  Unite ref/hoogle  |   VimshellPop     |   <C-w>h           |
" |    i    |                      |            |                    |   -default        |                    |
" |    j    |                      |            |                    |   -default        |   <C-w>j           |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    k    |                      |            |                    |                   |   <C-w>k           |
" |    l    |                      |            |                    |                   |   <C-w>l           |
" |    m    |                      |            |                    |                   |                    |
" |    n    |  nautilus / Finder   |            |                    |                   |   Unite file       |
" |    o    |  QuickRun <i >output |            |                    |   -default        |   Unite file       |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    p    |                      |  Python    |                    |                   |   Unite buffer     |
" |    q    |                      |            |                    |                   |   <C-w>(default)   |
" |    r    |  QuickRun            |            |                    |   -default        |   -default         |
" |    s    |  OpenBrowser         |  VimShell  |                    |                   |   :w<CR>           |
" |    t    |                      |            |                    |                   |   tabnew           |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    u    |                      |            |                    |                   |   Unite            |
" |    v    |                      |            |                    |   -default        |   -default         |
" |    w    |                      |            |                    |                   |   :q<CR>           |
" |    x    |                      |            |                    |                   |   d                |
" |    y    |                      |            |                    |                   |                    |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    z    |                      |  zsh       |                    |                   |   Unite file_mru   |
" |    .    |  .vimrc              |  .zshrc    |                    |                   |                    |
" +=========+======================+============+====================+===================+====================+
" }}} REFERENCE TO KEY MAPPING
"
" vim:foldmethod=marker
