# shellcheck shell=bash

# https://github.com/bashly-framework/custom-libs-template/blob/master/prompts/ask.sh
ask() {
  local message="$1"
  local key

  # Print the message, but don't add a newline
  printf "%s" "$message"

  # Read exactly 1 character silently (-s), with no need for Enter (-n 1)
  # Redirect stdin to /dev/tty in case input is piped
  IFS= read -r -s -n 1 key < /dev/tty

  # Store result in REPLY (like bash `read` builtin)
  REPLY="$key"

  # Print the key back (so the user sees what they typed)
  echo "$key"
}
