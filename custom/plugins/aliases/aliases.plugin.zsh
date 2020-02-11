# default options
alias   dir="${aliases[dir]:-dir} --color=auto"
alias egrep="${aliases[egrep]:-egrep} --color=auto"
alias fgrep="${aliases[fgrep]:-fgrep} --color=auto"
alias   gdb="${aliases[gdb]:-gdb} -q"
alias  grep="${aliases[grep]:-grep}  --color=auto"
alias    ls="${aliases[ls]:-ls} -Cpv --color=auto"
alias mkdir="${aliases[mkdir]:-mkdir} -pv"
alias    mv="${aliases[mv]:-mv} -biv"
alias    rm="${aliases[rm]:-rm} -Iv"
alias rmdir="${aliases[rmdir]:-rmdir} -v"
alias  vdir="${aliases[vdir]:-vdir} --color=auto"
alias   vim="${aliases[vim]:-vim} -p"

# go back to previous directory
alias -- -='cd -'

# clear
alias c='clear'

# vim
alias v='vim'

# dirstack
alias ds='dirs'
alias po='popd'
alias pu='pushd'

# jobs
alias j='jobs -p'

# thefuck
if command -v fuck > /dev/null
then alias fk='fuck'
fi

# ls
alias  l='ls'
alias ll='ls -l'
alias la='ls -lA'

# python
alias     py='python'
alias    py2='python2'
alias    py3='python3'
alias python='python3'
alias    pip='pip3'
alias   pep8='pep8 2> /dev/null'

# htop
if command -v htop > /dev/null
then alias top='htop'
fi

# tmux
if command -v tmux > /dev/null
then
  alias  t='tmux'
  alias tn='tmux new -s'
fi

# xclip
if command -v xclip > /dev/null
then
  alias         xb='xclip -sel c'
  alias  xbstrip-l='xclip -sel c -o | sed -e '"'"'s%^[ \t]\+%%'"'"' | xclip -sel c'
  alias  xbstrip-r='xclip -sel c -o | sed -e '"'"'s%[ \t]\+$%%'"'"' | xclip -sel c'
  alias    xbstrip='xclip -sel c -o | sed -e '"'"'s%^[ \t]\+%%'"'"' -e '"'"'s%[ \t]\+$%%'"'"' | xclip -sel c'
  alias        xb1='xclip -sel p'
  alias xb1strip-l='xclip -sel p -o | sed -e '"'"'s%^[ \t]\+%%'"'"' | xclip -sel p'
  alias xb1strip-r='xclip -sel p -o | sed -e '"'"'s%[ \t]\+$%%'"'"' | xclip -sel p'
  alias   xb1strip='xclip -sel p -o | sed -e '"'"'s%^[ \t]\+%%'"'"' -e '"'"'s%[ \t]\+$%%'"'"' | xclip -sel p'
  alias        xb2='xclip -sel s'
  alias xb2strip-l='xclip -sel s -o | sed -e '"'"'s%^[ \t]\+%%'"'"' | xclip -sel s'
  alias xb2strip-r='xclip -sel s -o | sed -e '"'"'s%[ \t]\+$%%'"'"' | xclip -sel s'
  alias   xb2strip='xclip -sel s -o | sed -e '"'"'s%^[ \t]\+%%'"'"' -e '"'"'s%[ \t]\+$%%'"'"' | xclip -sel s'
fi

# query DNS servers for my WAN IP
alias  wanip='dig @resolver1.opendns.com ANY myip.opendns.com +short'
alias wanip4='dig @resolver1.opendns.com -4 myip.opendns.com +short'
alias wanip6='dig @resolver1.opendns.com -6 myip.opendns.com +short'

# feh slideshow
if command -v feh > /dev/null
then alias feh-slideshow='feh --auto-zoom --image-bg black --slideshow-delay 8'
fi
