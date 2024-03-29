# zshaliases.plugin.zsh: Define aliases for an interactive shell
#
# vim : set et ft=zsh sts=2 sw=2 tw=0 :

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
alias ls='ls -CFhv --color=auto'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias rmdir='rmdir -v'
alias vdir='vdir --color=auto'
alias df='df --exclude-type=tmpfs'


# expand aliases following sudo
alias sudo='sudo '


# help
alias h='help'
alias help='help '
function help() {
  run-help "$@"
}


# clear
alias c='clear'


# dirs
alias po='popd'
alias pu='pushd'
alias -- -='popd'
alias -- +='pushd'


# jobs
alias j='jobs -lp'


# ls
alias l='ls'
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -Al'
alias lr='ls -R'
alias lar='ls -AR'
alias lt='ls -1t'
alias lat='ls -1At'
alias llat='ls -Alt'
alias l1='ls -1'
alias dls='ls -dl'


# man
alias aprop='man --apropos --wildcard'
alias apropx='man --apropos --regex'
alias what='man --whatis --wildcard'
alias whatx='man --whatis --regex'


# ps
alias p='ps w -fj' 
alias pt='ps w -fj -t "${TTY:-$(tty)}"'
alias pa='ps w -afj'
alias pe='ps w -efj'


# python
if command -v python3 > /dev/null
then
  alias python='python3'
elif command -v python2 > /dev/null
then
  alias python='python2'
fi
alias py='python'
alias py2='python2'
alias py3='python3'


# vim / neovim
if command -v nvim > /dev/null; then
  alias v='vim'
  alias vim='nvim'
  alias nvim='nvim -p'
  alias vdiff='vimdiff'
  alias vimdiff='nvimdiff'
  alias nvimdiff='command nvim -d'
elif command -v vim > /dev/null; then
  alias v='vim'
  alias vim='vim -p'
  alias vdiff='vimdiff'
fi


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
  if command -v fzf > /dev/null; then
    function tnsw() {
      emulate -L zsh
      local fzf=("${(z)$(__fzfcmd):-fzf}")
      local session_group="${1-$(
      tmux list-sessions -F "#{session_group}" | sort -u | FZF_DEFAULT_OPTS="--cycle --height=${(q)FZF_TMUX_HEIGHT:-20%} ${FZF_DEFAULT_OPTS} -1" "${fzf[@]}"
      )}"
      if [[ -n ${session_group} ]]; then
        tmux new -d -t "${session_group}" \; new-window \; attach
      fi
    }
  fi
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
alias wanip='wanip4'


# tree customization
if command -v tree > /dev/null; then
  function tree() {
    emulate -LR zsh
    local ignore_from=("${XDG_CONFIG_HOME:-${HOME}/.config}"/git/ignore(-.N) .gitignore(.N))
    local ignore_list=("${(f)$(< "${ignore_from[@]-/dev/null}")}") 2> /dev/null
    local options=(-CFlvI "(${(j:|:)ignore_list[@]%%(\/##\*#)#})")
    if (( ${+TREE} )); then
      options=("${(z)TREE}")
    fi
    command tree "${options[@]}" "$@"
  }
fi


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


# print the number of arguments supplied
function nargs() {
  print "$#"
}
