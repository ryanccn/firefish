#!/bin/bash
set -eo pipefail

ansi_cyan="\033[36m"
ansi_dim="\033[2m"
ansi_reset="\033[0m"
[[ -n "$NO_COLOR" ]] && ansi_cyan="" && ansi_dim="" && ansi_reset=""

log_prefix="$ansi_dim> $ansi_reset"

[ -d src-update ] && rm -rf src-update

clone_url="https://gitlab.prometheus.systems/firefish/firefish.git"

echo -e "${log_prefix}Cloning ${ansi_cyan}firefish#beta${ansi_reset}..."

git clone "$clone_url" --depth 1 --branch beta --single-branch src-update
cd src-update

rev="$(git rev-parse HEAD)"
cd ..
echo "$rev" > rev.txt
rm -rf src-update

echo -e "${log_prefix}Updated pinned revision to ${ansi_cyan}$rev${ansi_reset}"

if [ -n "$GITHUB_OUTPUT" ]; then
  echo "rev=$rev" >> "$GITHUB_OUTPUT"
  echo "pr-body=$(sed "s/%REV%/$(cat rev.txt)/g" pr_template.md)" >> "$GITHUB_OUTPUT"
fi
