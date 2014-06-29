" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2014/06/29 12:53:56.
" --------------------------------------------------------------------------------------------------------

" INITIALIZE {{{
filetype off
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
try
  set list listchars=tab:▸\ ,extends:»,precedes:«,nbsp:%
catch
  set list listchars=tab:^I,extends:>,precedes:<,nbsp:%
endtry
set number cursorline nocursorcolumn
  autocmd Vimrc FileType vimshell,vimcalc,quickrun setlocal nonumber
  autocmd Vimrc FileType vimcalc,vimshell,quickrun,cam setlocal nocursorline
          \ | autocmd Vimrc BufEnter,WinEnter <buffer> setlocal nocursorline
let [&t_SI,&t_EI] = ["\e]50;CursorShape=1\x7","\e]50;CursorShape=0\x7"]
set showmatch noshowmode shortmess+=I noruler pumheight=10 completeopt-=preview autoread
set history=1000 viminfo='10,/10,:500,<10,@10,s10,n$CACHE/.viminfo directory=$CACHE/.swp,$CACHE,/tmp,. spellfile=$CACHE/.spellfile.add
set nospell
  autocmd Vimrc FileType tex,markdown,help exec 'setl ' . (&bt !=# 'help' && search("[^\x01-\x7e]", 'n') == 0 && line('$') > 5 ? '' : 'no') . 'spell'
if has('conceal') | set concealcursor=nvc | endif
set infercase wrapscan ignorecase smartcase incsearch nohlsearch magic
set laststatus=2 showtabline=1 statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
set background=dark
if !has('gui_running') | set t_Co=256 | endif
set encoding=utf-8 fenc=utf-8 fileencodings=utf-8,euc-jp,sjis,jis,iso-2022-jp,cp932,latin formatoptions+=mM ambiwidth=double iminsert=0 imsearch=0
set smartindent autoindent shiftwidth=2
  autocmd Vimrc FileType tex,hatena setlocal nosmartindent noautoindent
  let g:tex_indent_items=0
set textwidth=0 expandtab tabstop=2 backspace=indent,eol,start nrformats-=ocral
  autocmd Vimrc FileType * exec 'setl ' . (search('^\t.*\n\t.*\n\t', 'n') > 0 ? 'no' : '') . 'expandtab'
if exists('&clipboard')
  set clipboard=unnamed
  if has('unnamedplus') | set clipboard+=unnamedplus | endif
endif
set swapfile nobackup updatetime=300 timeoutlen=500 ttyfast vb t_vb= wildignore+=*.sw?,*.bak,*.?~,*.??~,*.???~,*.~,*.o,*.hi,*.pyc,*.aux,*.bbl,*.blg,*.dvi,*.nav,*.snm,*.toc,*.out,*.pdf,*.exe wildmode=list:longest
if exists('&breakindent') | set breakindent | endif

" Enable plugin, indent, syntax
filetype plugin indent on
syntax enable

" Maximize the window
if has('win16') || has('win32') || has('win64')
  autocmd Vimrc GUIEnter * simalt ~x
endif

" Move to the directory each buffer
autocmd Vimrc BufEnter * silent! lcd `=expand('%:p:h')`

" View syntax name under cursor
command! S echo synIDattr(synID(line('.'), col('.'), 0), 'name')

" Command line
for [s:cmd, s:exp] in [['vps', 'vsp'], ['vp', 'vsp'], ['di', 'Dictionary<SPACE>-cursor-word<SPACE>-no-duplicate'], ['aoff', 'AutodateOFF'], ['aon', 'AutodateON'], ['qa1', 'qa!'], ['q1', 'q!'], ['nvew', 'vnew']]
  exec 'cabbrev <expr> '.s:cmd.' (getcmdtype() == ":" && getcmdline() ==# "'.s:cmd.'") ? "'.s:exp.'" : "'.s:cmd.'"'
endfor

" Filetype
autocmd Vimrc CursorHold,CursorHoldI * call s:auto_filetype()
function! s:auto_filetype()
  if line('.') > 5 | return | endif
  let line1 = getline(1)
  if line1 =~# '^\s*$' | return | endif
  let newft = ''
  for [pat, ft] in [['*[', 'hatena'],['#include', 'c'],['\documentclass', 'tex'],['import', 'haskell'],['main =', 'haskell'],['diff --', 'diff'],['{ ', 'vim']]
    if line1[:strlen(pat) - 1] ==# pat | let newft = ft | endif
  endfor
  if newft != '' && (&filetype == '' || &filetype == newft)  | exec 'setlocal filetype=' . newft | endif
endfunction
" }}}

" KEY MAPPING {{{
" Escape key
if has('unix') && !has('gui_running')
  inoremap <silent> <ESC> <ESC>
endif

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
nnoremap ,<Space> ma:%s/\s\+$//e<CR>`a<ESC>

" smart Enter
inoremap <silent> <expr> <CR> (pumvisible()?"\<ESC>o":"\<C-g>u\<CR>")

" split by 80 characters
nnoremap <silent> ,80 :s/\(.\{80}\)/\1<c-v><Enter>/g<Enter><ESC>:<C-u>set nohlsearch<CR>
vnoremap <silent> ,80 :s/\(.\{80}\)/\1<c-v><Enter>/g<Enter><ESC>:<C-u>set nohlsearch<CR>

" diff
nnoremap <silent> <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"

" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>

" search
autocmd Vimrc BufEnter,WinEnter * nnoremap <silent><buffer> <Esc><Esc> :<C-u>set nohlsearch nopaste<CR>
autocmd Vimrc BufEnter,WinEnter [calendar* nunmap <buffer> <Esc><Esc>
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*
nnoremap # :<C-u>set hlsearch<CR>#

" navigate window
nnoremap <C-h> <C-w>h
nnoremap <C-m> <C-w>j
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-x> <C-w>x
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]') ? "<CR>" : "<C-w>j"
nnoremap <C-q> <C-w>

" Open dot files
if has('win16') || has('win32') || has('win64')
  nnoremap <silent> \. :<C-u>e ~/.vimrc<CR>
  nnoremap <silent> ;. :<C-u>e ~/.zshrc<CR>
else
  nnoremap <silent> \. :<C-u>e `=resolve(expand('~/.vimrc'))`<CR>
  nnoremap <silent> ;. :<C-u>e `=resolve(expand('~/.zshrc'))`<CR>
endif

" tab
nnoremap <C-t> :<C-u>tabnew<CR>
inoremap <C-t> <ESC>:<C-u>tabnew<CR>

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

" vim:foldmethod=marker
