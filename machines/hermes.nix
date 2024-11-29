{
  config,
  pkgs,
  lib,
  ...
}:
{

  nixpkgs.crossSystem.system = "aarch64-linux";
  imports = [
    # Include the results of the hardware scan.
    #./hardware-configuration.nix

    ../erich.nix
    ../modules/remote-build-client.nix

    # home-manager
    <home-manager/nixos>

    # Pi 3 bits
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    <nixos-hardware/raspberry-pi/3>
  ];

  #nixpkgs.overlays = [
  #  (final: super: {
  #    makeModulesClosure = x:
  #      super.makeModulesClosure (x // { allowMissing = true; });
  #  })
  #];

  sdImage.compressImage = false;

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  #nixpkgs.crossSystem.system = "aarch64-linux";
  #nixpkgs.hostPlatform.system = "aarch64-linux";

  # Enable networking
  #networking.networkmanager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
