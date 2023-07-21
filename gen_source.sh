#!/bin/bash
set -eo pipefail

ansi_cyan="\033[36m"
ansi_green="\033[32m"
ansi_reset="\033[0m"
[[ -n "$NO_COLOR" ]] && ansi_cyan="" && ansi_green="" && ansi_reset=""

[ -d src ] && rm -rf src

clone_url="https://gitlab.prometheus.systems/firefish/firefish.git"

echo -e "Cloning ${ansi_cyan}firefish#beta${ansi_reset}"

git clone "$clone_url" --depth 1 --branch beta --single-branch src &> /dev/null
cd src

for patch in ../patches/*.patch; do
  echo -e "Applying patch ${ansi_green}$(basename "$patch")${ansi_reset}"
  git apply "$patch"
done
