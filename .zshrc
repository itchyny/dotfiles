# --------------------------------------------------------------------------------------------------------------
# - * File: .zshrc
# - * Author: itchyny
# - * Last Change: 2012/08/05 01:15:31.
# --------------------------------------------------------------------------------------------------------------

setopt prompt_subst
export LANG=ja_JP.UTF-8

# history
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt extended_history
# 直前と同じコマンドラインはヒストリに追加しない
setopt hist_ignore_dups
# ヒストリにhistoryコマンドを記録しない
setopt hist_no_store
# 余分なスペースを削除してヒストリに記録する
setopt hist_reduce_blanks
# 行頭がスペースで始まるコマンドラインはヒストリに記録しない
# setopt hist_ignore_spece
# 重複したヒストリは追加しない
# setopt hist_ignore_all_dups
# ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt hist_verify
# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history


# color
autoload -Uz colors; colors
# check colors with commant $ where color
PROMPT="%(?.%{$bg[green]%}.%{$bg[blue]%})%(?!(._.)/!(;_;%)?) %B%~$%b%{${reset_color}%} "
PROMPT="%(?.%{$fg[green]%}.%{$fg[blue]%})%B%~$%b%{${reset_color}%} "
PROMPT2="%{$bg[blue]%}%_>%{$reset_color%}%b "
SPROMPT="%{$bg[red]%}(._.%)? %B %r is correct? [n,y,a,e]:%{${reset_color}%}%b "
SPROMPT="%{$bg[red]%}%B%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%{$bg[red]%}${HOST%%.*}${PROMPT}%{${reset_color}%}"
LS_COLORS='di=01;36:ln=01;35:ex=01;31:'
LS_COLORS+='*.c=01;35:*.cpp=01;35:*.js=01;35:*.json=01;35:*.hs=01;35:*.py=01;35:*.pl=01;35:'
LS_COLORS+='*.tex=01;35:*.csv=01;35:*.r=01;35:*.R=01;35:*.txt=01;35:*.sty=01;35:*.coffee=01;35:*.class=01;35:*.java=01;35:*.less=01;35:*.css=01;35:'
LS_COLORS+='*.jpg=01;33:*.png=01;33:*.bmp=01;33:*.JPG=01;33:*.PNG=01;33:*.BMP=01;33:'
LS_COLORS+='*.gz=01;34:*.tar=01;34:*.zip=01;34:'
LS_COLORS+='*.pdf=01;32:*makefile=01;32:*.html=01;32:'
export LS_COLORS     # doesn't work in Mac
# export LSCOLORS=aahfcxdxbxegedabagaad
export LSCOLORS=gxfxcxdxbxegedabagacad
export TERM=xterm-256color
alias prompt_kadai='PROMPT=" $ "'
# title of terminal
case "${TERM}" in
  kterm*|xterm)
  precmd() {
# echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
echo -ne "\033]0;${USER}@${PWD}\007"
  }
  ;;
esac

# enable complement
autoload -Uz compinit; compinit
# even if in sudo
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
# store the directory foreach cd, and show complement directories with cd -<TAB>
setopt auto_pushd
# complement for variable names
setopt auto_param_keys
# 補完するかの質問は画面を超える時にのみに行う｡
LISTMAX=0
# 補完候補が複数ある時に、一覧表示
setopt auto_list
# 補完時に無視するファイルの種類
fignore=(.o .dvi .aux .log .toc - \~)
# # 補完キー（Tab, Ctrl+I) を連打するだけで順に補完候補を自動で補完
# setopt auto_menu
# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# setopt noautoremoveslash
# use arrow keys to select from complement list
# zstyle ':completion:*:default' menu select true

# # colorize list as ls color
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示しない
# setopt list_types
# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
# setopt magic_equal_subst
# zmodload zsh/complist
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'j' vi-down-line-or-history
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# autoload -Uz history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^P" history-beginning-search-backward-end
# bindkey "^N" history-beginning-search-forward-end

# #
# case-insensitive,partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# case-insensitive (all) completion
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# case-insensitive (uppercase from lowercase) completion
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'


# do not beep
setopt no_beep
setopt nolistbeep

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs

# 8 ビット目を通すようになり、日本語のファイル名を表示可能
setopt print_eight_bit

# シェルのプロセスごとに履歴を共有
setopt share_history

# Ctrl+wで､直前の/までを削除する｡
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# change directory with only directory name, without cd
setopt auto_cd

# C-s, C-qを無効にする。
setopt no_flow_control

# editor
export EDITOR=vim

# display compact suggestion
setopt list_packed

# suggest correct to aboid "command not found"
setopt correct

# when command was not found, suggest installation like bash in Ubuntu
[ -e /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found

# vim mode
# bindkey -v

function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

# checker for colors for .zshrc
function pcolor() {
  for ((f = 0; f < 255; f++)); do
    printf "\e[38;5;%dm %3d#\e[m" $f $f
    if [[ $f%8 -eq 7 ]] then
      printf "\n"
    fi
  done
  echo
}

# 予測
# autoload -U predict-on
# zle -N predict-on
# zle -N predict-off
# bindkey '^xp' predict-on
# bindkey '^x^p' predict-off
# zstyle ':predict' verbose true

# path settings
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man
export PATH=$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin/
export PATH=$PATH:/usr/local/bin/
export PATH=$PATH:/usr/local/git/bin/
export PATH=$PATH:/opt/local/bin/
export PATH=$PATH:~/.cabal/bin/
export PATH=$PATH:~/Dropbox/bin/
export PATH=$PATH:~/Dropbox/js/coffee-script/bin/
export PATH=$PATH:~/Dropbox/js/jison/bin/
export PATH=$PATH:~/Dropbox/js/narwhal/bin/
export PATH=$PATH:~/Dropbox/js/roy/
export PATH=$PATH:~/Library/Haskell/bin/
export PATH=$PATH:~/node_modules/jade/bin/
export PATH=$PATH:~/node_modules/less/bin/
export PATH=$PATH:~/node_modules/node-dev/
export PATH=$PATH:~/node_modules/nodester-cli/bin/
export PATH=$PATH:~/node_modules/stylus/bin/

# export http_proxy=http://proxy.kuins.net:8080/

# go to ../ with key ^
function cdup() {
  echo
  cd ..
  zle reset-prompt
}
zle -N cdup
bindkey '\^' cdup

function starteditor() {
  exec < /dev/tty
  ${EDITOR}
  zle reset-prompt
}
zle -N starteditor
bindkey '\@' starteditor

# Google it within w3m
function google() {
  local str opt
  if [ $# != 0 ]; then
    for i in $*; do
      str="$str+$i"
    done
    str=`echo $str | sed 's/^\+//'`
    opt='search?num=50&hl=ja&ie=utf-8&oe=utf-8&lr=lang_ja'
    opt="${opt}&q=${str}"
  fi
  w3m http://www.google.co.jp/$opt
}

# for vim's C-s
stty -ixon -ixoff

# alias settings
# for Mac
alias cabal-update='sudo cabal update && sudo cabal install cabal-install && sudo cabal update'
if [ `uname` = "Darwin" ]; then
  alias google-chrome='open -a Google\ Chrome'
  alias evince='open -a Preview'
  alias display='open -a Preview'
  alias eog='open -a Preview'
  alias port-update='sudo port selfupdate && sudo port upgrade outdated'
  alias update='cabal-update && port-update'
  pman () {
    man -t $@ | open -f -a /Applications/Preview.app
  }
elif [ `uname` = "Linux" ]; then
  alias apt-get-update='sudo apt-get update'
  alias update='cabal-update && apt-get-update'
  alias open='gnome-open'
  alias pbcopy='xsel --clipboard --input'
  # alias pbcopy='xsel -i -b'
  # alias pbpaste='xsel -o -b'
fi
alias chrome='google-chrome'
alias gosh='rlwrap gosh'
alias coqtop='rlwrap coqtop'
alias v='vim'
alias vi='vim'
alias hs='cd ~/Dropbox/hs/'
alias js='cd ~/Dropbox/js/'
alias univ='cd ~/Dropbox/univ/'
alias port='/usr/bin/env port'
alias :q='exit'
alias :qa='exit'
alias :x='exit'
alias :xa='exit'
alias h='sudo shutdown -h'
alias r='sudo shutdown -r'
alias l='ls -al'
alias mpg123='mpg123 -zC'
function runcpp () { g++ $1; ./a.out; }
alias asm=runcpp
alias mplayer='mplayer -lavdopts threads=2 -loop 0 -shuffle'
alias mp3='mplayer'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias emacs='vi'
alias ccat='pygmentize'
alias crontab="EDITOR=\"$HOME/bin/vi\" crontab"
alias tweet='python ~/Dropbox/py/itchyny/tweet.py'
alias twitter='rlwrap runhaskell ~/Dropbox/hs/twitter/twitter.hs'
alias ntpupdate='sudo /usr/sbin/ntpdate time.asia.apple.com >> ~/.ntpdate.log'
alias yoruho='sudo /usr/sbin/ntpdate time.asia.apple.com >> ~/.ntpdate.log && python ~/Dropbox/py/itchyny/yoruho.py'
alias roy='~/Dropbox/js/roy/roy'
alias c='clear'
alias d='date'
which cam > /dev/null && alias slideshow="cam -e -c -s 2"

case "${OSTYPE}" in
  freebsd*|darwin*)
    alias ls="ls -wG"
    alias ll='ls -altrwG'
    ;;
  *)
    alias ls="ls --color"
    alias ll='ls -altr --color'
    ;;
esac

# cd をしたときにlsを実行する
function chpwd() { ls }

# suffix alias according to file extension
alias -s txt=cat
alias -s tex=vi
alias -s csv=vi
alias -s js=vi
alias -s css=vi
alias -s less=vi
alias -s html=chrome
alias -s pdf=evince
alias -s png=eog
alias -s jpg=eog
alias -s bmp=eog
alias -s PNG=eog
alias -s JPG=eog
alias -s BMP=eog
alias -s mp3=mplayer
alias -s wav=mplayer
alias -s cpp=runcpp
alias -s c=runcpp
alias -s py=python
alias -s hs=runhaskell
alias -s s=runcpp

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -dc $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

alias fg='fg || if [ $? -eq 1 ]; then; vi; fi;'

# .vimrcのambiwidthを参照してください
alias gnome-terminal='/bin/sh -c "VTE_CJK_WIDTH=1 gnome-terminal --disable-factory"'
alias terminator='/bin/sh -c "VTE_CJK_WIDTH=1 terminator --disable-factory"'

[ -e ~/Dropbox ] && cd ~/Dropbox > /dev/null

# http://mimosa-pudica.net/zsh-incremental.html
[ -e ~/Dropbox/dotfiles/incr-0.2.zsh ] \
  && source ~/Dropbox/dotfiles/incr-0.2.zsh

# git://github.com/zsh-users/zsh-history-substring-search.git
[ -e ~/Dropbox/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
  && source ~/Dropbox/dotfiles/zsh-history-substring-search/zsh-history-substring-search.zsh

# git://github.com/zsh-users/zsh-syntax-highlighting.git
[ -e ~/Dropbox/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
  && source ~/Dropbox/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


