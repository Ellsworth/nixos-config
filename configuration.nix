{ config, pkgs, options, ... }:
let hostname = "artemis"; # to alllow per-machine config
in {
  networking.hostName = hostname;

  imports = [
    /etc/nixos/hardware-configuration.nix
    "/home/erich/nixos-config/${hostname}/${hostname}.nix"
  ];
}
