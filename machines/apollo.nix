{ config, pkgs, ... }:
{
  imports = [
    ../erich.nix
    ../modules/desktop.nix
    ../modules/remote-build-client.nix
    ../modules/vm.nix
  ];

  networking.hostName = "apollo";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable bolt daemon to manager Thunderbolt devices.
  services.hardware.bolt.enable = true;

  # Tailscale behavior
  services.tailscale.useRoutingFeatures = "client";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
  ];

  home-manager.users.erich =
    { pkgs, ... }:
    {
      home.packages = [
      ];
      programs.bash.enable = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "23.11";
    };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
