# space-travel.zsh-theme

zmodload zsh/terminfo
() {
  local -i index
  index=$(echoti colors)
  while ((index--)); do
    fg[$((index))]=$(echoti setaf "$((index))")
  done
}

function __shrink_path {
  local retval=$?
  setopt localoptions extendedglob noglobsubst promptpercent
  local match mbegin mend
  local prefix=${${(%)$(<<<%~)}%%/*}
  local suffix=${${(%)$(<<<%~)}##$prefix(*/)#}
  local middle=${${${(%)$(<<<%~)}/#%(#b)$prefix(*)$suffix/$match[1]}:W:/:s/#%(#b)(??)??##/$match[1]*}
  print "$prefix$middle$suffix"
  return "$retval"
}

function __git_prompt_info {
  local retval=$?
  setopt localoptions promptbang promptpercent promptsubst
  print -P "$(git_prompt_info; exit "$retval")"
  return "$retval"
}

function __lolcat {
  local retval=$?
  setopt localoptions noglobsubst promptbang promptpercent promptsubst
  local res=''
  local str=${(%)1}
  local -a lolcat=(
    "$fg[154]" "$fg[148]" "$fg[184]" "$fg[178]" "$fg[214]" "$fg[208]"
    "$fg[209]" "$fg[203]" "$fg[204]" "$fg[198]" "$fg[199]" "$fg[163]"
    "$fg[164]" "$fg[128]" "$fg[129]" "$fg[93]"  "$fg[99]"  "$fg[63]"
    "$fg[69]"  "$fg[33]"  "$fg[39]"  "$fg[38]"  "$fg[44]"  "$fg[43]" 
    "$fg[49]"  "$fg[48]"  "$fg[84]"  "$fg[83]"  "$fg[119]" "$fg[118]"
  )
  local -i i=0
  local -i s=$2
  while ((i++ < $#str))
  do
    res+="%{$lolcat[(i + s) % $#lolcat]%}$str[i]"
  done
  print -P "$res%{$reset_color%}"
  return "$retval"
}

status_color='$fg[$(( $? ? ($? - 1) % 6 + 1 : 45 ))]'

PROMPT='%{'"$status_color"'%}╒[%{$reset_color%}$(__lolcat %n 12)%{'"$status_color"'%}@%{$reset_color%}$(__lolcat %m 15)%{'"$status_color"'%}]═[%{$reset_color%}$(__lolcat %y 23)%{'"$status_color"'%}]═[%{$reset_color%}$(__lolcat "$(__shrink_path)" 28)%{'"$status_color"'%}]%{$reset_color%}$(__git_prompt_info)
%{'"$status_color"'%}╘[%{$reset_color%}%(?.%(!.%15F#%15f.%15Fﬦ%15f).%15F%?%15f)%{'"$status_color"'%}]%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX='
%{'"$status_color"'%}╞[%{$reset_color%}%15Fgit%15f%{'"$status_color"'%}|%{$reset_color%}%15F'
ZSH_THEME_GIT_PROMPT_SUFFIX='%{'"$status_color"'%}]%{$reset_color%}'
ZSH_THEME_GIT_PROMPT_CLEAN='%{'"$status_color"'%}(%{$reset_color%}%B%4F❄%4f%b%{'"$status_color"'%})%{$reset_color%}'
ZSH_THEME_GIT_PROMPT_DIRTY='%{'"$status_color"'%}(%{$reset_color%}%B%3F%3f%b%{'"$status_color"'%})%{$reset_color%}'

unset -v status_color

# vim:ft=zsh:tw=0
