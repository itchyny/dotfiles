" --------------------------------------------------------------------------------------------------------------
" File: .vimrc
" Author: itchyny
" Last Change: 2011/09/27 00:10:54.
" --------------------------------------------------------------------------------------------------------------
"
"

" Initial accessory {{{
set nocompatible
filetype off
let s:ismac = has('mac') || system('uname') =~? 'Darwin'

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END
" }}}

" VUNDLES {{{
" Vundle {{{
" --------------------------------------------------------------------------------------------------------------
"   + Write setting for each bundles right after Bundle '~~~'
"   + If vundle is not installed, execute below.
"   +   :! git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
let $BUNDLE=$HOME."/.vim/bundle"
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
" }}}

" Complement {{{
" --------------------------------------------------------------------------------------------------------------
Bundle 'Shougo/neocomplcache'
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_enable_smart_case = 1
  let g:neocomplcache_enable_underbar_completion = 1
  let g:neocomplcache_enable_camel_case_completion = 1
  let g:neocomplcache_snippets_dir = $BUNDLE."/snipmate.vim/snippets/"
  imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ?
        \     "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
  imap <expr><C-l> neocomplcache#sources#snippets_complete#expandable() ?
        \     "\<Plug>(neocomplcache_snippets_expand)" : "\<C-w>l"
Bundle 'ujihisa/neco-look'
Bundle 'neco-ghc'
" }}}

" Unite ( "," ) {{{
" --------------------------------------------------------------------------------------------------------------
                                                                                         let mapleader=","
Bundle 'Shougo/unite.vim'
  nnoremap <C-u> :Unite<SPACE>
  let g:unite_enable_start_insert=1
  noremap <C-p> :Unite buffer<CR>
  noremap <C-n> :Unite -buffer-name=file file<CR>
  noremap <C-z> :Unite file_mru<CR>
  nnoremap <Leader><Leader> :Unite file_mru<CR>
  augroup Unite
    autocmd!
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
    autocmd FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
    autocmd FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
  augroup END
Bundle 'unite-colorscheme'
Bundle 'ujihisa/vim-ref'
Bundle 'ujihisa/ref-hoogle'
  nnoremap <Leader>h :<C-u>Unite ref/hoogle<CR>
" }}}

" QuickRun / Filer / Outer world of Vim ( "\\" ) {{{
" --------------------------------------------------------------------------------------------------------------
                                                                                         let mapleader="\\"
Bundle 'Shougo/vimproc'
  " I use an easy script following, with setting of vimproc_dll_path.
  "
  "    #! /bin/sh
  "    cd ~/.vim/bundle/vimproc/
  "    if [ `uname` = "Darwin" ]; then
  "      echo "Mac!!!"
  "      make -f make_mac.mak
  "      cd autoload/
  "      rm procmac.so
  "      mv proc.so procmac.so
  "    elif [ `uname` = "Linux" ]; then
  "      echo "Linux!!!"
  "      make -f make_gcc.mak
  "      cd autoload/
  "      rm procunix.so
  "      mv proc.so procunix.so
  "    fi
  "
  if s:ismac
   "let g:vimproc_dll_path = $HOME."/.vim/bundle/vimproc/autoload/procmac.so"
   let g:vimproc_dll_path = $BUNDLE."/vimproc/autoload/procmac.so"
  else
   "let g:vimproc_dll_path = $HOME."/.vim/bundle/vimproc/autoload/procunix.so"
   let g:vimproc_dll_path = $BUNDLE."/vimproc/autoload/procunix.so"
  endif
Bundle 'thinca/vim-quickrun'
  let g:quickrun_config = {'*': {'runmode': 'async:vimproc', 'split': 'vertical'}}
  let g:quickrun_config.javascript = {'command' : 'node'}
  nnoremap <Leader>r :<C-u>QuickRun  <CR>
  nnoremap <Leader>e :<C-u>QuickRun <i <CR>
  nnoremap <Leader>o :<C-u>QuickRun <i >output <CR>
Bundle 'Shougo/vimfiler'
  let g:vimfiler_as_default_explorer = 1
  nnoremap <Leader>f :<C-u>VimFiler<CR>
Bundle 'eagletmt/ghci-vim'
  augroup Ghci
    autocmd!
    autocmd Filetype haskell nnoremap <Leader>l :<C-u>GhciLoad<CR>
    autocmd Filetype haskell nnoremap <Leader>i :<C-u>GhciInfo<CR>
    autocmd Filetype haskell nnoremap <Leader>t :<C-u>GhciType<CR>
  augroup END
Bundle 'eagletmt/coqtop-vim'
  nnoremap <Leader>v :<C-u>CoqStart<CR>
Bundle 'tyru/open-browser.vim'
  nmap <Leader>b <Plug>(openbrowser-smart-search)
  vmap <Leader>b <Plug>(openbrowser-smart-search)
  nmap <Leader>s <Plug>(openbrowser-search)
Bundle 'TwitVim'
  nnoremap <Leader>p :<C-u>PosttoTwitter<CR>
" }}}

" vimshell ( ";" ) {{{
" --------------------------------------------------------------------------------------------------------------
                                                                                          let mapleader=";"
Bundle 'Shougo/vimshell'
  augroup Vimshell
    autocmd!
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    let g:vimshell_prompt = " $ "
    " for easy window moving, unmap C-[hjkl]
    autocmd FileType vimshell iunmap <buffer> <C-h>
    autocmd FileType vimshell iunmap <buffer> <C-k>
    autocmd FileType vimshell iunmap <buffer> <C-l>
    autocmd FileType vimshell iunmap <buffer> <C-w>
    autocmd FileType vimshell nunmap <buffer> <C-k>
    autocmd FileType vimshell nunmap <buffer> <C-l>
    autocmd FileType vimshell inoremap <buffer> <C-h> <ESC><C-w>h
    autocmd FileType vimshell inoremap <buffer> <C-j> <ESC><C-w>j
    autocmd FileType vimshell inoremap <buffer> <C-k> <ESC><C-w>k
    autocmd FileType vimshell inoremap <buffer> <C-l> <ESC><C-w>l
    autocmd FileType vimshell inoremap <buffer> <expr><silent> <C-p> unite#sources#vimshell_history#start_complete(!0)
    " <Up><Down>の設定では効かないので, エスケープ文字で設定してます.
    autocmd FileType vimshell inoremap <buffer> <expr><silent> OA unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell inoremap <buffer> <expr><silent> OB unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> OA unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> OB unite#sources#vimshell_history#start_complete(!0)
  augroup END
  nnoremap <Leader><Leader>s :<C-u>VimShellTab<CR>
  nnoremap <Leader>s :<C-u>vnew<CR>:<C-u>VimShell<CR>
  nnoremap <S-h> :<C-u>VimShellPop<CR>
  nnoremap <Leader>z :<C-u>tabnew<CR>:VimShellInteractive zsh<CR>
  nnoremap <Leader>g :<C-u>tabnew<CR>:VimShellInteractive ghci<CR>
  nnoremap <Leader>p :<C-u>tabnew<CR>:VimShellInteractive python<CR>
  " nnoremap <Leader>a :<C-u>tabnew<CR>:VimShellInteractive gdb ./a.out
" }}}

" Commenter / Utility ( "," ) {{{
" --------------------------------------------------------------------------------------------------------------
                                                                                          let mapleader=","
Bundle 'tpope/vim-surround'
Bundle 't9md/vim-surround_custom_mapping'
Bundle 'scrooloose/nerdcommenter'
Bundle 'hrp/EnhancedCommentify'
  let g:EnhCommentifyBindInInsert='No'
Bundle 'sjl/gundo.vim'
  nnoremap <Leader>g :<C-u>GundoToggle<CR>
Bundle 'Align'
"Bundle 'msanders/snipmate.vim'
Bundle 'laughedelic/dotvim'
"Bundle 'CSApprox'
"Bundle 'errormarker.vim'
Bundle 'mattn/calendar-vim'
Bundle 'autodate.vim'
  let g:autodate_format="%Y/%m/%d %H:%M:%S"
Bundle 'smartword'
  map <Leader>w  <Plug>(smartword-w)
  map <Leader>b  <Plug>(smartword-b)
" }}}

" Syntax {{{
" --------------------------------------------------------------------------------------------------------------
Bundle 'mattn/zencoding-vim'
  let g:user_zen_expandabbr_key = '<c-e>'
  let g:user_zen_settings = { 'html' : { 'indentation' : '  ' }, }
Bundle 'tsaleh/vim-matchit'
Bundle 'JavaScript-syntax'
Bundle 'tyok/js-mask'
Bundle 'itspriddle/vim-javascript-indent'
Bundle 'pangloss/vim-javascript'
Bundle 'JSON.vim'
Bundle 'html5.vim'
Bundle 'wavded/vim-stylus'
"Bundle 'css_color.vim'
Bundle 'skammer/vim-css-color'
Bundle 'groenewege/vim-less'
Bundle 'less.vim'
Bundle 'syntaxm4.vim'
Bundle 'vim-scripts/jade.vim'
Bundle 'vim-coffee-script'
Bundle 'coq-syntax'
Bundle 'Coq-indent'
Bundle 'rest.vim'
" vim-rst-table: require vim_bridge (install with easy_install)
Bundle 'nvie/vim-rst-tables'
Bundle 'VST'
Bundle 'indenthaskell.vim'
Bundle 'syntaxhaskell.vim'
Bundle 'Haskell-Conceal'
Bundle 'syntaxm4.vim'
" }}}

" Colorscheme {{{
" --------------------------------------------------------------------------------------------------------------
Bundle 'Wombat'
" }}}

" }}} VUNDLES

" ENCODING / JAPANESE {{{
set encoding=utf-8
set fenc=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp,default,latin
set formatoptions+=mM       " 日本語の行の連結時には空白を入力しない。
" ☆や□や○の文字があってもカーソル位置がずれないようにする。
" terminator, gnome-terminalを以下のコマンドに貼り替える(Ubuntu)
"   /bin/sh -c "VTE_CJK_WIDTH=1 terminator -m"
"   /bin/sh -c "VTE_CJK_WIDTH=1 gnome-terminal --disable-factory"
set ambiwidth=double

" 書類を開くことができませんでした。テキストエンコーディング日本語(Mac OS)には対応していません。 {{{
" http://d.hatena.ne.jp/uasi/20110523/1306079612
autocmd BufWritePost * call SetUTF8Xattr(expand("<afile>"))
function! SetUTF8Xattr(file)
  let isutf8 = &fileencoding == "utf-8" || ( &fileencoding == "" && &encoding == "utf-8")
  if s:ismac && isutf8
    call system("xattr -w com.apple.TextEncoding 'utf-8;134217984' '" . a:file . "'")
  endif
endfunction
" }}}

" }}}

" APPERANCE {{{
" --------------------------------------------------------------------------------------------------------------
" Frame appearance {{{
set list
set showcmd
set showmode
" }}}

" Main appearance {{{
set shortmess+=I            " disable start up message
set number                  " line number
set nocursorline
set nocursorcolumn
set showmatch               " 括弧の対応
set showtabline=2           " always show tab
" }}}

" Status line {{{
set ruler                   " show the cursor position (needless if you set 'statusline')
set laststatus=2            " ステータスラインを常に表示
set statusline=%{expand('%:p:t')}\ %<\(%{expand('%:p:h')}\)%=\ %m%r%y%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}[%3l,%3c,%3p]
" }}}

" Color {{{
colorscheme wombat
syntax enable
set background=dark
if !has("gui_running")
  set t_Co=256
endif
" }}}

" Highlight {{{
"highlight TabLineSel guifg=white guibg=black  gui=bold ctermfg=white ctermbg=black  cterm=bold
"highlight TabLine    guifg=black guibg=white  gui=none ctermfg=black ctermbg=white  cterm=none
"highlight Normal guifg=#f6f3e8 guibg=#242424 gui=none
"highlight NonText guifg=#808080 guibg=#242424 gui=none
"highlight LineNr guifg=#857b6f guibg=#000000 gui=none
"highlight CursorColumn guibg=none ctermbg=none
highlight Pmenu guifg=black guibg=gray ctermfg=black ctermbg=gray
highlight PmenuSel guifg=black guibg=darkgray ctermfg=black ctermbg=darkgray
highlight PmenuSbar guifg=white guibg=darkgray ctermfg=white ctermbg=darkgray
highlight PmenuThumb guifg=white guibg=darkgray ctermfg=white ctermbg=darkgray
highlight Special ctermfg=red guifg=red
"highlight Visual guibg=grey ctermbg=grey
highlight VertSplit guifg=black guibg=darkgray gui=none ctermfg=black ctermbg=darkgray cterm=none
autocmd FileType * highlight Identifier ctermfg=cyan guifg=cyan
autocmd FileType * highlight Function ctermfg=green guifg=green
autocmd FileType * highlight String ctermfg=magenta guifg=magenta
autocmd FileType * highlight StatusLineNC guifg=black guibg=darkgray gui=none ctermfg=black ctermbg=darkgray cterm=none

" Statusline color
let s:hi_normal = 'highlight StatusLine guifg=black guibg=blue gui=none ctermfg=black ctermbg=blue cterm=none'
let s:hi_insert = 'highlight StatusLine guifg=black guibg=darkmagenta gui=none ctermfg=black ctermbg=darkmagenta cterm=none'
silent exec s:hi_normal
augroup InsertStatus
  autocmd!
  autocmd InsertEnter * exec s:hi_insert
  autocmd InsertLeave * exec s:hi_normal
augroup END
if has('unix') && !has('gui_running')
  " ESC後にすぐ反映されない対策(実際これいる)
  inoremap <silent> <ESC> <ESC>
endif
" }}}
" }}} APPERANCE

" FILE READING {{{
" --------------------------------------------------------------------------------------------------------------
set autoread                " 外部のエディタで編集中のファイルが変更されたら自動で読み直す

" Filetype {{{
augroup Filetype
  autocmd!
  autocmd BufNewFile,BufReadPost *.hs   set filetype=haskell
  autocmd BufNewFile,BufReadPost *.sir  set filetype=haskell
  autocmd BufNewFile,BufReadPost *.json set filetype=json
  autocmd BufNewFile,BufReadPost *.less set filetype=less
  autocmd BufNewFile,BufReadPost *.rst  set filetype=rest
  autocmd BufNewFile,BufReadPost *.v    set filetype=coq
  autocmd BufNewFile,BufReadPost *.y    set filetype=haskell
augroup END
" }}}

" Binary editor {{{
" http://d.hatena.ne.jp/goth_wrist_cut/20090809/1249800323
let $BINS="*.bin,*.exe,*.png,*.gif,*.jpg,*.jpeg,*.bmp,*.PNG,*.JPG,*.JPEG,*.BMP,*.ico,*.pdf,*.dvi,*.pyc,*.mp3"
augroup Binary
  autocmd!
  autocmd BufReadPost $BINS call BinReadPost()
  autocmd BufWritePre $BINS call BinWritePre()
  autocmd BufWritePost $BINS call BinWritePost()
  autocmd CursorHold $BINS call BinReHex()
  function! BinReadPost()
    silent %!xxd -g1
    set ft=xxd
  endfunction
  function! BinWritePre()
    let s:saved_pos = getpos( '.' )
    silent %!xxd -r
  endfunction
  function! BinWritePost()
    silent %!xxd -g1
    call setpos( '.', s:saved_pos )
    set nomod
  endfunction
  function! BinReHex()
    let s:saved_pos = getpos( '.' )
    let s:modified = &modified
    silent %!xxd -r
    silent %!xxd -g1
    call setpos( '.', s:saved_pos )
    let &modified = s:modified
  endfunction
augroup END
" }}}

" }}} FILE READING

" EDIT {{{
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
" }}}

" Special keys (tab, backspace) {{{
autocmd MyAutoCmd FileType * set textwidth=0   " No auto breking line
set expandtab               " insert spaces with <Tab>
set tabstop=2
retab
set backspace=indent,eol,start
" }}}

" Clipboard {{{
set clipboard=unnamed
set clipboard+=autoselect
" }}}

" }}}

" UTILITY {{{
" --------------------------------------------------------------------------------------------------------------
" Move to the directory for each buffer {{{
augroup MoveDirectory
  autocmd!
  autocmd BufEnter * execute ":lcd " . expand("%:p:h")
augroup END
" }}}

" Enable omni completation {{{
augroup Omnifunc
  autocmd!
  autocmd FileType c          set omnifunc=ccomplete#Complete
  autocmd FileType css        set omnifunc=csscomplete#CompleteCSS
  autocmd FileType html       set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php        set omnifunc=phpcomplete#CompletePHP
  autocmd FileType python     set omnifunc=pythoncomplete#Complete
  autocmd FileType xml        set omnifunc=xmlcomplete#CompleteTags
augroup END
setlocal omnifunc=syntaxcomplete#Complete
" }}}

" Make with F5 key {{{
function! Automake()
  if(filereadable('./OMakefile'))
    exec '!omake'
  else
    exec '!make all'
  endif
endfunction
nnoremap <F5> :<C-u>call Automake()<CR>
nnoremap <C-F5> :<C-u>!make release<CR>
" }}}

" AOJ template {{{
" function! AOJtemplate()
"   call append(0, '#include <cstdio>')
"   call append(1, '#include <iostream>')
"   call append(2, '#include <cmath>')
"   call append(3, '#include <stack>')
"   call append(4, '#include <vector>')
"   call append(5, '#include <algorithm>')
"   call append(6, '#include <string>')
"   call append(8, 'typedef long long ll;')
"   call append(9, 'using namespace std;')
"   call append(10, '')
"   call append(11, 'int main () {')
"   call append(12, '  int i = 0, j = 0, k = 0, l = 0, m = 0, n = 0;')
"   call append(13, '}')
" endfunction
" nnoremap <C-a> :call AOJtemplate()<CR>zRjjjjjo
" }}}

" Open file explorer at current directory {{{
function! Explorer()
  if s:ismac
    exec '! open -a Finder .'
  else
    exec '! nautilus .'
  endif
endfunction
nnoremap \n :call Explorer()<CR>
" }}}

" Quickly open with outer text editor {{{
function! TextEdit()
  if s:ismac
    exec '! open -a TextEdit %'
  else
    exec '! gedit %'
  endif
endfunction
nnoremap \g :call TextEdit()<CR>
" }}}

" 新型戦闘力計測器 {{{
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

" Quick open dot files {{{
nnoremap \. :vnew<CR>:e ~/.vimrc<CR>
      " autocmd BufWritePost .vimrc source %
nnoremap ;. :vnew<CR>:e ~/.zshrc<CR>
" }}}

" }}} UTILITY

" OTHERS {{{
" --------------------------------------------------------------------------------------------------------------
" Performance {{{
set lazyredraw
set ttyfast
" }}}

" Command line {{{
set wildmode=list:longest   " コマンドライン補間をシェルっぽく
" }}}

" }}}

" KEY MAPPING {{{
" --------------------------------------------------------------------------------------------------------------

" edit {{{
" Increment and decrement of numbers
noremap + <C-a>
noremap - <C-x>

" fold by indentation
noremap [ zak
noremap ] <S>j

" indentation in visual mode
vnoremap < <gv
vnoremap > >gv|

" always use line visual mode
noremap v <S-v>

" easy copy, paste
vnoremap <C-c> y
inoremap <C-p> <ESC>:<C-u>set paste<CR>p:<C-u>set nopaste<CR>

" remove spaces at the end of lines
nnoremap ,<Space> ma:%s/  *$//<CR>`a<ESC><ESC>
" }}}

" file {{{
" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
" }}}

" search {{{
nnoremap <silent> <Esc><Esc> :<C-u>set nohlsearch<CR>
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*
nnoremap # :<C-u>set hlsearch<CR>#
" }}}

" Navigation {{{
" window
inoremap <C-H> <ESC><C-w>h
inoremap <C-L> <ESC><C-w>l
inoremap <C-K> <ESC><C-w>k
inoremap <C-J> <ESC><C-w>j
nnoremap <C-H> <C-w>h
nnoremap <C-L> <C-w>l
nnoremap <C-K> <C-w>k
nnoremap <C-J> <C-w>j
nnoremap <C-X> <C-w>x
nnoremap <C-q> <C-w>
inoremap <C-q> <ESC><C-w>
vnoremap <C-q> <ESC><C-w>
nnoremap <C-w> :<C-u>q<CR>
inoremap <C-w> <ESC>:<C-u>q<CR>
vnoremap <C-w> :<C-u>q<CR>

" tab
nnoremap <C-t> :<C-u>tabnew<CR>
nnoremap <C-Right> gt
nnoremap <C-Left> gT
inoremap <C-Right> <ESC>gt
inoremap <C-Left> <ESC>gT

" assign arrow keys to page-(up|down)
nnoremap <Down> <C-d>
nnoremap <Up>  <C-u>
nnoremap <SPACE> <C-f>
"nnoremap <S-SPACE> <C-b>

" select last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" quit help
autocmd FileType help nnoremap <silent> <buffer> <ESC><ESC> :<C-u>q<CR>
" }}}

" }}}




" KEY MAPPINGS {{{
" normal mode
"      +===========+===========================+============+======================+====================+=========================+
"      | mapleader |             \             |      ;     |        ,             | <S-                |    <C-                  |
"      |           |  Outer world of Vim       |            |                      |                    |                         |
"      +===========+===========================+============+======================+====================+=========================+
"      |     a     |                           |            |                      |   -default         |                         |
"      |     b     |  OpenBrowser              |            |   smartword-b        |   ?                |                         |
"      |     c     |                           |            |                      |   -default         |                         |
"      |     d     |                           |            |                      |   -default         |                         |
"      |     e     |  QuickRun <i              |            |                      |   ?                |                         |
"      |     f     |  VimFiler                 |            |                      |   ?                |                         |
"      |     g     |                           |   Ghci     |   GundoToggle        |   -default         |                         |
"      |     h     |                           |            |   Unite ref/hoogle   |   VimshellPop      |    <C-w>h               |
"      |     i     |  GhciInfo                 |            |                      |   -default         |                         |
"      |     j     |                           |            |                      |   -default         |    <C-w>j               |
"      |     k     |                           |            |                      |   ?                |    <C-w>k               |
"      |     l     |  GhciLoad                 |            |                      |   ?                |    <C-w>l               |
"      |     m     |                           |            |                      |   ?                |                         |
"      |     n     |                           |            |                      |   ?                |     Unite file          |
"      |     o     |  QuickRun <i >output      |            |                      |   -default         |                         |
"      |     p     |  PosttoTwitter            |   Python   |                      |   ?                |     Unite buffer        |
"      |     q     |                           |            |                      |   ?                |                         |
"      |     r     |  QuickRun                 |            |                      |   -default         |                         |
"      |     s     |  OpenBrowser              |   VimShell |                      |   ?                |                         |
"      |     t     |  GhciType                 |            |                      |   ?                |                         |
"      |     u     |                           |            |                      |   ?                |     Unite               |
"      |     v     |  CoqStart                 |            |                      |   -default         |                         |
"      |     w     |                           |            |   smartword-w        |   ?                |                         |
"      |     x     |                           |            |                      |   ?                |                         |
"      |     y     |                           |            |                      |   ?                |                         |
"      |     z     |                           |   zsh      |                      |   ?                |     Unite file_mru      |
"      | <Leader>  |                           |            |   Unite file_mru     |   --------         |                         |
"      |    .      |    .vimrc                 |   .zshrc   |                      |                    |                         |
"      +===========+===========================+============+======================+====================+=========================+
" }}}



"set display+=lastline     " 画面最後の行をできる限り表示する。
"  set noimdisable           " IME
"  set iminsert=0 imsearch=0
"  set noimcmdline
"  "inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
"  augroup InsModeAu
"    autocmd!
"    autocmd InsertEnter,CmdwinEnter * set noimdisable
"    autocmd InsertLeave,CmdwinLeave * set imdisable
"  augroup END
"set fdm=indent

" vim: foldmethod=marker
