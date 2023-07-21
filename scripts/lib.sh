# shellcheck shell=bash

export ansi_cyan="\033[36m"
export ansi_dim="\033[2m"
export ansi_reset="\033[0m"
[[ -n "$NO_COLOR" ]] && export ansi_cyan="" && export ansi_dim="" && export ansi_reset=""

function set_output() {
  [ -z "$GITHUB_OUTPUT" ] && return

  name="$1"
  value="$2"
  secret="$(openssl rand -hex 32)"

  {
    echo "$name<<$secret"
    echo "$value"
    echo "$secret"
  } >> "$GITHUB_OUTPUT"
}
