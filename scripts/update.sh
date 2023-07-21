#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash coreutils openssl curl jq
# shellcheck shell=bash

set -eo pipefail

# shellcheck source=lib.sh
source "${BASH_SOURCE%/*}/lib.sh"

log_prefix="$ansi_dim> $ansi_reset"

[ -d src-update ] && rm -rf src-update

old_rev="$(cat rev.txt)"

echo -e "${log_prefix}Fetching ${ansi_cyan}latest revision${ansi_reset} from GitLab API..."

commit_data="$(curl -fsSL "https://gitlab.prometheus.systems/api/v4/projects/30/repository/commits?ref_name=main" | jq '.[0]')"

rev="$(echo "$commit_data" | jq -r '.id')"
short_rev="$(echo "$commit_data" | jq -r '.short_id')"
message="$(echo "$commit_data" | jq -r '.title')"

echo "$rev" > rev.txt

if [ "$old_rev" != "$rev" ]; then
  echo -e "${log_prefix}Updated pinned revision to $ansi_cyan$short_rev$ansi_reset ($message)"
  set_output updated "true"
else
  echo -e "${log_prefix}Pinned revision $ansi_cyan$old_rev$ansi_reset ($message) is up to date"
  set_output updated "false"
fi

pr_title="feat: update Firefish to \`$short_rev\`"
pr_body="$(cat << EOF
Updates Firefish beta to [$message (\`$short_rev\`)](https://gitlab.prometheus.systems/firefish/firefish/-/commit/$rev).
EOF
)"

set_output pr_title "$pr_title"
set_output pr_body "$pr_body"
