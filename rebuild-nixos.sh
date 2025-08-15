#!/usr/bin/env bash

# Stolen from: https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5

# I believe there are a few ways to do this:
#
#    1. My current way, using a minimal /etc/nixos/configuration.nix that just imports my config from my home directory (see it in the gist)
#    2. Symlinking to your own configuration.nix in your home directory (I think I tried and abandoned this and links made relative paths weird)
#    3. My new favourite way: as @clot27 says, you can provide nixos-rebuild with a path to the config, allowing it to be entirely inside your dotfies, with zero bootstrapping of files required.
#       `nixos-rebuild switch -I nixos-config=path/to/configuration.nix`
#    4. If you uses a flake as your primary config, you can specify a path to `configuration.nix` in it and then `nixos-rebuild switch —flake` path/to/directory
# As I hope was clear from the video, I am new to nixos, and there may be other, better, options, in which case I'd love to know them! (I'll update the gist if so)

#!/usr/bin/env bash
set -e

# cd to your config dir
pushd ~/nixos-config/

# Pull latest changes
git pull

# Autoformat your nix files
nixfmt **/*.nix

# Shows your changes
git diff -U0 *.nix

echo "NixOS Rebuilding..."

# Update flake lockfile
nix flake update

# Determine hostname
hostname=$(hostname)

# Get old system profile path
old=$(readlink -f /nix/var/nix/profiles/system)

# Rebuild with simplified error logging
if ! sudo nixos-rebuild switch --flake ".#${hostname}" &>nixos-switch.log; then
    grep --color error nixos-switch.log
    false
fi

# Get new system profile path
new=$(readlink -f /nix/var/nix/profiles/system)

# Show package differences
echo "nvd diff $old $new"
nvd diff "$old" "$new"

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes with the generation metadata
git commit -am "$hostname - $current"
git push

# Back to where you were
popd

# Collect garbage
sudo nix-collect-garbage --delete-older-than 30d
nix-collect-garbage --delete-older-than 30d
