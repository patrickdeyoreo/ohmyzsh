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
alias n='nvim'

# dirstack
alias  d='dirs'
alias po='popd'
alias pu='pushd'

# jobs
alias j='jobs -p'

# ls
alias   l='ls'
alias  ll='ls -l'
alias  la='ls -A'
alias lla='ls -lA'

# python
alias     py='python'
alias    py2='python2'
alias    py3='python3'
alias python='python3'
alias    pip='pip3'
alias   pep8='pep8 2> /dev/null'

# thefuck
if command -v fuck > /dev/null
then
  alias fk='fuck'
fi

# htop
if command -v htop > /dev/null
then
  alias top='htop'
fi

# tmux
if command -v tmux > /dev/null
then
  alias  t='tmux'
  alias tn='tmux new'
  alias tns='tmux new -s'
  alias ta='tmux attach'
  alias tat='tmux attach -t'
fi

# xclip
if command -v xclip > /dev/null
then
  alias        cb='xclip -sel c'
  alias  cblstrip='xclip -sel c -o | sed '\''s@^[ \t]\+@@'\'' | xclip -sel c'
  alias  cbrstrip='xclip -sel c -o | sed '\''s@[ \t]\+$@@'\'' | xclip -sel c'
  alias   cbstrip='xclip -sel c -o | sed '\''s@^[ \t]\+\|[ \t]\+$@@'\'' | xclip -sel c'
  alias       cb1='xclip -sel p'
  alias cb1lstrip='xclip -sel p -o | sed '\''s@^[ \t]\+@@'\'' | xclip -sel p'
  alias cb1rstrip='xclip -sel p -o | sed '\''s@[ \t]\+$@@'\'' | xclip -sel p'
  alias  cb1strip='xclip -sel p -o | sed '\''s@^[ \t]\+\|[ \t]\+$@@'\'' | xclip -sel p'
  alias       cb2='xclip -sel s'
  alias cb2lstrip='xclip -sel s -o | sed '\''s@^[ \t]\+@@'\'' | xclip -sel s'
  alias cb2rstrip='xclip -sel s -o | sed '\''s@[ \t]\+$@@'\'' | xclip -sel s'
  alias  cb2strip='xclip -sel s -o | sed '\''s@^[ \t]\+\|[ \t]\+$@@'\'' | xclip -sel s'
fi

# feh
if command -v feh > /dev/null
then
  alias feh-slideshow='feh --auto-zoom --image-bg black --slideshow-delay 8'
fi

# query DNS servers for my WAN IP
alias wanip4='dig @resolver1.opendns.com -4 myip.opendns.com +short'
alias wanip6='dig @resolver1.opendns.com -6 myip.opendns.com +short'

