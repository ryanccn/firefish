#!/bin/bash
set -eo pipefail

# shellcheck source=lib.sh
source "${BASH_SOURCE%/*}/lib.sh"

log_prefix="$ansi_dim> $ansi_reset"

[ -d src ] && rm -rf src

clone_url="https://gitlab.prometheus.systems/firefish/firefish.git"
rev="$(cat rev.txt)"

echo -e "${log_prefix}Cloning ${ansi_cyan}firefish#${rev}${ansi_reset}..."

mkdir src && cd src
git init
git remote add origin "$clone_url"
git fetch origin "$rev" --depth 1
git reset --hard FETCH_HEAD

for patch in ../patches/*.patch; do
  echo -e "${log_prefix}Applying patch ${ansi_cyan}$(basename "$patch")${ansi_reset}"
  git apply "$patch"
done

set_output rev "$rev"
