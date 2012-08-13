# --------------------------------------------------------------------------------------------------------------
# - * File: .zshrc
# - * Author: itchyny
# - * Last Change: 2012/08/13 15:44:28.
# --------------------------------------------------------------------------------------------------------------

# initialize
setopt prompt_subst
setopt no_check_jobs

# history
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_verify
setopt share_history

# color (check: where color)
autoload -Uz colors; colors
LS_COLORS='di=01;36:ln=01;35:ex=01;31:'
LS_COLORS+='*.c=01;35:*.cpp=01;35:*.js=01;35:*.json=01;35:*.hs=01;35:*.py=01;35:*.pl=01;35:'
LS_COLORS+='*.tex=01;35:*.csv=01;35:*.r=01;35:*.R=01;35:*.txt=01;35:*.sty=01;35:*.coffee=01;35:*.class=01;35:*.java=01;35:*.less=01;35:*.css=01;35:'
LS_COLORS+='*.jpg=01;33:*.png=01;33:*.bmp=01;33:*.JPG=01;33:*.PNG=01;33:*.BMP=01;33:'
LS_COLORS+='*.gz=01;34:*.tar=01;34:*.zip=01;34:'
LS_COLORS+='*.pdf=01;32:*makefile=01;32:*.html=01;32:'
export LS_COLORS # doesn't work in Mac
export LSCOLORS=gxfxcxdxbxegedabagacad
export TERM=xterm-256color

# prompt
PROMPT="%(?.%{$fg[green]%}.%{$fg[blue]%})%B%~$%b%{${reset_color}%} "
PROMPT2="%{$bg[blue]%}%_>%{$reset_color%}%b "
SPROMPT="%{$bg[red]%}%B%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%{$bg[red]%}${HOST%%.*}${PROMPT}%{${reset_color}%}"
alias prompt_kadai='PROMPT=" $ "'
case "${TERM}" in
  kterm*|xterm)
  precmd() {
    echo -ne "\033]0;${USER}@${PWD}\007"
  };;
esac

# complement (use incr-0.2.zsh but rewrite 6 to 100 in limit-completion)
autoload -Uz compinit; compinit
LISTMAX=1000000
fignore=(.o .dvi .aux .log .toc - \~)
setopt auto_list
setopt auto_menu
setopt auto_param_keys
setopt auto_param_slash
setopt auto_pushd
setopt mark_dirs
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# beep
setopt no_beep
setopt nolistbeep

# appearance
setopt print_eight_bit
setopt list_packed
setopt correct
[ -e /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found

# operation
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
setopt auto_cd
setopt no_flow_control

# export variables
export LANG=ja_JP.UTF-8
export EDITOR=vim

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

# function
function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

function pcolor() {
  for ((f = 0; f < 255; f++)); do
    printf "\e[38;5;%dm %3d#\e[m" $f $f
    if [[ $f%8 -eq 7 ]] then
      printf "\n"
    fi
  done
  echo
}

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

# cd with ls
function chpwd() { ls }

# for vim's C-s
stty -ixon -ixoff

# alias
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
which cam > /dev/null && alias slideshow="cam -e -c -s 1"

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
# see ambiwidth in .vimrc
alias gnome-terminal='/bin/sh -c "VTE_CJK_WIDTH=1 gnome-terminal --disable-factory"'
alias terminator='/bin/sh -c "VTE_CJK_WIDTH=1 terminator --disable-factory"'

# http://mimosa-pudica.net/zsh-incremental.html
[ -e ~/Dropbox/dotfiles/incr-0.2.zsh ] \
  && source ~/Dropbox/dotfiles/incr-0.2.zsh

# https://github.com/zsh-users/zsh-history-substring-search
[ -e ~/Dropbox/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
  && source ~/Dropbox/dotfiles/zsh-history-substring-search/zsh-history-substring-search.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting
[ -e ~/Dropbox/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] \
  && source ~/Dropbox/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -e ~/Dropbox ] && cd ~/Dropbox > /dev/null

