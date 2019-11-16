# ------------------------------------------------------------------------------------------------------------
# - * File: .zshrc
# - * Author: itchyny
# - * Last Change: 2019/11/17 01:45:01.
# ------------------------------------------------------------------------------------------------------------

ZDOTDIR=$HOME/.zsh

# history
HISTFILE=~/.files/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt append_history extended_history hist_ignore_dups hist_no_store hist_reduce_blanks hist_verify hist_ignore_space share_history inc_append_history

# color
autoload -Uz colors; colors
LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=34;47:cd=35;47:su=30;41:sg=30;46:tw=30;42:ow=30;43:'
LS_COLORS+='*.1=32:*.sh=32:*.zsh=32:*.c=32:*.h=32:*.s=32:*.S=32:*.y=32:*.cpp=32:*.ac=32:*.m4=32:*.bat=32:*.js=32:*.ts=32:*.go=32:'
LS_COLORS+='*.hs=32:*.lhs=32:*.py=32:*.rb=32:*.pl=32:*.tex=32:*.csv=32:*.txt=32:*.r=32:*.java=32:*.scala=32:'
LS_COLORS+='*.jpg=35:*.png=35:*.bmp=35:*.gif=35:*.svg=35:*.tiff=35:'
LS_COLORS+='*.gz=33:*.tgz=33:*.zip=33:*.lzh=33:*.bz2=33:*.tbz=33:*.Z=33:*.tar=33:*.arj=33:*.xz=33:'
LS_COLORS+='*.md=94:*.pdf=94:*.html=94:*.xml=94:*.json=94:*.yml=94:*.yaml=94:*.conf=94:*.less=94:*.css=94:'
export LS_COLORS # doesn't work in Mac
export LSCOLORS=gxfxcxdxbxehfhabagacad
export TERM=xterm-256color

# colorize stderr output in red
zmodload zsh/terminfo zsh/system
color_stderr() {
  while sysread std_err_color; do
    if [[ $std_err_color =~ $'\e\\[0[m;]' ]]; then
      syswrite -o 2 "${std_err_color}"
    else
      syswrite -o 2 "${fg_bold[red]}${std_err_color}${terminfo[sgr0]}"
    fi
  done
}
exec 2> >(color_stderr)

# prompt
setopt prompt_subst interactive_comments
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
setopt extendedglob; if [[ -n $ZDOTDIR/.zcompdump(#qN.mh+720) ]]; then compinit; compdump; else compinit -C; fi; unsetopt extendedglob
LISTMAX=500
fignore=(.git .o .dvi .aux .log .toc .hi .swp .sw .bak .bbl .blg .nav .snm .toc .pyc)
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

# options
setopt no_beep nolistbeep auto_cd auto_pushd no_flow_control no_check_jobs print_eight_bit correct nonomatch
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

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
export PATH=~/.bin:~/.go/bin:~/.cargo/bin:/usr/local/opt/python3/libexec/bin:/usr/local/opt/node@10/bin:/usr/local/sbin:/usr/local/bin:$PATH
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man
export GOPATH=~/.go
if (( $+commands[plenv] )); then
  eval "$(plenv init -)"
fi
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
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
alias google-chrome='open -a Google\ Chrome'
alias evince='open -a Preview'
alias display='open -a Preview'
alias eog='open -a Preview'
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
# un*
alias ungzip='gzip -d'
alias untar='tar xvf'
# others
if (( $+commands[htop] )); then
  alias top='TERM=screen htop'
  alias htop='TERM=screen htop'
fi
alias ls='ls -wG'
alias ll='ls -altrwG'
alias unascii="sed $'s|\x1B\\[[0-9;]*[a-zA-Z]||g'"

# suffix alias according to file extension
alias -s txt=cat
alias -s {csv,js,css,less,md}=vi
alias -s tex=autolatex
alias -s html=google-chrome
alias -s pdf=evince
alias -s {png,jpg,bmp,gif,svg,tiff}=eog
alias -s {mp3,mp4,wav,mkv,m4v,m4a,wmv,avi,mpeg,mpg,vob,mov,rm}=mplayer
alias -s py=python
alias -s hs=runhaskell
alias -s sh=sh
alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

# https://github.com/itchyny/zsh-auto-fillin
source $ZDOTDIR/zsh-auto-fillin/zsh-auto-fillin.zsh

# https://github.com/itchyny/zsh-git-alias
source $ZDOTDIR/zsh-git-alias/zsh-git-alias.zsh

# http://mimosa-pudica.net/zsh-incremental.html
source $ZDOTDIR/incr-0.2.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-history-substring-search
source $ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
