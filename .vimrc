" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2017/06/25 12:38:12.
" --------------------------------------------------------------------------------------------------------

" Setting options {{{1
" No Vi-compatible in case of being sourced with -u.
if &compatible | set nocompatible | endif

" Encoding
if &encoding !=? 'utf-8' | let &termencoding = &encoding | endif
set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos
set fileencodings=utf-8,iso-2022-jp-3,euc-jisx0213,cp932,euc-jp,sjis,jis,latin,iso-2022-jp

" Appearance
silent! set number background=dark display=lastline,uhex wrap wrapmargin=0 guioptions=ce key=
silent! set noshowmatch matchtime=1 noshowmode shortmess+=I cmdheight=1 cmdwinheight=10 showbreak=
silent! set noshowcmd noruler rulerformat= laststatus=2 statusline=%t\ %=\ %m%r%y%w\ %3l:%-2c
silent! set title titlelen=100 titleold= titlestring=%f noicon iconstring=%t norightleft showtabline=1
silent! set cursorline nocursorcolumn colorcolumn= concealcursor=nvc conceallevel=0 norelativenumber
silent! set list listchars=tab:>\ ,nbsp:_ synmaxcol=1000 ambiwidth=double breakindent breakindentopt=
silent! set nosplitbelow nosplitright startofline linespace=0 whichwrap=b,s scrolloff=0 sidescroll=0
silent! set equalalways nowinfixwidth nowinfixheight winminwidth=3 winminheight=3 nowarn noconfirm
silent! set fillchars=vert:\|,fold:\  eventignore= helplang=en viewoptions=options,cursor virtualedit=
if has('gui_running') | set lines=999 columns=999 | else | set t_Co=256 | endif
silent! let [&t_SI,&t_EI] = exists('$TMUX') ? ["\ePtmux;\e\e[5 q\e\\","\ePtmux;\e\e[2 q\e\\"] : ["\e]50;CursorShape=1\x7","\e]50;CursorShape=0\x7"]

" Editing
silent! set iminsert=0 imsearch=0 nopaste pastetoggle= nogdefault comments& commentstring=#\ %s
silent! set smartindent autoindent shiftround shiftwidth=2 expandtab tabstop=2 smarttab softtabstop=2
silent! set foldclose=all foldcolumn=0 nofoldenable foldlevel=0 foldmarker& foldmethod=indent
silent! set textwidth=0 backspace=indent,eol,start nrformats=hex formatoptions=cmMj nojoinspaces
silent! set nohidden autoread noautowrite noautowriteall nolinebreak mouse= modeline& modelines&
silent! set noautochdir write nowriteany writedelay=0 verbose=0 verbosefile= notildeop noinsertmode
silent! set tags=tags,./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
silent! set tags+=../../../../../../tags,../../../../../../../tags,~/Documents/scala/tags,~/Documents/*/tags tagstack

" Clipboard
silent! set clipboard=unnamed
silent! set clipboard+=unnamedplus

" Cache files
let $CACHE = expand((isdirectory(expand('~/Dropbox/.vim/cache')) ? '~/Dropbox' : '~') . '/.vim/cache')
if !isdirectory($CACHE) | silent! call mkdir($CACHE, 'p') | endif
silent! set history=1000 viminfo='10,/100,:1000,<10,@10,s10,h,n$CACHE/.viminfo
silent! set nospell spellfile=$CACHE/en.utf-8.add
silent! set swapfile directory=$CACHE/swap,$CACHE,/var/tmp/vim,/var/tmp
silent! set nobackup backupdir=$CACHE/backup,$CACHE,/var/tmp/vim,/var/tmp
silent! set undofile undolevels=1000 undodir=$CACHE/undo,$CACHE,/var/tmp/vim,/var/tmp

" Search
silent! set wrapscan ignorecase smartcase incsearch hlsearch magic

" Insert completion
silent! set complete& completeopt=menu infercase pumheight=10 noshowfulltag shortmess+=c

" Command line
silent! set wildchar=9 nowildmenu wildmode=list:longest wildoptions= wildignorecase cedit=<C-k>
silent! set wildignore=*.~,*.?~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.out,*.lock suffixes=*.pdf

" Performance
silent! set updatetime=300 timeout timeoutlen=500 ttimeout ttimeoutlen=50 ttyfast lazyredraw

" Bell
silent! set noerrorbells visualbell t_vb=

" Auto commands {{{1
augroup vimrc
  autocmd!
augroup END

" Maximize the window
autocmd vimrc GUIEnter * silent! simalt ~x

" Reset t_vb again
autocmd vimrc GUIEnter * silent! set t_vb=

" Move to the directory each buffer
autocmd vimrc BufEnter * silent! lcd %:p:h

" Open Quickfix window automatically
autocmd vimrc QuickfixCmdPost [^l]* nested leftabove copen | wincmd p
autocmd vimrc QuickfixCmdPost l* nested leftabove lopen | wincmd p

" Fix window position of help
autocmd vimrc FileType help if &l:buftype ==# 'help' | wincmd K | endif

" Always open read-only when a swap file is found
autocmd vimrc SwapExists * let v:swapchoice = 'o'

" Automatically set expandtab
autocmd vimrc FileType * execute 'setlocal ' . (search('^\t.*\n\t.*\n\t', 'n') ? 'no' : '') . 'expandtab'

" Setting lazyredraw causes a problem on startup
autocmd vimrc VimEnter * redraw

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

" yank entire lines
nnoremap yie :<C-u>%y<CR>

" remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" smart Enter
inoremap <silent><expr> <CR> (pumvisible() && bufname('%') !=# '[Command Line]' ? "\<C-e>\<CR>" : "\<C-g>u\<CR>")

" diff
nnoremap <silent> <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"

" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
cnoremap <C-s> <C-u>w<CR>

" Clear hlsearch and set nopaste
nnoremap <silent> <Esc><Esc> :<C-u>set nopaste<CR>:nohlsearch<CR>

" Go to the first non-blank character of the line after paragraph motions
noremap } }^

" navigate window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-x> <C-w>x
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]' <bar><bar> &l:buftype ==# 'quickfix') ? "<CR>" : "<C-w>j"
nnoremap <C-q> <C-w>

" improve scroll
noremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line('.') < 1         + winheight(0) ? 'H' : 'L')
noremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line('.') > line('$') - winheight(0) ? 'L' : 'H')
noremap <expr> <C-y> (line('w0') <= 1         ? 'k' : "\<C-y>")
noremap <expr> <C-e> (line('w$') >= line('$') ? 'j' : "\<C-e>")

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
vnoremap <C-]> <ESC><C-w><C-]><C-w>H
nnoremap <C-@> <C-t>

" select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" disable EX-mode
nnoremap  Q <Nop>
nnoremap gQ <Nop>

" Go to the starting position after visual modes
vnoremap <ESC> o<ESC>

" Operator [
onoremap [ <ESC>

" Execute register
nnoremap ] @

" navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" Command line history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>

" Escape from Select mode to Normal mode
snoremap <ESC> <C-c>

" Enable ftplugin, indent, syntax {{{1
filetype off
if has('vim_starting')
  let &runtimepath = (isdirectory(expand('~/Dropbox/.vim')) ? '~/Dropbox' : '~') . '/.vim/miv/miv/,' . &runtimepath
endif
filetype plugin indent on
silent! syntax enable
if !has('vim_starting')
  doautocmd FileType
endif
