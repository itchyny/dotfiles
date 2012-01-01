" --------------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2011/12/28 00:08:18.
" --------------------------------------------------------------------------------------------------------------

" INITIALIZE {{{
" --------------------------------------------------------------------------------------------------------------
set nocompatible
filetype off
let s:ismac = has('mac') || system('uname') =~? 'Darwin'
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
  echo 'initializing neobundle\n'
  exec '!git clone git@github.com:Shougo/neobundle.vim.git '.s:neobundle_dir
  exec '!git clone git@github.com:Shougo/unite.vim.git '.$BUNDLE.'/unite.vim'
else
execute 'set runtimepath+='.expand(s:neobundle_dir)
call neobundle#rc(expand($BUNDLE))
NeoBundle 'Shougo/neobundle.vim'
  nnoremap <silent> <S-b> :<C-u>Unite neobundle/install:!<CR>
" }}}

" Complement {{{
" --------------------------------------------------------------------------------------------------------------
NeoBundle 'Shougo/neocomplcache'
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_enable_smart_case = 1
  let g:neocomplcache_enable_underbar_completion = 1
  let g:neocomplcache_enable_camel_case_completion = 1
  let g:neocomplcache_snippets_dir = expand($VIM.'/snippets')
  imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ?
        \     "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
  imap <expr><C-l> neocomplcache#sources#snippets_complete#expandable() ?
        \     "\<Plug>(neocomplcache_snippets_expand)" : "\<C-w>l"
" NeoBundle 'ujihisa/neco-look'
  " --| Requirement: look commnad
NeoBundle 'neco-ghc'
  " --| Requirement: ghc-mod
  " --|   $ cabal install ghc-mod
" }}}

" Unite ( "," ) {{{
" --------------------------------------------------------------------------------------------------------------
                                                                                         let mapleader=","
NeoBundle 'Shougo/unite.vim'
  let g:unite_enable_start_insert=1
  nnoremap <C-u> :Unite<SPACE>
  nnoremap <C-p> :Unite buffer<CR>
  nnoremap <C-n> :Unite -buffer-name=file file<CR>
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
" }}}

" QuickRun / Filer / Outer world of Vim ( "\\" ) {{{
" --------------------------------------------------------------------------------------------------------------
                                                                                         let mapleader="\\"
NeoBundle 'Shougo/vimproc'
  " --| I use an easy script following, with setting of vimproc_dll_path.
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
   let g:vimproc_dll_path = $BUNDLE."/vimproc/autoload/procmac.so"
  else
   let g:vimproc_dll_path = $BUNDLE."/vimproc/autoload/procunix.so"
  endif
NeoBundle 'thinca/vim-quickrun'
  let g:quickrun_config = {'*': {'runmode': 'async:vimproc', 'split': 'vertical'}}
  let g:quickrun_config.javascript = {'command' : 'node'}
  let g:quickrun_config.roy = {'command' : 'roy'}
  let g:quickrun_config.hss = {'command' : 'runhaskell'}
  let g:quickrun_config.markdown = { 'type': 'markdown/pandoc', 'outputter': 'browser', 'cmdopt': '-s' }
  let g:quickrun_config.lhaskell = {'command' : 'runhaskell'}
  nnoremap <Leader>r :<C-u>QuickRun  <CR>
  nnoremap <Leader>e :<C-u>QuickRun <i <CR>
  nnoremap <Leader>o :<C-u>QuickRun <i >file:output<CR>
  autocmd ESC FileType quickrun inoremap <silent> <buffer> <ESC><ESC><ESC> <ESC>:q<CR>
  autocmd ESC FileType quickrun nnoremap <silent> <buffer> <ESC><ESC><ESC> <ESC>:q<CR>
  autocmd ESC FileType quickrun vnoremap <silent> <buffer> <ESC><ESC><ESC> <ESC>:q<CR>
NeoBundle 'Shougo/vimfiler'
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_sort_type = 'TIME'
  hi def link vimfilerPdf Function
  hi def link vimfilerHtml Function
  hi def link vimfilerDateToday Identifier
  hi def link vimfilerDate Statement
  hi def link vimfilerTypeLink Constant
  hi def link vimfilerTypeExecute Special
  hi def link vimfilerTypeArchive NonText
  hi def link vimfilerTypeImage Statement
  nnoremap <Leader>f :<C-u>VimFilerCreate<CR>
  nnoremap <Leader><Leader> :<C-u>VimFilerCreate<CR>
  let g:vimfiler_execute_file_list = { 'pdf': 'open',
                                     \ 'png': 'open',
                                     \ 'jpg': 'open',
                                     \ 'bmp': 'open',
                                     \ 'ppt': 'open',
                                     \ 'html': 'open',
                                     \ }
  augroup Vimfiler
    autocmd!
    autocmd FileType vimfiler nunmap <buffer> <C-l>
    autocmd FileType vimfiler nunmap <buffer> \
    autocmd FileType vimfiler noremap <buffer> <C-l> <ESC><C-w>l
    autocmd FileType vimfiler noremap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
  augroup END
" NeoBundle 'eagletmt/ghci-vim'
"   augroup Ghci
"     autocmd!
"     autocmd Filetype haskell nnoremap <Leader>l :GhciLoad<CR>
"     autocmd Filetype haskell nnoremap <Leader>i :GhciInfo<CR>
"     autocmd Filetype haskell nnoremap <Leader>t :GhciType<CR>
"   augroup END
NeoBundle 'tyru/open-browser.vim'
  nmap <Leader>b <Plug>(openbrowser-smart-search)
  vmap <Leader>b <Plug>(openbrowser-smart-search)
  nmap <Leader>s <Plug>(openbrowser-search)
NeoBundle 'TwitVim'
  nnoremap <Leader>p :<C-u>PosttoTwitter<CR>
"  nnoremap <Leader>p :<C-u>!tweet<SPACE>
" }}}

" vimshell ( ";" ) {{{
" --------------------------------------------------------------------------------------------------------------
                                                                                          let mapleader=";"
NeoBundle 'Shougo/vimshell'
  " --| Requirement: vimproc
  hi def link VimShellLink Constant
  hi def link VimShellExe Special
  hi def link VimShellUserPrompt Function
  hi def link VimShellPrompt Function
  augroup Vimshell
    autocmd!
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    let g:vimshell_prompt = ' $ '
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
    " <Up><Down>の設定では効かないので, エスケープ文字で設定してます.
    autocmd FileType vimshell inoremap <buffer> <expr><silent> OA unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell inoremap <buffer> <expr><silent> OB unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> OA unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> OB unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell inoremap <buffer> <expr><silent> <Up> unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell inoremap <buffer> <expr><silent> <Down> unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> <Up> unite#sources#vimshell_history#start_complete(!0)
    autocmd FileType vimshell nnoremap <buffer> <expr><silent> <Down> unite#sources#vimshell_history#start_complete(!0)
  augroup END
  " autocmd ESC FileType vimshell inoremap <buffer> <ESC> <NOP>
  autocmd ESC FileType vimshell vnoremap <buffer> <ESC><ESC><ESC> :<C-u>q<CR>
  autocmd ESC FileType vimshell nnoremap <buffer> <ESC><ESC><ESC> :<C-u>q<CR>
  nnoremap <Leader><Leader>s :<C-u>VimShellTab<CR>
  nnoremap <Leader>s :<C-u>vnew<CR>:<C-u>VimShell<CR>
  nnoremap <S-h> :<C-u>VimShellPop<CR>
  nnoremap <Leader>z :<C-u>VimShellInteractive zsh<CR>
  autocmd FileType int-ghci set filetype=haskell
  nnoremap <Leader>g :<C-u>VimShellInteractive ghci<CR>
  nnoremap <Leader>p :<C-u>VimShellInteractive python<CR>
  " nnoremap <Leader>a :<C-u>tabnew<CR>:VimShellInteractive gdb ./a.out
" }}}

" Commenter / Utility ( "," ) {{{
" --------------------------------------------------------------------------------------------------------------
                                                                                          let mapleader=","
NeoBundle 'tpope/vim-surround'
NeoBundle 't9md/vim-surround_custom_mapping'
NeoBundle 'tComment'
NeoBundle 'sjl/gundo.vim'
  " --| Requirement: +python
  nnoremap <Leader>g :<C-u>GundoToggle<CR>
  autocmd ESC FileType gundo nnoremap <silent> <buffer> <ESC><ESC> :<C-u>GundoToggle<CR>
NeoBundle 'Align'
"NeoBundle 'msanders/snipmate.vim'
NeoBundle 'laughedelic/dotvim'
NeoBundle 'errormarker.vim'
NeoBundle 'mattn/calendar-vim'
  autocmd ESC FileType calendar nnoremap <silent> <buffer> <ESC><ESC> :<C-u>q<CR>
  nnoremap <Leader>c :<C-u>Calendar<CR>
NeoBundle 'autodate.vim'
  let g:autodate_format="%Y/%m/%d %H:%M:%S"
NeoBundle 'smartword'
  map <Leader>w  <Plug>(smartword-w)
  map <Leader>b  <Plug>(smartword-b)
NeoBundle 'VimCalc'
  autocmd ESC FileType vimcalc nnoremap <silent> <buffer> <ESC><ESC><ESC> :<C-u>q<CR>
  nnoremap <Leader>a :<C-u>Calc<CR>
NeoBundle 'autodate.vim'
NeoBundle 'kana/vim-arpeggio'
  "jk同時押しでEsc
  call arpeggio#load()
  Arpeggionmap jk <Esc>
  Arpeggioimap jk <Esc>
  Arpeggiocmap jk <Esc>
  Arpeggiovmap jk <Esc>
" }}}

" Syntax {{{
" --------------------------------------------------------------------------------------------------------------
NeoBundle 'mattn/zencoding-vim'
  let g:user_zen_expandabbr_key = '<c-e>'
  let g:user_zen_settings = { 'html' : { 'indentation' : '  ' }, }
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'JavaScript-syntax'
NeoBundle 'tyok/js-mask'
NeoBundle 'itspriddle/vim-javascript-indent'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'JSON.vim'
NeoBundle 'html5.vim'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'colorizer'
  augroup colorizer
    autocmd!
    autocmd BufNewFile,BufReadPost *.css ColorHighlight
  augroup END
NeoBundle 'groenewege/vim-less'
NeoBundle 'less.vim'
NeoBundle 'syntaxm4.vim'
NeoBundle 'vim-scripts/jade.vim'
NeoBundle 'vim-coffee-script'
NeoBundle 'coq-syntax'
NeoBundle 'Coq-indent'
NeoBundle 'rest.vim'
" vim-rst-table: require vim_bridge (install with easy_install)
" NeoBundle 'nvie/vim-rst-tables'
NeoBundle 'VST'
NeoBundle 'syntaxm4.vim'
NeoBundle 'syntaxhaskell.vim'
NeoBundle 'indenthaskell.vim'
NeoBundle 'haskell.vim'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'basyura/jslint.vim'
if s:ismac
  function! s:javascript_filetype_settings()
    autocmd BufWritePost <buffer> call jslint#check()
    autocmd CursorMoved  <buffer> call jslint#message()
    autocmd BufLeave     <buffer> call jslint#clear()
  endfunction
  augroup JsLint
    autocmd!
    autocmd FileType javascript call s:javascript_filetype_settings()
  augroup END
endif
" }}}

" Colorscheme {{{
" --------------------------------------------------------------------------------------------------------------
NeoBundle 'Wombat'
colorscheme wombat
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
  let isutf8 = &fileencoding == "utf-8" || ( &fileencoding == "" && &encoding == "utf-8")
  if s:ismac && isutf8
    call system("xattr -w com.apple.TextEncoding 'utf-8;134217984' '" . a:file . "'")
  endif
endfunction
" }}}

" }}} ENCODING

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
set cursorline
set nocursorcolumn
set showmatch               " 括弧の対応
set showtabline=2           " always show tab
" }}}

" Status line {{{
set ruler                   " show the cursor position (needless if you set 'statusline' later)
set laststatus=2            " ステータスラインを常に表示
set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
" }}}

" Color {{{
syntax enable
set background=dark
if !has("gui_running")
  set t_Co=256
endif
" }}}

" Highlight {{{
" highlight TabLineSel guifg=white guibg=black  gui=bold ctermfg=white ctermbg=black  cterm=bold
" highlight TabLine    guifg=black guibg=white  gui=none ctermfg=black ctermbg=white  cterm=none
" highlight Normal guifg=#f6f3e8 guibg=#242424 gui=none
" highlight NonText guifg=#808080 guibg=#242424 gui=none
" highlight LineNr guifg=#857b6f guibg=#000000 gui=none
" highlight CursorColumn guibg=none ctermbg=none
highlight Pmenu guifg=black guibg=gray ctermfg=black ctermbg=gray
highlight PmenuSel guifg=black guibg=darkgray ctermfg=black ctermbg=darkgray
highlight PmenuSbar guifg=white guibg=darkgray ctermfg=white ctermbg=darkgray
highlight PmenuThumb guifg=white guibg=darkgray ctermfg=white ctermbg=darkgray
highlight Special ctermfg=red guifg=red
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
  autocmd BufNewFile,BufReadPost,BufEnter *.hs   set filetype=haskell
  autocmd BufNewFile,BufReadPost,BufEnter *.tex  set filetype=tex
  autocmd BufNewFile,BufReadPost,BufEnter *.json set filetype=json
  autocmd BufNewFile,BufReadPost,BufEnter *.less set filetype=less
  autocmd BufNewFile,BufReadPost,BufEnter *.roy  set filetype=roy
  autocmd BufNewFile,BufReadPost,BufEnter *.rst  set filetype=rest
  autocmd BufNewFile,BufReadPost,BufEnter *.v    set filetype=coq
  autocmd BufNewFile,BufReadPost,BufEnter *.y    set filetype=haskell
  autocmd BufNewFile,BufReadPost,BufEnter *.mkd  set filetype=markdown
  autocmd BufNewFile,BufReadPost,BufEnter *.md   set filetype=markdown
  autocmd BufNewFile,BufReadPost,BufEnter *.r    set filetype=r
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
    " exec '%!xxd'
    " let &binary = 1
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
  autocmd FileType markdown setl shiftwidth=4
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
augroup MoveDirectory
  autocmd!
  autocmd BufEnter * execute ":lcd " . expand("%:p:h")
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
nnoremap <S-F5> :<C-u>call Automake()<CR>
" }}}

" AOJ template {{{
function! AOJtemplate()
  call append(0, '#include <cstdio>')
  call append(1, '#include <iostream>')
  call append(2, '#include <cmath>')
  call append(3, '#include <stack>')
  call append(4, '#include <vector>')
  call append(5, '#include <algorithm>')
  call append(6, '#include <string>')
  call append(8, 'typedef long long ll;')
  call append(9, 'using namespace std;')
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
  call append( 9, '        f  = \x -> "Case #" ++ show (fst x) ++ ": " ++ s (snd x)')
  call append(10, '')
  call append(11, 'solve (x:_) =')
endfunction
nnoremap ,p :<C-u>call GCJ()<CR><S-g>
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

nnoremap ss :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<CR>
" Quick open dot files {{{
nnoremap \. :e ~/.vimrc<CR>
  " autocmd BufWritePost .vimrc source %
nnoremap ;. :e ~/.zshrc<CR>
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

" }}} OTHERS

" KEY MAPPING {{{
" --------------------------------------------------------------------------------------------------------------

" edit {{{
" Increment and decrement of alphabets, numbers
set nrformats+=alpha
nnoremap + <C-a>
nnoremap - <C-x>

" fold by indentation
nnoremap [ zak
nnoremap ] <S>j

" indentation in visual mode
vnoremap < <gv
vnoremap > >gv|

" always use line visual mode
nnoremap v <S-v>

" easy copy, paste
vnoremap <C-c> y
inoremap <C-p> <ESC>:<C-u>set paste<CR>p:<C-u>set nopaste<CR>
vnoremap <C-x> d

" remove spaces at the end of lines
nnoremap ,<Space> ma:%s/  *$//<CR>`a<ESC>

" selecting all
nnoremap <C-a> gg<S-v><S-g>
inoremap <C-a> <ESC>gg<S-v><S-g>
vnoremap <C-a> gg<S-v><S-g>
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
" <C-j> doesn't work.
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
"nnoremap <SPACE> <C-f>
"nnoremap <S-SPACE> <C-b>

" select last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" quit help
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
" |    b    |  OpenBrowser         |            |  smartword-b       | NeoBundleInstall! |   -default         |
" |    c    |                      |            |  Calendar          |   -default        |                    |
" |    d    |                      |            |                    |   -default        |                    |
" |    e    |  QuickRun <i         |            |                    |                   |   zencoding        |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    f    |  VimFiler            |            |                    |                   |   -default         |
" |    g    |  gedit / Textedit    |  Ghci      |  GundoToggle       |   -default        |                    |
" |    h    |                      |            |  Unite ref/hoogle  |   VimshellPop     |   <C-w>h           |
" |    i    |  GhciInfo            |            |                    |   -default        |                    |
" |    j    |                      |            |                    |   -default        |   <C-w>j           |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    k    |                      |            |                    |                   |   <C-w>k           |
" |    l    |  GhciLoad            |            |                    |                   |   <C-w>l           |
" |    m    |                      |            |                    |                   |                    |
" |    n    |  nautilus / Finder   |            |                    |                   |   Unite file       |
" |    o    |  QuickRun <i >output |            |                    |   -default        |   Unite file       |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    p    |  PosttoTwitter       |  Python    |                    |                   |   Unite buffer     |
" |    q    |                      |            |                    |                   |   <C-w>(default)   |
" |    r    |  QuickRun            |            |                    |   -default        |   -default         |
" |    s    |  OpenBrowser         |  VimShell  |                    |                   |   :w<CR>           |
" |    t    |  GhciType            |            |                    |                   |   tabnew           |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    u    |                      |            |                    |                   |   Unite            |
" |    v    |  CoqStart            |            |                    |   -default        |   -default         |
" |    w    |                      |            |  smartword-w       |                   |   :q<CR>           |
" |    x    |                      |            |                    |                   |   d                |
" |    y    |                      |            |                    |                   |                    |
" +- - - - -+- - - - - - - - - - - +- - - - - - +- - - - - - - - - - +- - - - - - - - - -+- - - - - - - - - - +
" |    z    |                      |  zsh       |                    |                   |   Unite file_mru   |
" |   .     |  .vimrc              |  .zshrc    |                    |                   |                    |
" +=========+======================+============+====================+===================+====================+
" }}} REFERENCE TO KEY MAPPING

" vim: foldmethod=marker
