globalias() {
  zle _expand_alias
  zle expand-word
  zle magic-space
}
zle -N globalias

# control-space expands all aliases, including global
bindkey -M emacs "^ " globalias
bindkey -M viins "^ " globalias

# space to make a normal space
bindkey -M emacs " " magic-space
bindkey -M viins " " magic-space

# normal space during searches
bindkey -M isearch " " magic-space
