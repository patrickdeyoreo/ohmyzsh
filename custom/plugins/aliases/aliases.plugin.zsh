# default options
alias   dir="dir --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"
alias   gdb="gdb -q"
alias  grep="grep  --color=auto"
alias    ls="ls -BCp --color=auto"
alias mkdir="mkdir -pv"
alias    mv="mv -iv"
alias    rm="rm -Iv"
alias rmdir="rmdir -v"
alias  vdir="vdir --color=auto"
alias   vim="vim -p"
alias  nvim="nvim -p"

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

# ps
alias psa='ps -a'
alias pse='ps -e'
alias psf='ps -f'
alias psj='ps -j'
alias psu='ps -u "${USERNAME:-${USER:-$(id -nu)}}"'

# python
alias     py='python'
alias    py3='python3'
alias    py2='python2'
alias python='python3'

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
  alias  cblstrip='xclip -sel c -o | sed '"'"'s@^[ \t]\+@@'"'"' | xclip -sel c'
  alias  cbrstrip='xclip -sel c -o | sed '"'"'s@[ \t]\+$@@'"'"' | xclip -sel c'
  alias   cbstrip='xclip -sel c -o | sed '"'"'s@^[ \t]\+\|[ \t]\+$@@'"'"' | xclip -sel c'
  alias       cb1='xclip -sel p'
  alias cb1lstrip='xclip -sel p -o | sed '"'"'s@^[ \t]\+@@'"'"' | xclip -sel p'
  alias cb1rstrip='xclip -sel p -o | sed '"'"'s@[ \t]\+$@@'"'"' | xclip -sel p'
  alias  cb1strip='xclip -sel p -o | sed '"'"'s@^[ \t]\+\|[ \t]\+$@@'"'"' | xclip -sel p'
  alias       cb2='xclip -sel s'
  alias cb2lstrip='xclip -sel s -o | sed '"'"'s@^[ \t]\+@@'"'"' | xclip -sel s'
  alias cb2rstrip='xclip -sel s -o | sed '"'"'s@[ \t]\+$@@'"'"' | xclip -sel s'
  alias  cb2strip='xclip -sel s -o | sed '"'"'s@^[ \t]\+\|[ \t]\+$@@'"'"' | xclip -sel s'
fi

# feh
if command -v feh > /dev/null
then
  alias feh-slideshow='feh --auto-zoom --image-bg black --slideshow-delay 8'
fi

# query DNS servers for my WAN IP
alias wanip4='dig @resolver1.opendns.com -4 myip.opendns.com +short'
alias wanip6='dig @resolver1.opendns.com -6 myip.opendns.com +short'

# youtube-dl
if command -v youtube-dl > /dev/null
then
  typeset -xT YTDL_OPTS ytdl_opts ' '
  ytdl_opts=(
    '--geo-bypass'
    '--ignore-errors'
    '--max-sleep-interval=5'
    '--min-sleep-interval=1'
  )
  typeset -xT YTDLA_OPTS ytdla_opts ' '
  ytdla_opts=(
    '--add-metadata'
    '--extract-audio'
    '--playlist-random'
    '--audio-quality=0'
    '--metadata-from-title='"'"'^\s*(?:(?P<artist>.+?)(?:\s+[Ff]t\.?|[Ff]eat(?:\.|uring)?\s.+?)?\s+[~|=/+-]+\s+(?:(?P<album>.+?)\s+[~|=/+-]+\s+)?)?(?P<title>.+?)(?:\s+(?:[([](?:\s*(?:[Aa      ]udio|[Ll]yrics?|[Mm]usic|[Oo]nly|(?:[Uu]n)?[Oo]fficial|[Vv]ideo)\s*)+[])])+\s*)*\s*$'"'"
    '--output="${XDG_MUSIC_DIR:-${HOME}/Music}/%(title)s.%(id)s.%(ext)s"'
  )
  alias youtube-dl="youtube-dl ${YTDL_OPTS}"
  alias ytdl="youtube-dl"
  alias ytdla="youtube-dl ${YTDLA_OPTS}"
fi

# tmux
if command -v tmux > /dev/null
then alias tnsw=$'tmux attach-session -t "$(
tmux new-window -P -F "#{session_name}" -a -t "$(
tmux new-session -P -F "#{session_name}" -d -t "${$(
tmux list-sessions -F "#{session_group}"
)%%\n*}"
):$"
)"'
fi
