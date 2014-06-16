# ------------------------------------------------------------------------------------------------------------
# - * File: .zshrc
# - * Author: itchyny
# - * Last Change: 2014/06/16 18:50:06.
# ------------------------------------------------------------------------------------------------------------

# config path
if [ -d ~/Dropbox/.files/ ]; then
  ZSH_CONFIG_PATH=~/Dropbox/.files/
elif [ -d ~/.files/ ]; then
  ZSH_CONFIG_PATH=~/.files/
elif [ -d ~/.zsh/ ]; then
  ZSH_CONFIG_PATH=~/.zsh/
else
  ZSH_CONFIG_PATH=~/zsh/
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
function _zsh_git_branch {
  local name gitstatus color
  name=$(basename "$(git symbolic-ref HEAD 2> /dev/null)")
  if [[ -z $name ]]; then
    return
  fi
  gitstatus=$(git status 2> /dev/null)
  if [[ -n $(echo "$gitstatus" | grep "^nothing to") ]]; then
    color=${fg[cyan]}
  elif [[ -n $(echo "$gitstatus" | grep "^nothing added") ]]; then
    color=${fg[yellow]}
  else
    color=${fg[magenta]}
  fi
  echo " %{$color%}[$name]%{$reset_color%}"
}
if (($+VIM)); then
  PROMPT="%~ "
  PROMPT2="%_> "
  SPROMPT="%r is correct? [n,y,a,e]: "
else
  PROMPT="%(?.%{$fg[green]%}.%{$fg[blue]%})%B%~%b"'$(_zsh_git_branch)'"%{${reset_color}%} "
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
fignore=(.o .dvi .aux .log .toc .hi - \~)
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
export PATH=$PATH:/Applications/Xcode.app/Contents/Developer/usr/bin/
export PATH=$PATH:/usr/local/bin/
export PATH=$PATH:/usr/local/git/bin/
export PATH=$PATH:/opt/local/bin/
export PATH=$PATH:~/.cabal/bin/
export PATH=$PATH:/usr/local/usr/local/bin/
export PATH=~/Dropbox/bin/:$PATH
export PATH=$PATH:~/Library/Haskell/bin/

# function
function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d "$1" ]; then
    echo "\`$1' already exists"
  else
    mkdir "$1" && cd "$1"
  fi
}

function pcolor() {
  for ((f = 0; f < 256; f++)); do
    printf "\e[38;5;%dm %3d\e[m" $f $f
    if [[ $f -ge 16 ]]; then
      if [[ $f%6 -eq 3 ]]; then
        printf "\n"
      fi
    else
      if [[ $f%8 -eq 7 ]]; then
        printf "\n"
      fi
    fi
  done
  echo
}

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
  if (($+VIM)); then
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
alias cabal-update='sudo cabal update && sudo cabal install cabal-install'
if [ "$(uname)" = "Darwin" ]; then
  alias google-chrome='open -a Google\ Chrome'
  alias evince='open -a Preview'
  alias display='open -a Preview'
  alias eog='open -a Preview'
  alias port-update='sudo port selfupdate && sudo port upgrade outdated'
  alias update='cabal-update && port-update'
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
alias :q='exit'
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
# rlwrap
which gosh > /dev/null && alias gosh='rlwrap gosh'
which coqtop > /dev/null && alias coqtop='rlwrap coqtop'
# others
which pygmentize > /dev/null && alias ccat='pygmentize'
which cam > /dev/null && alias slideshow='cam -q -C -s 1'
[ -e ~/Dropbox/py/itchyny/tweet.py ] && \
  alias tweet='python ~/Dropbox/py/itchyny/tweet.py'
[ -e ~/Dropbox/hs/twitter/twitter.hs ] && \
  alias twitter='rlwrap runhaskell ~/Dropbox/hs/twitter/twitter.hs'
alias ntpupdate='sudo /usr/sbin/ntpdate time.asia.apple.com >> ~/.ntpdate.log'
[ -e ~/Dropbox/py/itchyny/yoruho.py ] && \
  alias yoruho='sudo /usr/sbin/ntpdate time.asia.apple.com >> ~/.ntpdate.log && python ~/Dropbox/py/itchyny/yoruho.py' && \
  alias y='yoruho'
[ -e ~/Dropbox/js/roy/roy ] && \
  alias roy='~/Dropbox/js/roy/roy'
[ -e ~/Dropbox/univ/ ] && \
  alias univ='cd ~/Dropbox/univ/'
case "${OSTYPE}" in
  freebsd*|darwin*)
    if (($+VIM)); then
      alias ll='ls -altr'
    else
      alias ls='ls -wG'
      alias ll='ls -altrwG'
    fi
    export os='mac'
    ;;
  *)
    if (($+VIM)); then
      alias ll='ls -altr'
    else
      alias ls='ls --color'
      alias ll='ls -altr --color'
    fi
    export os='ubuntu'
    ;;
esac
function configurevim() {
  local save_path
  save_path="$(pwd)"
  cd ~/Dropbox/cpp/vim/vim-$os/
  rm -f src/auto/config.cache
  if which lua > /dev/null; then
    CFLAGS="-O3" ./configure --with-features=huge\
                --with-compiledby=itchyny\
                --enable-pythoninterp=yes\
                --with-lua-prefix="$(dirname $(which lua))"\
                --enable-luainterp=yes\
                --enable-multibyte
  else
    CFLAGS="-O3" ./configure --with-features=huge\
                --with-compiledby=itchyny\
                --enable-pythoninterp=yes\
                --enable-multibyte
  fi
  cd "$save_path"
}
function makevim() {
  local save_path
  save_path="$(pwd)"
  cd ~/Dropbox/cpp/vim/vim-$os/
  hg pull
  hg update
  make
  ver=$(vim --version | head -n 1 | sed -e 's/.*\([0-9][0-9]*\.[0-9][0-9]*\).*/\1/')
  ver=$ver.$(vim --version | head -n 3 | tail -n 2 | tr -d '\n' | sed -e 's/.*-\([0-9][0-9]*\).*/\1/')
  cp -n "$(which vim)" "~/Dropbox/cpp/vim/backup/vim-$os/vim@$ver"
  sudo make install
  cd "$save_path"
}
function makenvim() {
  cd ~/Dropbox/cpp/vim/neovim/
  git pull
  make
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

function download {
  if [[ $1 =~ .*asx$ ]]; then
    URL=$(curl -s "$1" | grep -i HREF | sed 's/.*="\(.*\)".*/\1/')
    FILENAME=$(echo "$URL" | sed 's/.*\/\/\([a-z:0-9.\-]*\/\)*//' | sed 's/wsx/wmv/')
    mplayer "$URL" -dumpstream -dumpfile "$FILENAME"
  elif [[ $1 =~ .*nicovideo.* ]]; then
    nicovideo-dl -n -t "$1"
  elif [[ $1 =~ .*youtube.* ]]; then
    youtube-dl "$1"
  elif [[ $1 =~ .*github.* ]]; then
    git clone "$1"
  else
    wget --no-check-certificate "$1"
  fi
}

# http://blog.kamipo.net/entry/2013/02/20/122225
function http {
  if python -V 2>&1 | grep -qm1 'Python 3\.'; then
    python -m http.server 8000
  elif which python > /dev/null; then
    python -m SimpleHTTPServer 8000
  elif which ruby > /dev/null; then
    ruby -rwebrick -e 'WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => ".").start'
  elif which plackup > /dev/null; then
    plackup -MPlack::App::Directory -e 'Plack::App::Directory->new(root => ".")->to_app'
  elif which php > /dev/null && php -v | grep -qm1 'PHP 5\.[45]\.'; then
    php -S 0.0.0.0:8000
  elif which erl > /dev/null; then
    erl -eval 'inets:start(), inets:start(httpd, [{server_name, "httpd"}, {server_root, "."}, {document_root, "."}, {port, 8000}])'
  fi
}

# http://mimosa-pudica.net/zsh-incremental.html
[ -e $ZSH_CONFIG_PATH/incr-0.2.zsh ] && \
  source $ZSH_CONFIG_PATH/incr-0.2.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting
[ -e $ZSH_CONFIG_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
  source $ZSH_CONFIG_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-history-substring-search
[ -e $ZSH_CONFIG_PATH/zsh-history-substring-search/zsh-history-substring-search.zsh  ] && \
  source $ZSH_CONFIG_PATH/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# https://github.com/nakamuray/zaw
[ -e $ZSH_CONFIG_PATH/zaw/zaw.zsh ] && \
  source $ZSH_CONFIG_PATH/zaw/zaw.zsh && \
  bindkey '^z' zaw-history

[ -e ./Dropbox ] && cd ./Dropbox > /dev/null

