# ------------------------------------------------------------------------------------------------------------
# - * File: .zshrc
# - * Author: itchyny
# - * Last Change: 2019/05/15 16:54:08.
# ------------------------------------------------------------------------------------------------------------

ZDOTDIR=$HOME/.zsh

# history
HISTFILE=~/.files/.histfile
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

# color
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

# colorize stderr output in red
zmodload zsh/terminfo zsh/system
color_stderr() {
  while sysread std_err_color; do
    syswrite -o 2 "${fg_bold[red]}${std_err_color}${terminfo[sgr0]}"
  done
}
exec 2> >(color_stderr)

# prompt
setopt prompt_subst
setopt interactive_comments
PROMPT="%(?.%{$fg[green]%}.%{$fg[blue]%})%B%~%b%{${reset_color}%} "
PROMPT2="%{$bg[blue]%}%_>%{$reset_color%}%b "
RPROMPT=$'$(git-branch-name 2>/dev/null)'
SPROMPT="%{$bg[red]%}%B%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="%{$bg[red]%}${HOST%%.*}${PROMPT}%{${reset_color}%}"
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
precmd() {
  stty sane
}

# completion
autoload -Uz compinit
if [[ $(date +'%j') != $(stat -f '%Sm' -t '%j' $ZDOTDIR/.zcompdump 2>/dev/null) ]]; then compinit; else compinit -C; fi
LISTMAX=500
fignore=(.o .dvi .aux .log .toc .hi .swp .sw .bak .bbl .blg .nav .snm .toc .pyc)
setopt auto_list auto_menu list_packed auto_param_keys auto_param_slash mark_dirs
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZDOTDIR/completion-cache
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*:corrections' format '%U%F{green}%d (errors: %e)%f%u'
zstyle ':completion:*:warnings' format '%F{202}%BNo matches for: %F{214}%d%b'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args -w -w"
zmodload zsh/complist
bindkey -M menuselect '^n' vi-down-line-or-history
bindkey -M menuselect '^p' vi-up-line-or-history

# beep
setopt no_beep nolistbeep

# appearance
setopt no_check_jobs
setopt print_eight_bit
setopt correct
setopt nonomatch

# operation
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
setopt auto_cd
setopt auto_pushd
setopt no_flow_control

# integrate vim mode
bindkey -v
bindkey "^K" kill-whole-line
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^D" delete-char
bindkey "^F" forward-char
bindkey "^B" backward-char
autoload edit-command-line
zle -N edit-command-line

# search history
bindkey "^R" history-incremental-pattern-search-backward
zle_highlight=(isearch:fg=yellow)

# fuzzy history search
if (( $+commands[fzf] )); then
  export FZF_DEFAULT_OPTS='--reverse'
  select-history() {
    BUFFER=$(history -n -r 1 | awk '!x[$0]++' | fzf --no-sort +m --query "$LBUFFER")
    CURSOR=$#BUFFER
  }
  zle -N select-history
  bindkey "^Z" select-history
fi

# export variables
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR=vim
export REPORTTIME=10
export GORE_PAGER=less

# path settings
typeset -U path PATH
export PATH=~/.bin:/usr/local/opt/python3/libexec/bin:/usr/local/opt/node@10/bin:/usr/local/sbin:/usr/local/bin:$PATH:~/.local/bin:~/.go/bin:~/.cargo/bin
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man
export GOPATH=~/.go
if (( $+commands[plenv] )); then
  eval "$(plenv init -)"
fi
if (( $+commands[rbenv] )); then
  eval "$(rbenv init -)"
fi
if (( $+commands[nodenv] )); then
  eval "$(nodenv init -)"
fi

# function
starteditor() {
  exec < /dev/tty
  ${EDITOR}
  zle && zle reset-prompt
}
zle -N starteditor
bindkey '^@' starteditor
bindkey '^\^' starteditor
and() { [ $? -eq 0 ] && "$@"; }
or() { [ $? -eq 0 ] || "$@"; }

# for vim's C-s
stty -ixon -ixoff

# alias
alias ..="cd ../"
case "${OSTYPE}" in
  darwin*)
    alias google-chrome='open -a Google\ Chrome'
    alias evince='open -a Preview'
    alias display='open -a Preview'
    alias eog='open -a Preview'
    pman () {
      man -t "$1" | open -f -a /Applications/Preview.app
    }
  ;;
  linux*)
    alias open='gnome-open'
    alias pbcopy='xsel --clipboard --input'
    alias suspend='dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend'
    alias hibernate='dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Hibernate'
  ;;
esac
# editor
alias vi='vim'
alias emacs='vi'
# see ambiwidth in .vimrc
alias gnome-terminal='/bin/sh -c "VTE_CJK_WIDTH=1 gnome-terminal --disable-factory"'
alias terminator='/bin/sh -c "VTE_CJK_WIDTH=1 terminator -m"'
# one alphabet
alias c='clear'
alias d='download'
# default option
alias mpg123='mpg123 -zC'
alias mplayer='mplayer -subdelay 100000 -fs -geometry 50%:50%'
alias music='mplayer -lavdopts threads=2 -loop 0 -shuffle -geometry 50%:50%'
alias aspell="aspell -c -l en_US"
# git
export GIT_MERGE_AUTOEDIT=no
if (( $+commands[hub] )); then
  alias git=hub
fi
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout master'
alias gcd='git checkout develop 2>/dev/null || git checkout master'
alias ga='git add'
alias gmd='git merge origin/develop'
alias gd='git diff'
alias gdc='git diff --cached'
alias gpl='git pull -p'
alias gpo='git push origin'
alias gpot='git push origin --tags'
alias gpom='git push origin master'
# un*
alias ungzip='gzip -d'
alias untar='tar xvf'
# others
if (( $+commands[htop] )); then
  alias top='TERM=screen htop'
  alias htop='TERM=screen htop'
fi
case "${OSTYPE}" in
  freebsd*|darwin*)
    alias ls='ls -wG'
    alias ll='ls -altrwG'
    ;;
  *)
    alias ls='ls --color'
    alias ll='ls -altr --color'
    ;;
esac
alias unascii="sed $'s|\x1B\\[[0-9;]*[a-zA-Z]||g'"

# suffix alias according to file extension
alias -s txt=cat
alias -s {csv,js,css,less,md}=vi
alias -s tex=autolatex
alias -s html=google-chrome
alias -s pdf=evince
alias -s {png,jpg,bmp,PNG,JPG,BMP}=eog
alias -s {mp3,mp4,wav,mkv,m4v,m4a,wmv,avi,mpeg,mpg,vob,mov,rm}=mplayer
alias -s py=python
alias -s hs=runhaskell
alias -s sh=sh
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

# https://github.com/itchyny/zsh-auto-fillin
source $ZDOTDIR/zsh-auto-fillin/zsh-auto-fillin.zsh

# http://mimosa-pudica.net/zsh-incremental.html
source $ZDOTDIR/incr-0.2.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-history-substring-search
source $ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
