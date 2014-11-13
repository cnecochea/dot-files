# functions for parsing current git repo info
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " ("${ref#refs/heads/}$(num_git_commits_ahead)")"
}

function num_git_commits_ahead {
    num=$(git status 2> /dev/null | grep "Your branch is ahead of" | awk '{split($0,a," "); print a[9];}' 2> /dev/null) || return
    if [[ "$num" != "" ]]; then
	echo "+$num"
    fi
}

stashgrep() {
  for i in `git stash list | awk -F ':' '{print $1}'`; do
    git stash show -p $i | grep -H --label="$i" "$1"
  done
}

# get gzipped size of a local file
function gz() {
  local original="$(cat "$1" | wc -c)"
  local gzipped="$(gzip -c "$1" | wc -c)"
  echo
  echo "original file size (bytes):" $original
  echo "gzipped file size  (bytes):" $gzipped
}

# get gzipped size of a remote file
function gzu() {
  local dlFile="$(curl $1)"
  local original="$(echo "scale=1; $(echo $dlFile | wc -c)/1024" | bc)"
  local gzipped="$(echo "scale=1; $(echo $dlFile | gzip -c | wc -c)/1024" | bc)"
  echo
  echo "original file size (kb):" $original
  echo "gzipped file size  (kb):" $gzipped
}


# prompt setup
RED="\[\033[0;31m\]" 
YELLOW="\[\033[0;33m\]" 
GREEN="\[\033[0;32m\]"
WHITE="\[\033[0;37m\]"
PS1="[\u@\h] $GREEN\w$YELLOW\$(parse_git_branch) $GREEN\$ $WHITE"

# general environment variable setup
EDITOR=vim
PATH=./bin:/usr/local/bin:$PATH

# RVM setup
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# NVM setup
[[ -s "$HOME/.nvm/nvm.sh" ]] && . "$HOME/.nvm/nvm.sh"

# git bash completion
source ~/.git-completion.bash

# alias all the things
alias desk="cd ~/Desktop"
alias start_postgres="pg_ctl -D /usr/local/var/postgres9 -l /usr/local/var/postgres9/server.log start"
alias stop_postgres=" pg_ctl -D /usr/local/var/postgres9 stop -s -m fast"
alias bake="bundle exec rake"
alias gg="git grep --color -n $1"
alias gch="git checkout $1"
alias gpr="git pull --rebase"
alias gpoh="git push origin HEAD"
alias gst="git status"
alias gbl="git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'"
alias iconr-plm="iconr app/assets/images/icons-svg-src/ app/assets/images/icons-svg -avpnod --filename=icon-village.css"
alias restart_me="touch tmp/restart.txt"
#"cd ~/Documents/Code/plm-website/app/assets/images/icons-svg-src; iconr ../icons-svg-src ../icons-svg -avpnod --filename=icon-village.css"

alias sdev="cd ~/Documents/Code/starter && bundle exec foreman start"

# only set vim to mvim if we're actually on OS X
[[ `uname -a` =~ "Darwin" ]] && alias vim="mvim"

export RUBY_GC_HEAP_INIT_SLOTS=1000000 
export RUBY_HEAP_SLOTS_INCREMENT=1000000 
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1 
export RUBY_GC_MALLOC_LIMIT=1000000000 
export RUBY_HEAP_FREE_MIN=500000
export ARCHFLAGS="-arch x86_64"
eval "$(rbenv init -)"

