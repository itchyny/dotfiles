# ------------------------------------------------------------------------------------------------------------
# - * File: .zshrc
# - * Author: itchyny
# - * Last Change: 2014/10/21 14:21:30.
# ------------------------------------------------------------------------------------------------------------

# config path
if [ -d ~/Dropbox/.files ]; then
  ZSH_CONFIG_PATH=~/Dropbox/.files
elif [ -d ~/.files ]; then
  ZSH_CONFIG_PATH=~/.files
else
  ZSH_CONFIG_PATH=~/.zsh
fi
if ! [ -d $ZSH_CONFIG_PATH ]; then
  mkdir -p $ZSH_CONFIG_PATH
fi

# history
HISTFILE=$ZSH_CONFIG_PATH/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_ignore_space
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
setopt prompt_subst
setopt interactive_comments
if test "$VIM"; then
  PROMPT="%~ "
  PROMPT2="%_> "
  SPROMPT="%r is correct? [n,y,a,e]: "
else
  PROMPT="%(?.%{$fg[green]%}.%{$fg[blue]%})%B%~%b%{${reset_color}%} "
  PROMPT2="%{$bg[blue]%}%_>%{$reset_color%}%b "
  SPROMPT="%{$bg[red]%}%B%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
fi
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
fignore=(.o .dvi .aux .log .toc .hi .swp .sw .bak .bbl .blg .nav .snm .toc .pyc)
setopt auto_list
setopt auto_menu
setopt auto_param_keys
setopt auto_param_slash
setopt auto_pushd
setopt mark_dirs
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# beep
setopt no_beep
setopt nolistbeep

# appearance
setopt no_check_jobs
setopt print_eight_bit
setopt list_packed
setopt correct
[ -e /etc/zsh_command_not_found ] && source /etc/zsh_command_not_found

# operation
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
setopt auto_cd
setopt no_flow_control

# integrate vim mode
bindkey -v
bindkey "^K" kill-whole-line
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^D" delete-char
bindkey "^F" forward-char
bindkey "^B" backward-char

# export variables
export LANG=ja_JP.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR=vim

# path settings
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man
export PATH=$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/git/bin
export PATH=$PATH:/opt/local/bin
export PATH=$PATH:~/.cabal/bin
export PATH=$PATH:/usr/local/usr/local/bin
export PATH=~/.bin:$PATH
export PATH=~/bin:$PATH
export PATH=~/Dropbox/.bin:$PATH
export PATH=~/Dropbox/bin:$PATH
export PATH=$PATH:~/Library/Haskell/bin
export PATH=$PATH:/usr/local/Cellar/vim/HEAD/bin
export PATH=$PATH:/usr/texbin

# function
function starteditor() {
  exec < /dev/tty
  ${EDITOR}
  zle reset-prompt
}
zle -N starteditor
bindkey '^@' starteditor
bindkey '^\^' starteditor

# cd with ls
function chpwd() {
  if test "$VIM"; then
    ls
  else
    case "${OSTYPE}" in
      freebsd*|darwin*)
        ls -wG
        ;;
      *)
        ls --color
        ;;
    esac
  fi
}

# for vim's C-s
stty -ixon -ixoff

# alias
alias ..="cd ../"
alias cabal-update='sudo cabal update && sudo cabal install cabal-install'
if [ "$(uname)" = "Darwin" ]; then
  alias google-chrome='open -a Google\ Chrome'
  alias evince='open -a Preview'
  alias display='open -a Preview'
  alias eog='open -a Preview'
  alias port-update='sudo port selfupdate && sudo port upgrade outdated'
  alias brew-update='brew update; brew upgrade'
  alias update='cabal-update && brew-update'
  pman () {
    man -t "$1" | open -f -a /Applications/Preview.app
  }
elif [ "$(uname)" = "Linux" ]; then
  alias apt-get-update='sudo apt-get update'
  alias update='cabal-update && apt-get-update'
  alias open='gnome-open'
  alias pbcopy='xsel --clipboard --input'
fi
alias chrome='google-chrome'
function runc () {
  gcc -O3 "$1" && shift && ./a.out "$@"; rm -f ./a.out
}
function runcpp () {
  g++ -O3 "$1" && shift && ./a.out "$@"; rm -f ./a.out
}
alias asm=runcpp
# editor
alias vi='vim'
alias q='exit'
alias qq='exit'
alias qqq='exit'
alias :q='exit'
alias :quit='exit'
alias ::q='exit'
alias :qa='exit'
alias :x='exit'
alias :xa='exit'
alias emacs='vi'
alias fg='fg || vi'
# see ambiwidth in .vimrc
alias gnome-terminal='/bin/sh -c "VTE_CJK_WIDTH=1 gnome-terminal --disable-factory"'
alias terminator='/bin/sh -c "VTE_CJK_WIDTH=1 terminator -m"'
# one alphabet
alias v='vim'
alias h='sudo shutdown -h'
alias r='sudo shutdown -r'
alias l='ls -al'
alias c='clear'
alias z='zsh'
alias d='download'
# default option
alias mpg123='mpg123 -zC'
alias mplayer='mplayer -subdelay 100000 -fs -geometry 50%:50%'
alias music='mplayer -lavdopts threads=2 -loop 0 -shuffle -geometry 50%:50% -volume 5'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias crontab="EDITOR=\"$HOME/Dropbox/bin/vi\" crontab"
alias wget="wget --user-agent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36' "
alias aspell="aspell -c -l en_US"
alias nicovideo-dl="nicovideo-dl -n -t"
# git
alias am='git commit -am --color'
alias gd='git diff --color'
alias gp='git push --color'
# un*
alias ungzip='gzip -d'
alias untar='tar xvf'
# others
if command -v htop > /dev/null 2>&1; then
  alias top='htop'
fi
which cam > /dev/null && alias slideshow='cam -q -C -s 1'
[ -e ~/Dropbox/py/itchyny/tweet.py ] && \
  alias tweet='python ~/Dropbox/py/itchyny/tweet.py'
[ -e ~/Dropbox/hs/twitter/twitter.hs ] && \
  alias twitter='rlwrap runhaskell ~/Dropbox/hs/twitter/twitter.hs'
alias ntpupdate='sudo /usr/sbin/ntpdate time.asia.apple.com >> ~/.ntpdate.log'
[ -e ~/Dropbox/js/roy/roy ] && \
  alias roy='~/Dropbox/js/roy/roy'
[ -e ~/Dropbox/univ/ ] && \
  alias univ='cd ~/Dropbox/univ/'
case "${OSTYPE}" in
  freebsd*|darwin*)
    if test "$VIM"; then
      alias ll='ls -altr'
    else
      alias ls='ls -wG'
      alias ll='ls -altrwG'
    fi
    export os='mac'
    ;;
  *)
    if test "$VIM"; then
      alias ll='ls -altr'
    else
      alias ls='ls --color'
      alias ll='ls -altr --color'
    fi
    export os='ubuntu'
    ;;
esac
function pullvim() {
  if command -v brew > /dev/null 2>&1; then
    return
  fi
  if ! [[ -d ~/downloads ]]; then
    mkdir -p ~/downloads
  fi
  cd ~/downloads > /dev/null
  if [[ -d ./vim/.hg ]]; then
    cd ./vim > /dev/null
    hg pull
    hg update
  else
    hg clone https://code.google.com/p/vim/ ./vim
  fi
}
function configurevim() {
  if command -v brew > /dev/null 2>&1; then
    return
  fi
  local save_path
  save_path="$(pwd)"
  if ! [[ -d ~/downloads/vim/.hg ]]; then
    pullvim
  fi
  cd ~/downloads/vim > /dev/null
  rm -f src/auto/config.cache
  if which lua > /dev/null; then
    CFLAGS="-O3" ./configure --with-features=huge\
                --with-compiledby=itchyny\
                --enable-pythoninterp=yes\
                --with-lua-prefix="$(dirname "$(which lua)")"\
                --enable-luainterp=yes\
                --enable-multibyte
  else
    CFLAGS="-O3" ./configure --with-features=huge\
                --with-compiledby=itchyny\
                --enable-pythoninterp=yes\
                --enable-multibyte
  fi
  cd "$save_path" > /dev/null
}
function makevim() {
  if command -v brew > /dev/null 2>&1; then
    if brew list vim > /dev/null 2>&1; then
      brew update; brew rm vim
    fi
    brew install vim --with-perl --with-lua --with-luajit --with-python --HEAD --override-system-vi
  else
    local save_path
    save_path="$(pwd)"
    pullvim
    configurevim
    make
    sudo make install
    cd "$save_path" > /dev/null
  fi
}

# suffix alias according to file extension
alias -s txt=cat
alias -s {csv,js,css,less,md}=vi
alias -s tex=autolatex
alias -s html=chrome
alias -s pdf=evince
alias -s {png,jpg,bmp,PNG,JPG,BMP}=eog
alias -s {mp3,wav}=mplayer
alias -s c=runc
alias -s cpp=runcpp
alias -s py=python
alias -s hs=runhaskell
alias -s s=runcpp
alias -s sh=sh

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf "$1";;
    *.tar.xz) tar Jxvf "$1";;
    *.zip) unzip "$1";;
    *.lzh) lha e "$1";;
    *.tar.bz2|*.tbz) tar xjvf "$1";;
    *.tar.Z) tar zxvf "$1";;
    *.gz) gzip -d "$1";;
    *.bz2) bzip2 -dc "$1";;
    *.Z) uncompress "$1";;
    *.tar) tar xvf "$1";;
    *.arj) unarj "$1";;
  esac
}
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

# http://mimosa-pudica.net/zsh-incremental.html
if [ -e $ZSH_CONFIG_PATH/incr-0.2.zsh ]; then
  source $ZSH_CONFIG_PATH/incr-0.2.zsh
elif command -v curl > /dev/null 2>&1; then
  curl -R http://mimosa-pudica.net/src/incr-0.2.zsh -o $ZSH_CONFIG_PATH/incr-0.2.zsh
fi

# https://github.com/zsh-users/zsh-syntax-highlighting
if [ -e $ZSH_CONFIG_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source $ZSH_CONFIG_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif command -v git > /dev/null 2>&1; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CONFIG_PATH/zsh-syntax-highlighting
fi

# https://github.com/zsh-users/zsh-history-substring-search
if [ -e $ZSH_CONFIG_PATH/zsh-history-substring-search/zsh-history-substring-search.zsh  ]; then
  source $ZSH_CONFIG_PATH/zsh-history-substring-search/zsh-history-substring-search.zsh
elif command -v git > /dev/null 2>&1; then
  git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_CONFIG_PATH/zsh-history-substring-search
fi
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# https://github.com/nakamuray/zaw
if [ -e $ZSH_CONFIG_PATH/zaw/zaw.zsh ]; then
  source $ZSH_CONFIG_PATH/zaw/zaw.zsh
  bindkey '^z' zaw-history
elif command -v git > /dev/null 2>&1; then
  git clone https://github.com/nakamuray/zaw $ZSH_CONFIG_PATH/zaw
fi

[ -e ./Dropbox ] && cd ./Dropbox > /dev/null

