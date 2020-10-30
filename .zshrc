# --------------------------------------------------------------------------------------------------
# - * File: .zshrc
# - * Author: itchyny
# - * Last Change: 2020/10/30 13:07:20.
# --------------------------------------------------------------------------------------------------

# XDG Base Directory Specification
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.share

# data directory
ZDOTDIR=$XDG_DATA_HOME/zsh

# zinit
declare -A ZINIT
ZINIT[HOME_DIR]=$XDG_DATA_HOME/zinit
ZINIT[BIN_DIR]=${ZINIT[HOME_DIR]}/bin
ZINIT[PLUGINS_DIR]=${ZINIT[HOME_DIR]}/plugins
ZINIT[COMPLETIONS_DIR]=${ZINIT[HOME_DIR]}/completions
ZINIT[SNIPPETS_DIR]=${ZINIT[HOME_DIR]}/snippets
ZINIT[ZCOMPDUMP_PATH]=${ZINIT[HOME_DIR]}/zcompdump
source ${ZINIT[BIN_DIR]}/zinit.zsh

# plugins
zinit light itchyny/zsh-auto-fillin
zinit light itchyny/zsh-git-alias
zinit light zdharma/fast-syntax-highlighting
zinit light zdharma/history-search-multi-word
zinit light zsh-users/zsh-autosuggestions

zinit light popstas/zsh-command-time
ZSH_COMMAND_TIME_COLOR=yellow

zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure
zstyle :prompt:pure:path color 14

# history
HISTFILE=$ZDOTDIR/histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt append_history extended_history hist_ignore_dups hist_no_store hist_reduce_blanks hist_verify hist_ignore_space share_history inc_append_history

# quote URL
autoload -Uz url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic

# completion
autoload -Uz compinit; compinit -C
LISTMAX=500
setopt auto_list auto_menu list_packed auto_param_keys auto_param_slash mark_dirs
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' '+r:|[._-]=* r:|=*' '+l:|=* r:|=*'

# options
setopt no_beep nolistbeep auto_cd auto_pushd no_flow_control no_check_jobs print_eight_bit correct nonomatch

# integrate vim mode
bindkey -v
bindkey '^K' kill-whole-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^D' delete-char
bindkey '^F' forward-char
bindkey '^B' backward-char
autoload edit-command-line
zle -N edit-command-line

# search history
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

# fuzzy history search
select-history() {
  BUFFER=$(history -n -r 1 | awk '!x[$0]++' | gof)
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^Z' select-history

# export variables
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export EDITOR=vim
export GIT_EDITOR=vim
export GORE_PAGER=less
export GIT_MERGE_AUTOEDIT=no

# path settings
export MANPATH=/usr/local/share/man:/usr/local/man:/usr/share/man
export GOPATH=$XDG_DATA_HOME/go
export GORE_HOME=$XDG_DATA_HOME/gore
export CARGO_HOME=$XDG_CACHE_HOME/cargo
export RUSTUP_HOME=$XDG_CACHE_HOME/rustup
export STACK_ROOT=$XDG_CACHE_HOME/stack
export PERL_CPANM_HOME=$XDG_CACHE_HOME/cpanm
export BUNDLE_USER_HOME=$XDG_CACHE_HOME/bundle
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm
export GEM_HOME=$XDG_CACHE_HOME/gem
export GEM_SPEC_CACHE=$GEM_HOME/specs
export IRBRC=$XDG_CONFIG_HOME/irb/irbrc
export SOLARGRAPH_CACHE=$XDG_CACHE_HOME/solargraph
export IPYTHONDIR=$XDG_CACHE_HOME/ipython
export MPLCONFIGDIR=$XDG_CACHE_HOME/matplotlib
export GRADLE_USER_HOME=$XDG_DATA_HOME/gradle
export HUB_CONFIG=$XDG_CONFIG_HOME/hub/hub
export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker
export FURO_LOGS_DIR=$XDG_CACHE_HOME/furoshiki2
export AWS_CONFIG_FILE=$XDG_CONFIG_HOME/aws/config
export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials
export CDK_HOME=$XDG_DATA_HOME/cdk
export MINIKUBE_HOME=$XDG_DATA_HOME/minikube
createdir() { [[ ! -d "${1%/*}" ]] && mkdir -p "${1%/*}"; echo "$1"; }
export MYSQL_HISTFILE=$(createdir "$XDG_DATA_HOME/mysql/history")
export PSQL_HISTORY=$(createdir "$XDG_DATA_HOME/psql/history")
export NODE_REPL_HISTORY=$(createdir "$XDG_DATA_HOME/node/history")
typeset -U path PATH
export PATH=$XDG_DATA_HOME/bin:$GOPATH/bin:$CARGO_HOME/bin:/usr/local/opt/python3/libexec/bin:/usr/local/sbin:/usr/local/bin:$PATH
if (( $+commands[plenv] )); then
  export PLENV_ROOT=$XDG_CACHE_HOME/plenv
  eval "$(plenv init -)"
fi
if (( $+commands[pyenv] )); then
  export PYENV_ROOT=$XDG_CACHE_HOME/pyenv
  eval "$(pyenv init -)"
  alias brew="env PATH=${PATH//$(pyenv root)\/shims:/} brew"
fi
if (( $+commands[rbenv] )); then
  export RBENV_ROOT=$XDG_CACHE_HOME/rbenv
  eval "$(rbenv init -)"
fi
if (( $+commands[nodenv] )); then
  export NODENV_ROOT=$XDG_CACHE_HOME/nodenv
  eval "$(nodenv init -)"
fi

# editor
starteditor() {
  exec < /dev/tty
  $=EDITOR
  zle && zle reset-prompt
}
zle -N starteditor
bindkey '^@' starteditor

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
