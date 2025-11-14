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
  ];

  networking.hostName = "ceres";

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

  # Enable pulseaudio
  nixpkgs.config.pulseaudio = true;

  # Enable XFCE, in case we need a desktop.
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };
  services.displayManager.defaultSession = "xfce";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Ports
  networking.firewall.allowedTCPPorts = lib.mkAfter [ 53 ];
  networking.firewall.allowedUDPPorts = lib.mkAfter [ 53 ];

  # Solve InfluxDB related errors involving "too many open files."
  boot.kernel.sysctl = {
    "fs.file-max" = 2097152;
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  services.tailscale.enable = true;

  systemd.services.tailscale-serve-protonbridge = {
    description = "Expose ProtonMail Bridge IMAP/SMTP to Tailnet";
    wantedBy = [ "multi-user.target" ];

    after = [
      "network-online.target"
      "tailscaled.service"
      "protonmail-bridge.service"
    ];
    requires = [
      "tailscaled.service"
      "protonmail-bridge.service"
    ];

    # Make `tailscale` available in $PATH for this unit
    path = [ pkgs.tailscale ];

    script = ''
      set -eu

      # IMAP: Tailnet 143 -> local 1143
      tailscale serve tcp 143 127.0.0.1:1143 || true

      # SMTP: Tailnet 587 -> local 1025
      tailscale serve tcp 587 127.0.0.1:1025 || true
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
