# dircolors.plugin.zsh: Provides and and executes a function to load LS_COLORS

typeset -Tx 'LS_COLORS' 'ls_colors' ':'

# Load LS_COLORS, optionally from a dircolors file
# usage: load_ls_colors [DIRECTORY ...]
function load_dircolors() {
  emulate -LR zsh
  if ! (( $# )); then
    set -- "${XDG_CONFIG_HOME-${HOME}/.config}" ~ /etc
  fi
  function () {
    typeset -gx LS_COLORS="${${(@fs"'")$(dircolors -b -- "${@:1:1}")}[2]}"
  } "${^@}"/{,.}dircolors(N)
}
load_dircolors "${ZDOTDIR}" "${XDG_CONFIG_HOME:-${HOME}/.config}" "${HOME}"
