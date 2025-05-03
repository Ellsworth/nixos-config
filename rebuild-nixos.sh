#!/usr/bin/env bash
#
# Rebuild NixOS from a flake and commit the result if it succeeds.
# Works on any machine whose nixosConfigurations.<hostname> exists.

set -euo pipefail

REPO="$HOME/nixos-config"
HOST="$(hostname)"

pushd "$REPO"

echo "→ Pulling latest repo changes"
tries=0
until git push; do
  git pull --ff-only          # catch up
  tries=$((tries+1))
  [ "$tries" -lt 3 ] || exit 1
done


echo "→ Updating flake inputs"
nix flake update            # adds a new flake.lock entry if anything changed

echo "→ Formatting Nix files"
nix fmt .

echo "→ Diff since last commit:"
git diff -U0 '*.nix' flake.lock || true   # always show, even if empty

echo "→ Building & switching system for $HOST ..."
# NOTE:  --impure lets Nix see uncommitted changes; drop it for purely pinned builds
#        --log-format pretty gives cleaner errors in the log
if sudo nixos-rebuild switch \
        --flake .#"${HOST}" \
        --log-format bar-with-logs \
        &> nixos-switch.log
then
    echo "✓ Rebuild succeeded"
else
    echo "✗ Rebuild failed — showing errors:"
    grep --color -iE '(error:|failed|cannot)' nixos-switch.log || true
    exit 1
fi

# Record the generation we just activated
CURRENT_GEN="$(sudo nixos-rebuild list-generations --flake .#"${HOST}" | grep current)"

echo "→ Committing changes: $CURRENT_GEN"
git add flake.lock
git commit -am "$HOST – $CURRENT_GEN"
git push

popd
