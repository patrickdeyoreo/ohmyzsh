# Enable gpg-agent if it is not running-
# --use-standard-socket will work from version 2 upwards

gpg-connect-agent updatestartuptty /bye 1>/dev/null 2>&1

AGENT_SOCK="$(gpgconf --list-dirs agent-socket)"

if ! test -S "${AGENT_SOCK}"
then
  gpg-agent --daemon --use-standard-socket 1>/dev/null 2>&1
fi

# Export the current terminal
GPG_TTY="${TTY:-$(tty)}"
export GPG_TTY

# Configure SSH to use gpg-agent
unset -v SSH_AGENT_PID
if test "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne "$$"
then
  SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  export SSH_AUTH_SOCK
fi

# Set SSH to use gpg-agent if it's enabled
# GNUPGCONFIG="${GNUPGHOME:-"$HOME/.gnupg"}/gpg-agent.conf"
# if [[ -r $GNUPGCONFIG ]] && command grep -q enable-ssh-support "$GNUPGCONFIG"; then
#   export SSH_AUTH_SOCK="$AGENT_SOCK.ssh"
#   unset SSH_AGENT_PID
# fi
