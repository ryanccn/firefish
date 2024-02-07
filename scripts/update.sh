#! /usr/bin/env nix-shell
#! nix-shell -i dash -p dash coreutils openssl curl jq
#  shellcheck shell=dash

set -eu

# shellcheck source=lib.sh
. "$(dirname "$(readlink -f "$0")")/lib.sh"

log_prefix="$ansi_dim> $ansi_reset"

[ -d src-update ] && rm -rf src-update

old_rev="$(cat rev.txt)"

echo "${log_prefix}Fetching ${ansi_cyan}latest revision${ansi_reset} from GitLab API..."

commit_data="$(curl -fsSL "https://firefish.dev/api/v4/projects/7/repository/commits?ref_name=main" | jq '.[0]')"

rev="$(printf '%s' "$commit_data" | jq -r '.id')"
short_rev="$(printf '%s' "$commit_data" | jq -r '.short_id')"
message="$(printf '%s' "$commit_data" | jq -r '.title')"

echo "$rev" > rev.txt

if [ "$old_rev" != "$rev" ]; then
  echo "${log_prefix}Updated pinned revision to $ansi_cyan$short_rev$ansi_reset $ansi_dim$message$ansi_reset"
  set_output updated "true"
else
  echo "${log_prefix}Pinned revision $ansi_cyan$old_rev$ansi_reset $ansi_dim$message$ansi_reset is up to date"
  set_output updated "false"
fi

pr_title="feat: update Firefish to \`$short_rev\`"
pr_body="Updates Firefish to [$message (\`$short_rev\`)](https://firefish.dev/firefish/firefish/-/commit/$rev)."

set_output pr_title "$pr_title"
set_output pr_body "$pr_body"
