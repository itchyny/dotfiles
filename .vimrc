" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2014/12/06 20:59:17.
" --------------------------------------------------------------------------------------------------------

" Initial process {{{1
filetype off
if &encoding !=? 'utf-8'
  let &termencoding = &encoding
  set encoding=utf-8
endif
scriptencoding utf-8
let $CACHE = expand('~/.vim/cache')
augroup Vimrc
  autocmd!
augroup END
if has('vim_starting')
  set rtp^=~/.vim/miv/miv/
endif

" Setting options {{{1
set encoding=utf-8 fileencoding=utf-8 fileencodings=utf-8,iso-2022-jp-3,euc-jisx0213,cp932,euc-jp,sjis,jis,latin,iso-2022-jp fileformats=unix,mac,dos
set number cursorline nocursorcolumn list listchars=tab:▸\ ,extends:»,precedes:«,nbsp:%
let [&t_SI,&t_EI] = ["\e]50;CursorShape=1\x7","\e]50;CursorShape=0\x7"]
set showmatch matchtime=1 noshowmode shortmess+=I noruler pumheight=10 completeopt-=preview autoread display=uhex
set history=1000 viminfo='10,/10,:500,<10,@10,s10,n$CACHE/.viminfo spellfile=$CACHE/en.utf-8.add nobackup
set swapfile directory=$CACHE/swap,$CACHE,/var/tmp/vim,/var/tmp undofile undodir=$CACHE/undo,$CACHE,/var/tmp/vim,/var/tmp
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
set updatetime=300 timeout timeoutlen=1000 ttimeout ttimeoutlen=50 ttyfast visualbell t_vb= noerrorbells wildmode=list:longest
set wildignore+=*.sw?,*.bak,*.?~,*.??~,*.???~,*.~,*.o,*.hi,*.pyc,*.aux,*.bbl,*.blg,*.dvi,*.nav,*.snm,*.toc,*.out,*.exe
if exists('&breakindent') | set breakindent | endif

" Enable plugin, indent, syntax {{{1
filetype plugin indent on
silent! syntax enable

" Auto commands {{{1
" Maximize the window
autocmd Vimrc GUIEnter * silent! simalt ~x

" Move to the directory each buffer
autocmd Vimrc BufEnter * silent! lcd `=expand('%:p:h')`

" View syntax name under cursor
command! S echo synIDattr(synID(line('.'), col('.'), 0), 'name')

" Open Quickfix window automatically
autocmd Vimrc QuickfixCmdPost [^l]* leftabove copen | wincmd p | redraw!
autocmd Vimrc QuickfixCmdPost l* leftabove lopen | wincmd p | redraw!

" Always open read-only when a swap file is found
autocmd Vimrc SwapExists * let v:swapchoice = 'o'

" Key mappings {{{1
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
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" smart Enter
inoremap <silent> <expr> <CR> (pumvisible()?"\<ESC>o":"\<C-g>u\<CR>")

" diff
nnoremap <silent> <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"

" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>

" search
nnoremap <silent> <Esc><Esc> :<C-u>set nohlsearch nopaste<CR>
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*
nnoremap # :<C-u>set hlsearch<CR>#

" navigate window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-x> <C-w>x
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]' <bar><bar> &l:buftype ==# 'quickfix') ? "<CR>" : "<C-w>j"
nnoremap <C-q> <C-w>

" Open dot files
execute 'nnoremap \. :edit' resolve(expand('~/.vimrc')) '<CR>'
execute 'nnoremap \; :edit' resolve(expand('~/.vimrc.yaml')) '<CR>'
execute 'nnoremap \, :edit' resolve(expand('~/.zshrc')) '<CR>'

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
