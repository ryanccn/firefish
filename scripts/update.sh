#!/bin/bash
set -eo pipefail

# shellcheck source=lib.sh
source "${BASH_SOURCE%/*}/lib.sh"

log_prefix="$ansi_dim> $ansi_reset"

[ -d src-update ] && rm -rf src-update

clone_url="https://gitlab.prometheus.systems/firefish/firefish.git"
old_rev="$(cat rev.txt)"

echo -e "${log_prefix}Cloning ${ansi_cyan}firefish#beta${ansi_reset}..."

git clone "$clone_url" --depth 1 --branch beta --single-branch src-update
cd src-update

rev="$(git rev-parse HEAD)"
cd ..
echo "$rev" > rev.txt
rm -rf src-update

if [ "$old_rev" != "$rev" ]; then
  echo -e "${log_prefix}Updated pinned revision to ${ansi_cyan}$rev${ansi_reset}"
  set_output updated "true"
else
  echo -e "${log_prefix}Pinned revision ${ansi_cyan}$old_rev${ansi_reset} is up to date"
  set_output updated "false"
fi

pr_body="$(cat << EOF
Updates Firefish beta to [\`$rev\`](https://gitlab.prometheus.systems/firefish/firefish/-/commit/$rev).
EOF
)"

set_output rev "$rev"
set_output pr_body "$pr_body"
