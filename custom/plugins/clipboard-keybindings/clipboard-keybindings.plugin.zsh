# clipboard-keybindings.plugin.zsh: define and bind copy-paste ZLE widgets

function clipboard-copy() {
  print -f '%s' -- "${BUFFER}" | clipcopy
  return 0
}

function clipboard-paste() {
  if local temp && temp="$(clippaste && echo +)"; then
    temp="${temp%??}"
    RBUFFER="${temp}${RBUFFER}" 
    zle redisplay
    if typeset -f zle-line-init >/dev/null; then
      zle zle-line-init
    fi
  fi
  return 0
}

zle -N clipboard-copy
bindkey -M emacs '^[-' clipboard-copy
bindkey -M viins '^[-' clipboard-copy

zle -N clipboard-paste
bindkey -M emacs '^[+' clipboard-paste
bindkey -M viins '^[+' clipboard-paste
