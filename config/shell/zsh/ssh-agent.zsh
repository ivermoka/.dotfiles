if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)" > /dev/null
fi

# load key if not already loaded
ssh-add -l >/dev/null 2>&1 || ssh-add ~/.ssh/github >/dev/null 2>&1
