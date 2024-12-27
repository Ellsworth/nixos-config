{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    #./hardware-configuration.nix

    ../erich.nix
    ../modules/remote-build-client.nix

    # home-manager
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow reboot to apply changes.
  system.autoUpgrade.allowReboot = true;

  # Tailscale behavior
  services.tailscale.useRoutingFeatures = "server";

  home-manager.users.erich =
    { pkgs, ... }:
    {
      programs.bash.enable = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "23.11";
    };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Solve InfluxDB related errors involving "too many open files."
  boot.kernel.sysctl = {
    "fs.file-max" = 2097152;
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
