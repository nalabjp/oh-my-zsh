# z.sh
#if [ -f $(brew --prefix)/etc/profile.d/z.sh ]; then
#  _Z_CMD=j
#  source $(brew --prefix)/etc/profile.d/z.sh
#  function precmd () {
#    _z --add "$(pwd -P)"
#  }
#fi
_Z_CMD=j
function precmd () {
  _z --add "$(pwd -P)"
}

