" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2014/12/01 10:10:29.
" --------------------------------------------------------------------------------------------------------

" INITIALIZE {{{
filetype off
if &encoding !=? 'utf-8'
  let &termencoding = &encoding
  set encoding=utf-8
endif
scriptencoding utf-8
let $VIM_PATH = expand('~/.vim')
let $CACHE = $VIM_PATH.'/.cache'
augroup Vimrc
  autocmd!
augroup END
if has('vim_starting')
  set rtp^=~/.vim/miv/miv/
endif
" }}}

" Setting {{{
" Option
set encoding=utf-8 fileencoding=utf-8 fileencodings=utf-8,iso-2022-jp-3,euc-jisx0213,cp932,euc-jp,sjis,jis,latin,iso-2022-jp fileformats=unix,mac,dos
set number cursorline nocursorcolumn list listchars=tab:▸\ ,extends:»,precedes:«,nbsp:%
let [&t_SI,&t_EI] = ["\e]50;CursorShape=1\x7","\e]50;CursorShape=0\x7"]
set showmatch matchtime=1 noshowmode shortmess+=I noruler pumheight=10 completeopt-=preview autoread display=uhex
set history=1000 viminfo='10,/10,:500,<10,@10,s10,n$CACHE/.viminfo directory=$CACHE/.swp,$CACHE,/tmp,. spellfile=$CACHE/.spellfile.add undodir=$CACHE/.undo undofile
set nospell
  autocmd Vimrc FileType tex,markdown,help exec 'setl ' . (&bt !=# 'help' && search("[^\x01-\x7e]", 'n') == 0 && line('$') > 5 ? '' : 'no') . 'spell'
if has('conceal') | set concealcursor=nvc | endif
set infercase wrapscan ignorecase smartcase incsearch nohlsearch magic
set laststatus=2 showtabline=1 statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
set background=dark synmaxcol=300
if !has('gui_running') | set t_Co=256 | endif
set formatoptions+=mM ambiwidth=double iminsert=0 imsearch=0
set smartindent autoindent shiftwidth=2
  autocmd Vimrc FileType tex,hatena setlocal nosmartindent noautoindent
  let g:tex_indent_items=0
set textwidth=0 expandtab tabstop=2 backspace=indent,eol,start nrformats-=ocral
  autocmd Vimrc FileType * exec 'setl ' . (search('^\t.*\n\t.*\n\t', 'n') > 0 ? 'no' : '') . 'expandtab'
if exists('&clipboard')
  set clipboard=unnamed
  if has('unnamedplus') | set clipboard+=unnamedplus | endif
endif
set swapfile nobackup updatetime=300 timeout timeoutlen=1000 ttimeout ttimeoutlen=50 ttyfast visualbell t_vb= noerrorbells wildmode=list:longest
set wildignore+=*.sw?,*.bak,*.?~,*.??~,*.???~,*.~,*.o,*.hi,*.pyc,*.aux,*.bbl,*.blg,*.dvi,*.nav,*.snm,*.toc,*.out,*.exe
if exists('&breakindent') | set breakindent | endif

" Enable plugin, indent, syntax
filetype plugin indent on
silent! syntax enable

" Maximize the window
if has('win16') || has('win32') || has('win64')
  autocmd Vimrc GUIEnter * simalt ~x
endif

" Move to the directory each buffer
autocmd Vimrc BufEnter * silent! lcd `=expand('%:p:h')`

" View syntax name under cursor
command! S echo synIDattr(synID(line('.'), col('.'), 0), 'name')

" Filetype
autocmd Vimrc CursorHold,CursorHoldI * call s:auto_filetype()
function! s:auto_filetype()
  if line('.') > 5 || &ft != '' | return | endif
  let line1 = getline(1)
  if line1 =~# '^\s*$' | return | endif
  let newft = ''
  for [pat, ft] in [['*[', 'hatena'],['#include', 'c'],['\documentclass', 'tex'],['import', 'haskell'],['main ', 'haskell'],['module ', 'haskell'],['diff --', 'diff'],['{ ', 'vim']]
    if line1[:strlen(pat) - 1] ==# pat | let newft = ft | endif
  endfor
  if newft != '' | exec 'setlocal filetype=' . newft | endif
endfunction

" Open Quickfix window automatically
autocmd Vimrc QuickfixCmdPost [^l]* copen | redraw!
autocmd Vimrc QuickfixCmdPost l* lopen | redraw!

" Always open read-only when a swap file is found
autocmd Vimrc SwapExists * let v:swapchoice = 'o'
" }}}

" KEY MAPPING {{{
" Increment and decrement
nnoremap + <C-a>
nnoremap - <C-x>

" indentation in visual mode
vnoremap < <gv
vnoremap > >gv|

" swap line/normal visual mode
noremap V v
noremap v V

" yank to the end of line
nnoremap Y y$

" remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u> call <SID>remove_trailing_space()<CR>
function! s:remove_trailing_space()
  let view = winsaveview()
  try
    keeppatterns %s/\s\+$//e
  catch
    %s/\s\+$//e
  endtry
  call winrestview(view)
endfunction

" smart Enter
inoremap <silent> <expr> <CR> (pumvisible()?"\<ESC>o":"\<C-g>u\<CR>")

" diff
nnoremap <silent> <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"

" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>

" search
autocmd Vimrc BufEnter,WinEnter * nnoremap <silent><buffer> <Esc><Esc> :<C-u>set nohlsearch nopaste<CR>
function! s:search(key)
  set hlsearch
  return a:key
endfunction
nnoremap <expr> / <sid>search('/')
nnoremap <expr> ? <sid>search('?')
nnoremap <expr> * <sid>search('*')
nnoremap <expr> # <sid>search('#')

" navigate window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-x> <C-w>x
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]' <bar><bar> &l:buftype ==# 'quickfix') ? "<CR>" : "<C-w>j"
nnoremap <C-q> <C-w>

" Open dot files
if has('win16') || has('win32') || has('win64')
  nnoremap <silent> \. :<C-u>e ~/.vimrc<CR>
  nnoremap <silent> \, :<C-u>e ~/.zshrc<CR>
else
  nnoremap <silent> \. :<C-u>e `=resolve(expand('~/.vimrc'))`<CR>
  nnoremap <silent> \, :<C-u>e `=resolve(expand('~/.zshrc'))`<CR>
endif

" tab
nnoremap <silent> <C-t> :<C-u>tabnew<CR>
inoremap <silent> <C-t> <ESC>:<C-u>tabnew<CR>
nnoremap <silent> g0 :<C-u>tabfirst<CR>
nnoremap <silent> g$ :<C-u>tablast<CR>

" tag
nnoremap <C-@> <C-t>

" select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" disable EX-mode
map Q <Nop>

" navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" <C-g> in command line
cmap <C-g> <ESC><C-g>
" }}} KEY MAPPING
