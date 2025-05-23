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

# A rebuild script that commits on a successful build
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

# Update channels
sudo nix-channel --update

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild switch --upgrade &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Get hostname
hostname=$(hostname)

# Commit all changes witih the generation metadata
git commit -am "$hostname - $current"
git push

# Back to where you were
popd
