{
  config,
  pkgs,
  options,
  ...
}: let
  hostname = "apollo"; # to alllow per-machine config
in {
  networking.hostName = hostname;

  imports = [
    /etc/nixos/hardware-configuration.nix
    <home-manager/nixos>
    ./erich.nix
    "./${hostname}.nix"
  ];
}
