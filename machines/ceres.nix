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

  programs.gnupg.agent.enable = true;

  home-manager.users.erich =
    { pkgs, ... }:
    {
      programs.bash.enable = true;

      programs.password-store.enable = true;

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

  services.protonmail-bridge = {
    enable = true;
    logLevel = "info";
    package = pkgs.protonmail-bridge;

    # Make sure Bridge can find `pass` and gpg
    path = [
      pkgs.pass
      pkgs.gnupg
    ];
  };

  # Ensure socat is available
  environment.systemPackages = [ pkgs.socat ];

  systemd.services.protonmail-bridge-proxy = {
    description = "Proxy Proton Mail Bridge to Tailscale interface";
    after = [
      "network.target"
      "tailscaled.service"
      "protonmail-bridge.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5"; # Wait for tailscaled to fully settle
      ExecStart = "${pkgs.bash}/bin/bash -c '\
        ${pkgs.socat}/bin/socat TCP-LISTEN:1143,fork,reuseaddr,bind=100.82.239.88 TCP:127.0.0.1:1143 & \
        ${pkgs.socat}/bin/socat TCP-LISTEN:1025,fork,reuseaddr,bind=100.82.239.88 TCP:127.0.0.1:1025 & \
        wait'";
      Restart = "always";
      User = "erich"; # The user running the bridge
    };
  };

  # Open the ports on the Tailscale interface specifically
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
