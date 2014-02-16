" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 2014/02/16 10:42:33.
" --------------------------------------------------------------------------------------------------------

" INITIALIZE {{{
filetype off
scriptencoding utf-8
if !executable(&shell) | set shell=sh | endif
let s:isunix = has('unix')
let s:iswin = has('win16') || has('win32') || has('win64')
let s:ismac = !s:iswin && !has('win32unix') && (has('mac') || has('macunix') || has('guimacvim'))
let s:fancy = s:ismac && has('multi_byte')
let s:nosudo = $SUDO_USER == ''
let $VIM = expand('~/.vim')
let $CACHE = $VIM.'/.cache'
let $BUNDLE = $VIM.'/bundle'
let s:neobundle_dir = $BUNDLE.'/neobundle.vim'
augroup Vimrc
  autocmd!
augroup END
" }}}

" Bundles {{{
" neobundle
if !isdirectory(s:neobundle_dir)
  if executable('git')
    exec '!mkdir -p '.$BUNDLE.' && git clone https://github.com/Shougo/neobundle.vim '.s:neobundle_dir
  endif
else
if has('vim_starting')
  execute 'set runtimepath+='.expand(s:neobundle_dir)
endif
call neobundle#rc(expand($BUNDLE))
NeoBundleFetch 'Shougo/neobundle.vim'
  nnoremap <silent> BB :<C-u>Unite neobundle/update -log -no-start-insert<CR>

" Colorscheme
NeoBundle 'itchyny/landscape.vim', {'type': 'nosync'}
  colorscheme landscape
  let g:landscape_highlight_url = 1
  let g:landscape_highlight_todo = 1
  let g:landscape_highlight_url_filetype = {'thumbnail': 0}
NeoBundleLazy 'xterm-color-table.vim', {'autoload': {'commands': [{'name': 'XtermColorTable'}]}}

" Lightline
NeoBundle 'itchyny/lightline.vim', {'type': 'nosync'}
NeoBundle 'itchyny/lightline-powerful', {'type': 'nosync'}
  let g:lightline = {'colorscheme': 'landscape','mode_map':{'c': 'NORMAL'}}
  exec 'set guifont=' . substitute('Inconsolata for Powerline', ' ', s:iswin ? '_' : '\\ ', 'g') . (s:ismac ? ':h15' : s:iswin ?  ':h13:cANSI' : '\ 12')
  if s:iswin | set guifontwide=MS_Gothic:h11:cSHIFTJIS | endif

" Complement
NeoBundle 'Shougo/neocomplete.vim', {'disabled': !(has('lua') && v:version > 703)}
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#max_list = 1000
  let g:neocomplete#skip_auto_completion_time = "0.20"
  let g:neocomplete#auto_completion_start_length = 1
  let g:neocomplete#data_directory = $CACHE.'/neocomplete'
  let g:neocomplete#force_overwrite_completefunc = 1
  let g:neocomplete#ignore_source_files = [ 'member.vim', 'tag.vim', 'dictionary.vim', 'include.vim' ]
  let g:neocomplete#force_omni_input_patterns = get(g:, 'neocomplete#force_omni_input_patterns', {})
  let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
  let g:neosnippet#snippets_directory = expand($VIM.'/snippets')
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  imap <expr><C-o> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
NeoBundle 'ujihisa/neco-look', {'disabled': !executable('look')}

" Unite ( "," )
let g:mapleader = ","
if s:nosudo
NeoBundle 'Shougo/unite.vim'
  let g:unite_enable_start_insert = 1
  let g:unite_cursor_line_highlight = 'CursorLine'
  let g:loaded_unite_source_mru = 1
  let g:unite_force_overwrite_statusline = 0
  let g:unite_data_directory = $CACHE.'/unite'
  let g:unite_marked_icon = s:fancy ? '✓' : 'v'
  let g:unite_candidate_icon = '-'
  nnoremap <silent><C-p> :Unite buffer -buffer-name=buffer<CR>
  nnoremap <silent><C-n> :Unite file/new directory/new -buffer-name=file/new,directory/new<CR>
  nnoremap <silent><S-k> :Unite output:message -buffer-name=output<CR>
  nnoremap <silent><C-o> :Unite file file/new -buffer-name=file<CR>
  nnoremap <silent><S-l> :Unite line -buffer-name=line<CR>
  augroup Unite
    autocmd!
    autocmd FileType unite inoremap <silent> <buffer> <C-o> <Nop>
    autocmd FileType unite nmap <buffer> <C-a> <Plug>(unite_insert_enter)
    autocmd FileType unite nmap <buffer> OA <Plug>(unite_rotate_previous_source)
    autocmd FileType unite nnoremap <buffer> OB <Down>
    autocmd FileType unite nmap <buffer> <Bs> <Plug>(unite_exit)
  augroup END
NeoBundleLazy 'Shougo/unite-build', {'autoload': {'unite_sources': ['build']}}
  nnoremap <silent><F5> :<C-u>Unite build -buffer-name=build<CR>
NeoBundleLazy 'unite-colorscheme', {'autoload': {'unite_sources': ['colorscheme']}}
NeoBundleLazy 'osyo-manga/unite-highlight', {'autoload': {'unite_sources': ['highlight']}}
NeoBundleLazy 'eagletmt/unite-haddock', {'autoload': {'unite_sources': ['hoogle']}, 'disabled': !executable('hoogle')}
  nnoremap <Leader>h :<C-u>Unite hoogle -buffer-name=hoogle<CR>
NeoBundleLazy 'h1mesuke/unite-outline', {'autoload': {'unite_sources': ['outline']}}
NeoBundleLazy 'ujihisa/unite-haskellimport', {'autoload': {'unite_sources': ['haskellimport']}}
NeoBundleLazy 'pasela/unite-webcolorname', {'autoload': {'unite_sources': ['webcolorname']}}
NeoBundleLazy 'rhysd/codic-vim-with-unite', {'autoload': {'unite_sources': ['codic']}}
NeoBundle 'itchyny/unite-eject', {'type': 'nosync'}
NeoBundle 'itchyny/unite-auto-open', {'type': 'nosync'}
NeoBundle 'itchyny/unite-changetime', {'type': 'nosync'}
NeoBundle 'itchyny/unite-preview', {'type': 'nosync'}
  let s:bundle = neobundle#get('unite.vim')
  function! s:bundle.hooks.on_post_source(bundle)
    call unite#custom_source('file', 'ignore_pattern', '.*\.\(o\|exe\|dll\|bak\|sw[po]\|hi\|fff\|aux\|toc\|bbl\|blg\|DS_Store\)$')
    call unite#custom_source('haddock,hoogle', 'max_candidates', 20)
  endfunction
endif

" QuickRun / Filer / Outer world of Vim ( "\\" )
let g:mapleader = "\\"
NeoBundle 'Shougo/vimproc', { 'build' : { 'others' : 'make' } }
NeoBundle 'thinca/vim-quickrun'
  let g:quickrun_config = {'_': {'runner': 'vimproc', 'runner/vimproc/updatetime': 60, 'split': 'vertical', 'into': 1}}
  let s:quickrun_command_list = map(split('quickrun;cat,javascript;node,roy;roy,qcl;qcl,haskell;runhaskell,bf;bf', ','), 'split(v:val, ";")')
  for [s:ft, s:exe] in s:quickrun_command_list
    execute printf('if executable("%s") | let g:quickrun_config.%s = {"command":"%s"} | endif', s:exe, s:ft, s:exe)
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
    let g:quickrun_config.nroff = {'command': 'man', 'args': " -P cat | tr '\b' '\1' | sed -e 's/.\1//g'", 'filetype': 'man'}
  endif
  if executable('autognuplot')
    let g:quickrun_config.gnuplot = {'command' : 'autognuplot'}
  elseif executable('gnuplot')
    let g:quickrun_config.gnuplot = {'command' : 'gnuplot'}
  endif
  let g:quickrun_config.objc = {'command': 'cc', 'exec': ['%c %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'], 'tempfile': '{tempname()}.m'}
  if executable('scad3.exe')
    let g:quickrun_config.spice = {'command': 'scad3.exe', 'exec': ['%c -b %s:t'] }
  endif
  if executable('abcm2ps')
    let g:quickrun_config.abc = {'command': 'abcm2ps', 'exec': ['%c %s -O %s:p:r.ps', 'ps2pdf %s:p:r.ps', 'open %s:p:r.pdf']}
    if executable('abc2midi')
      call extend(g:quickrun_config.abc.exec, ['abc2midi %s -o %s:p:r.mid', 'open %s:p:r.mid'])
    endif
  endif
  nnoremap <silent> <Leader>r :<C-u>QuickRun -outputter/buffer/name "[quickrun output%{tabpagenr()>1?' '.tabpagenr():''}]"<CR>
  nnoremap <silent> <Leader><Leader>r :<C-u>QuickRun >file:temp.dat<CR>
  nnoremap <silent> <Leader>e :<C-u>QuickRun <i <CR>
  nnoremap <silent> <Leader>o :<C-u>execute "QuickRun " . (filereadable("i") ? "<i " : "") . ">file:output"<CR>
if s:nosudo
NeoBundle 'Shougo/vimfiler'
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_sort_type = 'TIME'
  let g:vimfiler_safe_mode_by_default = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimfiler_data_directory = $CACHE.'/vimfiler'
  let g:vimfiler_draw_files_limit = 1000
  let g:vimfiler_tree_leaf_icon = s:fancy ? ' ' : '|'
  let g:vimfiler_tree_opened_icon = s:fancy ? '▾' : '-'
  let g:vimfiler_tree_closed_icon = s:fancy ? '▸' : '+'
  let g:vimfiler_file_icon = '-'
  let g:vimfiler_readonly_file_icon = s:fancy ? '✗' : 'x'
  let g:vimfiler_marked_file_icon = s:fancy ? '✓' : 'v'
  let g:loaded_netrwPlugin = 1
  nnoremap <silent> <Leader>f :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  nnoremap <silent> <Leader><Leader> :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  let g:vimfiler_execute_file_list = {}
  for s:ft in split('pdf,png,jpg,jpeg,gif,bmp,ico,ppt,html', ',')
    let g:vimfiler_execute_file_list[s:ft] = 'open'
  endfor
  augroup Vimfiler
    autocmd!
    autocmd FileType vimfiler nunmap <buffer> <C-l>
    autocmd FileType vimfiler nunmap <buffer> \
    autocmd FileType vimfiler nnoremap <buffer> <C-l> <ESC><C-w>l
    autocmd FileType vimfiler nmap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
    autocmd FileType vimfiler nmap <buffer> O <Plug>(vimfiler_sync_with_another_vimfiler)
    autocmd FileType vimfiler nmap <buffer><expr> e vimfiler#smart_cursor_map("\<Plug>(vimfiler_cd_file)", "\<Plug>(vimfiler_edit_file)")
    autocmd FileType vimfiler nnoremap <buffer><silent> t :<C-u>call vimfiler#mappings#do_action('change_time')<CR>
    autocmd FileType vimfiler if filereadable("Icon\r") | silent call delete("Icon\r") | endif
  augroup END
NeoBundle 'Shougo/vinarise'
endif
NeoBundleLazy 'eagletmt/ghci-vim', {'autoload': {'filetypes': ['haskell']}}
  augroup Ghci
    autocmd!
    autocmd FileType haskell nnoremap <buffer> <Leader>l GhciLoad
    autocmd FileType haskell nnoremap <buffer> <Leader>i GhciInfo
    autocmd FileType haskell nnoremap <buffer> <Leader>t GhciType
  augroup END
NeoBundle 'tyru/open-browser.vim'
  nmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
  vmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
NeoBundle 'mattn/webapi-vim'

" vimshell ( ";" )
let g:mapleader = ";"
NeoBundle 'Shougo/vimshell.vim'
  let g:vimshell_interactive_update_time = 150
  let g:vimshell_popup_command = 'top new'
  let g:vimshell_split_command = 'vsplit'
  let g:vimshell_prompt_expr = 'escape(fnamemodify(getcwd(), ":~"), "\\[]()?! ")." "'
  let g:vimshell_prompt_pattern = (s:iswin ? '\%(^\f:' : '\%(^[~/]') . '\%(\f\|\\.\)* \|^[a-zA-Z][a-zA-Z .0-9]\+> \|^>>> \)'
  let g:vimshell_scrollback_limit = 1000000000
  let g:vimshell_disable_escape_highlight = 0
  let g:vimshell_force_overwrite_statusline = 0
  let g:vimshell_temporary_directory = $CACHE.'/vimshell'
  let g:vimshell_max_command_history = 1000000
  let g:vimshell_vimshrc_path = expand('~/Dropbox/.files/.vimshrc')
  augroup Vimshell
    autocmd!
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
    autocmd FileType vimshell inoremap <silent><buffer> ^ <ESC>:call vimshell#execute('cd ../')<CR>:call vimshell#print_prompt()<CR>:call vimshell#start_insert()<CR>
    autocmd FileType vimshell inoremap <buffer> <C-^> <ESC><C-^>
    autocmd FileType vimshell imap <buffer><C-g> <Plug>(vimshell_history_neocomplete)
    let s:start_complete = ' "\<ESC>GA" . unite#sources#vimshell_history#start_complete(!0)'
    for s:key in ['<UP>', '<Down>', 'OA', 'OB']
      execute "autocmd FileType vimshell inoremap <buffer> <expr><silent> ".s:key.s:start_complete
      execute "autocmd FileType vimshell nnoremap <buffer> <expr><silent> ".s:key.s:start_complete
    endfor
  augroup END
  nnoremap <silent> <Leader>s :<C-u>VimShellBufferDir<CR>
  nnoremap <silent> H :<C-u>VimShellBufferDir -popup<CR>
  nnoremap <silent> s :<C-u>VimShellBufferDir<CR>
NeoBundleLazy 'eagletmt/neco-ghc', {'autoload': {'filetypes': ['haskell']}, 'disabled': !executable('ghc-mod')}
  let g:necoghc_enable_detailed_browse = 1
NeoBundleLazy 'eagletmt/ghcmod-vim', {'autoload': {'filetypes': ['haskell']}, 'disabled': !executable('ghc-mod')}
  nnoremap <Leader>g :<C-u>GhcModCheckAsync<CR>

" Commenter / Utility / Matching ( "," )
let g:mapleader = ","
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
NeoBundleLazy 'Align', {'autoload': {'commands': [{'name': 'Align'}]}}
NeoBundle 'autodate.vim'
  let g:autodate_format = '%Y/%m/%d %H:%M:%S'
NeoBundleLazy 'sjl/gundo.vim', {'autoload': {'commands': [{'name': 'GundoToggle'}]}, 'disabled': !has('python')}
  nnoremap <Leader>g :<C-u>GundoToggle<CR>
NeoBundleLazy 'VimCalc', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Calc'}]}, 'disabled': !has('python')}
  nnoremap <silent> <Leader>a :<C-u>Calc<CR>
NeoBundle 'gregsexton/MatchTag'
NeoBundle 'matchit.zip'
NeoBundleLazy 'thinca/vim-scouter', {'autoload': {'commands': [{'name': 'Scouter'}]}}
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kien/ctrlp.vim'
  let g:ctrlp_cmd = 'CtrlPMRUFiles'
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_max_depth = 5
  let g:ctrlp_max_files = 300
  let g:ctrlp_mruf_max = 300
  let g:ctrlp_custom_ignore = { 'dir': '\v[\/]\.(git|hg|svn)$', 'file': '\v\.(exe|so|dll|swp|pdf|DS_Store)$', }
  let g:ctrlp_open_new_file = 'r'
  let g:ctrlp_use_caching = 1
  let g:ctrlp_cache_dir = $CACHE.'/ctrlp'
  let s:_ctrlp_cache = g:ctrlp_cache_dir . '/mru/cache.txt'
  silent call writefile(map(readfile(s:_ctrlp_cache), "substitute(v:val, '^/home/\\a\\+', $HOME, '')"), s:_ctrlp_cache)
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'tyru/capture.vim'
NeoBundle 'banyan/recognize_charcode.vim'
NeoBundleLazy 'itchyny/thumbnail.vim', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Thumbnail', 'complete': 'customlist,thumbnail#complete'}]}}
  nnoremap <silent> <Leader>t :<C-u>Thumbnail -here<CR>
NeoBundle 'itchyny/calendar.vim', {'type': 'nosync'}
  nnoremap <silent> <Leader>z :<C-u>Calendar -here<CR>
  let g:calendar_cache_directory = $CACHE.'/calendar'
  let g:calendar_views = [ 'year', 'month', 'day_3', 'clock' ]
  let g:calendar_google_calendar = 1
  let g:calendar_google_task = 1
  augroup CalendarKey
    autocmd!
    autocmd FileType calendar nunmap <buffer> <C-h>
    autocmd FileType calendar nunmap <buffer> <C-l>
  augroup END
NeoBundleLazy 'itchyny/dictionary.vim', {'type': 'nosync', 'autoload': {'commands': [{'name': 'Dictionary', 'complete': 'customlist,dictionary#complete'}]}}
  nnoremap <silent> <Leader>y :<C-u>Dictionary -no-duplicate<CR>
  let g:dictionary_executable_path = '~/Dropbox/bin/'
NeoBundle 'itchyny/vim-cmdline-ranges', {'type': 'nosync'}
NeoBundle 'itchyny/vim-insert-mode-motion', {'type': 'nosync'}
NeoBundle 'itchyny/vim-spellbad-pattern', {'type': 'nosync'}
  let g:spellbad_pattern = [ '\<a\> [aiueo]', '^\$', '\<figure..\?\\', '\\ref{eq:'
        \ , '^\\end{align}', '[^\~]\\\(eq\)\?ref\>', 'does not [a-z]*s\>', 's [a-z][a-z]\+s\>', '\<a \S\+s\>', 'in default']
NeoBundle 'itchyny/vim-closebuffer', {'type': 'nosync'}
  map <C-w> <Plug>(closebuffer)
  imap <C-w> <Plug>(closebuffer)
NeoBundle 'vim-jp/vital.vim'

" Syntax
NeoBundleLazy 'scrooloose/syntastic', {'autoload': {'filetypes': ['c', 'cpp'], 'functions': ['SyntasticStatuslineFlag']}}
  let g:syntastic_mode_map = { 'mode': 'passive' }
  let g:syntastic_echo_current_error = 0
  let g:syntastic_enable_highlighting = 0
  autocmd Vimrc BufWritePost *.c,*.cpp call s:syntastic()
  function! s:syntastic()
    if exists(':SyntasticCheck') | exec 'SyntasticCheck' | endif
    if exists('*lightline#update') | call lightline#update() | endif
  endfunction
NeoBundleLazy 'mattn/emmet-vim', {'autoload': {'filetypes': ['html']}}
  let g:user_emmet_settings = { 'indentation' : '  ' }
  autocmd Vimrc FileType html imap <silent> <tab> <plug>(EmmetExpandAbbr)
NeoBundleLazy 'itspriddle/vim-javascript-indent', {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'davidhalter/jedi-vim', {'autoload': {'filetypes': ['python']}}
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#popup_select_first = 0
  let g:jedi#completions_enabled = 0
NeoBundleLazy 'elzr/vim-json', {'autoload': {'filetypes': ['json']}}
NeoBundleLazy 'html5.vim', {'autoload': {'filetypes': ['html']}}
NeoBundleLazy 'wavded/vim-stylus', {'autoload': {'filetypes': ['stylus']}}
NeoBundleLazy 'groenewege/vim-less', {'autoload': {'filetypes': ['less']}}
NeoBundleLazy 'less.vim', {'autoload': {'filetypes': ['less']}}
NeoBundleLazy 'syntaxm4.vim', {'autoload': {'filetypes': ['m4']}}
NeoBundleLazy 'vim-scripts/jade.vim', {'autoload': {'filetypes': ['jade']}}
NeoBundleLazy 'vim-coffee-script', {'autoload': {'filetypes': ['coffee']}}
NeoBundleLazy 'rest.vim', {'autoload': {'filetypes': ['rest']}}
NeoBundleLazy 'vim-scripts/indenthaskell.vim', {'autoload': {'filetypes': ['haskell']}}
  let g:hs_highlight_boolean = 1
  let g:hs_highlight_types = 1
  let g:hs_highlight_more_types = 1
NeoBundleLazy 'tpope/vim-markdown', {'autoload': {'filetypes': ['m4']}}
NeoBundleLazy 'motemen/hatena-vim', {'autoload': {'filetypes': ['hatena']}}
NeoBundleLazy 'syngan/vim-vimlint', { 'depends' : 'ynkdir/vim-vimlparser', 'autoload' : { 'functions' : 'vimlint#vimlint'}}
endif
" }}} Bundles

" Setting {{{
filetype plugin indent on
syntax enable

" Option
try
  set list listchars=tab:▸\ ,extends:»,precedes:«,nbsp:%
catch
  set list listchars=tab:^I,extends:>,precedes:<,nbsp:%
  let g:vimfiler_tree_leaf_icon = '|'
  let g:vimfiler_tree_opened_icon = '-'
  let g:vimfiler_tree_closed_icon = '+'
endtry
set number cursorline nocursorcolumn
  autocmd Vimrc FileType vimshell,vimcalc,quickrun setlocal nonumber
  autocmd Vimrc FileType vimcalc,vimshell,quickrun,cam setlocal nocursorline
let [&t_SI,&t_EI] = ["\e]50;CursorShape=1\x7","\e]50;CursorShape=0\x7"]
set showmatch noshowmode shortmess+=I pumheight=10 completeopt-=preview autoread
set history=1000 viminfo='10,/10,:500,<10,@10,s10,n$CACHE/.viminfo spellfile=$CACHE/.spellfile.add
set nospell
  autocmd Vimrc FileType tex,markdown,help exec 'setl ' . (&bt !=# 'help' && search("[^\x01-\x7e]", 'n') == 0 && line('$') > 5 ? '' : 'no') . 'spell'
if has('conceal')
  set concealcursor=nvc
  autocmd Vimrc FileType vimfiler set concealcursor=nvc
endif
set infercase wrapscan ignorecase smartcase incsearch nohlsearch magic
set laststatus=2 showtabline=1 statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]
set background=dark
if !has('gui_running') | set t_Co=256 | endif
set encoding=utf-8 fenc=utf-8 fileencodings=utf-8,euc-jp,sjis,jis,iso-2022-jp,cp932,latin formatoptions+=mM ambiwidth=double
set smartindent autoindent shiftwidth=2
  autocmd Vimrc FileType tex,hatena setlocal nosmartindent noautoindent
  let g:tex_indent_items=0
set textwidth=0 expandtab tabstop=2 backspace=indent,eol,start nrformats-=ocral
  autocmd Vimrc FileType * exec 'setl ' . (search('^\t.*\n\t.*\n\t', 'n') > 0 ? 'no' : '') . 'expandtab'
if exists('&clipboard')
  set clipboard=unnamed
  if has('unnamedplus') | set clipboard+=unnamedplus | endif
endif
set swapfile nobackup updatetime=300 timeoutlen=500 ttyfast vb t_vb= wildignore+=*.sw?,*.bak,*.?~,*.??~,*.???~,*.~ wildmode=list:longest

" Maximize the window
if s:iswin
  autocmd Vimrc GUIEnter * simalt ~x
endif

" Move to the directory each buffer
autocmd Vimrc BufEnter * silent! lcd `=expand('%:p:h')`

" Omni completation
augroup Omnifunc
  let s:omnifunc = map(split('c;ccomplete#Complete,css;csscomplete#CompleteCSS,html;htmlcomplete#CompleteTags,javascript;javascriptcomplete#CompleteJS,php;phpcomplete#CompletePHP,xml;xmlcomplete#CompleteTags,haskell;necoghc#omnifunc,python;jedi#completions', ','), 'split(v:val, ";")')
  autocmd!
  for [s:ft, s:omnif] in s:omnifunc
    exec 'autocmd FileType ' . s:ft . ' setlocal omnifunc=' . s:omnif
  endfor
augroup END

" Explorer
exec 'nnoremap <silent> \n :<C-u>silent call system("' (s:ismac ? 'open -a Finder' : s:iswin ? 'start' : 'nautilus') '.&")<CR>'

" Text editor
function! TextEdit()
  exec 'silent call system("' (s:ismac ? 'open -a TextEdit ' : s:iswin ? 'notepad ' : 'gedit ') fnameescape(expand('%:p')) ' &")'
endfunction
nnoremap <silent> \g :<C-u>call TextEdit()<CR>

" View syntax name under cursor
command! S echo synIDattr(synID(line('.'), col('.'), 0), 'name')

" Command line
let s:cmdlist = 'vps;vsp,vp;vsp,nbi;NeoBundleInstall,nbc;NeoBundleClean,nbd;NeoBundleDocs,di;Dictionary<SPACE>-cursor-word<SPACE>-no-duplicate,aoff;AutodateOFF,aon;AutodateON,qa1;qa!,q1;q!,nvew;vnew'
for [s:cmd, s:exp] in map(split(s:cmdlist, ','), 'split(v:val, ";")')
  exec 'cabbrev <expr> '.s:cmd.' (getcmdtype() == ":" && getcmdline() ==# "'.s:cmd.'") ? "'.s:exp.'" : "'.s:cmd.'"'
endfor

" Filetype
augroup SetLocalFiletype
  let s:filetypes1 = map(split('bf,gnuplot,jade,json,less,r,roy,tex,meissa,coffee,stl', ','), '[v:val, v:val]')
  let s:filetypes2 = map(split('cls;tex,hs;haskell,hx;haxe,md;markdown,cir;spice,asc;spice,m;objc', ','), 'split(v:val, ";")')
  autocmd!
  for [s:ex, s:ft] in extend(s:filetypes1, s:filetypes2)
    execute 'autocmd BufNewFile,BufReadPost *.' . s:ex . ' setlocal filetype=' . s:ft
  endfor
  autocmd Vimrc CursorHold,CursorHoldI * call s:auto_filetype()
augroup END
function! s:auto_filetype()
  if line('.') > 5 | return | endif
  let newft = ''
  for [pat, ft] in map(split('*[;hatena,#include;c,\documentclass;tex,import;haskell,main =;haskell,diff --;diff,{ ;vim', ','), 'split(v:val, ";")')
    if getline(1)[:strlen(pat) - 1] ==# pat | let newft = ft | endif
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
nnoremap ,d :<C-u>diffthis<CR>

" save
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>

" search
autocmd Vimrc BufEnter,WinEnter * nnoremap <buffer> <Esc><Esc> :<C-u>set nohlsearch nopaste<CR>
autocmd Vimrc BufEnter,WinEnter [calendar* nunmap <buffer> <Esc><Esc>
nnoremap <silent> / :<C-u>set hlsearch<CR>/
nnoremap <silent> ? :<C-u>set hlsearch<CR>?
nnoremap <silent> * :<C-u>set hlsearch<CR>*
nnoremap <silent> # :<C-u>set hlsearch<CR>#

" navigate window
for s:k in ['h', 'j', 'k', 'l', 'x']
  let s:l = s:k == 'j' ? 'm' : s:k
  if s:l == s:k && s:k != 'x' | exec 'inoremap <C-' . s:l . '> <ESC><C-w>' . s:k | endif
  exec 'nnoremap <C-' . s:l . '> <C-w>' . s:k
  exec 'vnoremap <C-' . s:l . '> <C-w>' . s:k
  exec 'nnoremap <C-' . s:k . '> <C-w>' . s:k
  exec 'vnoremap <C-' . s:k . '> <C-w>' . s:k
endfor
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]') ? "<CR>" : "<C-w>j"
inoremap <C-q> <ESC><C-w>
nnoremap <C-q> <C-w>
vnoremap <C-q> <ESC><C-w>

" Open dot files
exec 'nnoremap \. :e ~/' . (filereadable(expand('~/Dropbox/.files/.vimrc')) ? 'Dropbox/.files/' : '') . '.vimrc<CR>'
exec 'nnoremap ;. :e ~/' . (filereadable(expand('~/Dropbox/.files/.zshrc')) ? 'Dropbox/.files/' : '') . '.zshrc<CR>'

" tag
autocmd Vimrc FileType help nnoremap <C-[> <C-t>

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
" }}} KEY MAPPING

" vim:foldmethod=marker
