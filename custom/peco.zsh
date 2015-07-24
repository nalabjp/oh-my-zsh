function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history


function peco-path() {
  local filepath="$(find . | grep -v '/\.' | peco --prompt 'PATH>')"
  [ -z "$filepath" ] && return
  if [ -n "$LBUFFER" ]; then
    BUFFER="$LBUFFER$filepath"
  else
    if [ -d "$filepath" ]; then
      BUFFER="cd $filepath"
    elif [ -f "$filepath" ]; then
      BUFFER="$EDITOR $filepath"
    fi
  fi
  CURSOR=$#BUFFER
}
zle -N peco-path
bindkey '^g' peco-path # Ctrl+g で起動


function peco-with-vim () {
  if [[ -n $1 ]]; then
    BUFFER="vim $1"
    CURSOR=$#BUFFER
  fi
}

function agvim () {
  peco-with-vim $(ag $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}
zle -N agvim

function aghvim () {
  peco-with-vim $(agh $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}
zle -N aghvim

function ggrvim () {
  peco-with-vim $(git grep -n $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')
}
zle -N ggrvim


function peco-rails-command() {
  local cmd=$(rails $1 -h | sed -ne '/^Please/,$p' | sed '/^ *$/d' | sed -ne '/^ /p' | sed 's/^[ ]*//g' | peco --prompt="[rails $1]")
  if [[ -n $cmd ]]; then
    BUFFER="rails $1 $cmd"
    CURSOR=$#BUFFER
  fi
}

function peco-rails-generate() {
  peco-rails-command generate
}
zle -N peco-rails-generate
alias rrg='peco-rails-generate'

function peco-rails-destroy() {
  peco-rails-command destroy
}
zle -N peco-rails-destroy
alias rrd='peco-rails-destroy'
