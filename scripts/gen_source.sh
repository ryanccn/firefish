#! /usr/bin/env nix-shell
#! nix-shell -i dash -p dash coreutils openssl git sd jq
#  shellcheck shell=dash

set -eu

# shellcheck source=lib.sh
. "$(dirname "$(readlink -f "$0")")/lib.sh"

log_prefix="$ansi_dim> $ansi_reset"

[ -d src ] && rm -rf src

rev="$(cat rev.txt)"

echo "${log_prefix}Cloning ${ansi_cyan}firefish#${rev}${ansi_reset}..."

mkdir src && cd src
if [ -n "${CI+unset}" ]; then git config --global init.defaultBranch main; fi
git init

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

git remote add origin "https://firefish.dev/firefish/firefish.git"
git fetch origin "$rev" --depth 1
git reset --hard FETCH_HEAD

patched_version="$(jq -r '.version' < package.json)-ryan.1"
echo "${log_prefix}Patching version to $ansi_cyan$patched_version$ansi_reset"
# shellcheck disable=SC2016
sd '("version": ")(.*)(",)' '$1$2-ryan.1$3' package.json
git add package.json
git commit -m "patch version to $patched_version"

for patch in ../patches/*.patch; do
  if [ -f "$patch" ]; then
    patch_name="$(basename "$patch")"
    echo "${log_prefix}Applying patch $ansi_cyan$patch_name$ansi_reset"
    git apply "$patch"
    git add .
    git commit -m "apply patch $patch_name"
  fi
done

set_output rev "$rev"
