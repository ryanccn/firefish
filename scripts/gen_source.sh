#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash coreutils openssl git sd jq
# shellcheck shell=bash

set -eo pipefail

# shellcheck source=lib.sh
source "${BASH_SOURCE%/*}/lib.sh"

log_prefix="$ansi_dim> $ansi_reset"

[ -d src ] && rm -rf src

rev="$(cat rev.txt)"

echo -e "${log_prefix}Cloning ${ansi_cyan}firefish#${rev}${ansi_reset}..."

mkdir src && cd src
git init
git remote add origin "https://git.joinfirefish.org/firefish/firefish.git"
git fetch origin "$rev" --depth 1
git reset --hard FETCH_HEAD

for patch in ../patches/*.patch; do
  echo -e "${log_prefix}Applying patch ${ansi_cyan}$(basename "$patch")${ansi_reset}"
  git apply "$patch"
done

patched_version="$(jq -r '.version' < package.json)-ryan.1"
echo -e "${log_prefix}Patching version to $ansi_cyan$patched_version$ansi_reset"
# shellcheck disable=SC2016
sd '("version": ")(.*)(",)' '$1$2-ryan.1$3' package.json

set_output rev "$rev"
