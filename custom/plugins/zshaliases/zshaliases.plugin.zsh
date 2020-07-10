# zshaliases.plugin.zsh: Define aliases for an interactive shell

# If this is not an interactive shell, abort.
case $- in
  (*i*) ;;
    (*) return ;;
esac

# default command options
alias cp='cp -iv'
alias diff='diff --color=auto'
alias dir='dir --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gdb='gdb -q'
alias grep='grep --color=auto'
alias ip='ip -c'
alias ls='ls -CFhv --group-directories-first --color=auto'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias nvim='nvim -p'
alias rm='rm -Iv'
alias rmdir='rmdir -v'
alias vdir='vdir --color=auto'
alias vim='vim -p'
alias nvim='nvim -p'
function tree() {
  emulate -LR zsh
  local exclude=("${(@f)$(< {~/.config/git/,.git}ignore(-.N) < /dev/null)}")
  local options=(-C -F -l -v --matchdirs -I "(${(j:|:)exclude[@]%\/##\*#})")
  command tree "${options[@]}" "$@"
}

# expand aliases following sudo
alias sudo='sudo '

# run 'help'
alias help='run-help'

# clear
alias c='clear'

# dirstack
alias ds='dirs'
alias po='popd'
alias pu='pushd'

# help
alias h='help'

# jobs
alias j='jobs -lp'

# ls
alias l='ls'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -Al'
alias lr='ls -Rt'
alias lt='ls -1crt'
alias lat='ls -1Acrt'
alias dls='ls -dl'

# man
alias m
alias m='man'
alias mw='man --wildcard'
alias mx='man --regex'
alias mk='man --apropos'
alias mkw='man --apropos --wildcard'
alias mf='man --whatis'
alias mfx='man --whatis --regex'

# ps
alias p='ps c w -fj' 
alias pa='ps w -afj'
alias pe='ps w -efj'
alias psat='ps w -afj -t "${TTY:-$(tty)}"'
alias pset='ps w -efj -t "${TTY:-$(tty)}"'

# python
alias py='python'
alias py3='python3'
alias py2='python2'
alias python='python3'

# vim
alias v='vim'
alias n='nvim'

# thefuck
if command -v fuck > /dev/null; then
  alias fk='fuck'
fi

# htop
if command -v htop > /dev/null; then
  alias top='htop'
fi

# tmux
if command -v tmux > /dev/null; then
  alias t='tmux'
  alias tn='tmux new-session'
  alias tns='tmux new-session -s'
  alias tnt='tmux new-session -t'
  alias tnw='tmux new-window'
  alias tnn='tmux new-window -n'
  alias ta='tmux attach-session'
  alias tat='tmux attach-session -t'
  function tnsw() {
    emulate -L zsh
    local -a fzf=("${(z)$(__fzfcmd):-fzf}")
    local -Tx FZF_DEFAULT_OPTS fzf_default_opts " "
    fzf_default_opts=(--cycle --height='15%' "${fzf_default_opts[@]}" -1)
    if [[ -n "$1" ]]; then
      tmux new -d -t "$1" ";" new-window ";" attach
    elif tmux has-session; then
      function () {
        if [[ -n "$1" ]]; then
          tmux new -d -t "$1" ";" new-window ";" attach
        fi
      } "$(tmux list-sessions -F "#{session_group}" | sort -u | "${fzf[@]}")"
    fi
  }
fi

# xclip
if command -v xclip > /dev/null; then
  alias cb='xclip -selection clipboard'
  alias cb1='xclip -selection primary'
  alias cb2='xclip -selection secondary'
  alias cb-strip='xclip -o -selection clipboard |
    sed ''s%^[ \t]\+\|[ \t]\+$%%'' |
    xclip -i -selection clipboard'
  alias cb1-strip='xclip -o -selection primary |
    sed ''s%^[ \t]\+\|[ \t]\+$%%'' |
    xclip -i -selection primary'
  alias cb2-strip='xclip -o -selection secondary |
    sed ''s%^[ \t]\+\|[ \t]\+$%%'' |
    xclip -i -selection secondary'
  alias cb-strip-l='xclip -o -selection clipboard |
    sed ''s%^[ \t]\+%%'' |
    xclip -i -selection clipboard'
  alias cb1-strip-l='xclip -o -selection primary |
    sed ''s%^[ \t]\+%%'' |
    xclip -i -selection primary'
  alias cb2-strip-l='xclip -o -selection secondary |
    sed ''s%^[ \t]\+%%'' |
    xclip -i -selection secondary'
  alias cb-strip-r='xclip -o -selection clipboard |
    sed ''s%[ \t]\+$%%'' |
    xclip -i -selection clipboard'
  alias cb1-strip-r='xclip -o -selection primary |
    sed ''s%[ \t]\+$%%'' |
    xclip -i -selection primary'
  alias cb2-strip-r='xclip -o -selection secondary |
    sed ''s%[ \t]\+$%%'' |
    xclip -i -selection secondary'
fi

# feh
if command -v feh > /dev/null; then
  alias feh-slideshow='feh --auto-zoom --image-bg black --slideshow-delay 8'
fi

# query DNS servers for my WAN IP
alias wanip4='dig @resolver1.opendns.com -4 myip.opendns.com +short'
alias wanip6='dig @resolver1.opendns.com -6 myip.opendns.com +short'

# youtube-dl
if command -v youtube-dl > /dev/null; then
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

# set ft=zsh:et:sts=2:sw=2:ts=8:tw=0
