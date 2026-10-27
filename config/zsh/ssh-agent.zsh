# fallback when no agent is available (gcr-ssh-agent is set in exports.zsh)
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
fi
