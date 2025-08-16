{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    modules/ssh.nix
    modules/newsboat.nix
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    settings.trusted-users = [
      "@wheel"
      "erich"
    ];

    # Make sure that Nix doesn't impact system responsiveness.
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";

  };

  # Auto-upgrade system.
  system.autoUpgrade.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  # Run unpatched dynamic binaries on NixOS.
  programs.nix-ld.enable = true;

  services = {
    # Automatically change the timezone.
    automatic-timezoned.enable = true;

    # Utility to update device firmware.
    fwupd.enable = true;

    # Tailscale VPN
    tailscale.enable = true;

    # Chrony NTP Service
    chrony = {
      enable = true;
      servers = [
        "pool.ntp.org"
        "time.nist.gov"
        "100.69.229.43"
        "100.82.239.88"
      ];
      extraConfig = ''
        makestep 1 -1
        allow 100.0.0.0/8
      '';
    };

  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    # Required for custom NixOS build script to work.
    git
    nixfmt-rfc-style
    nvd

    # Rust-based replacements
    uutils-coreutils-noprefix
    sudo-rs

    # System Utils.
    wget
    killall
    htop
    btop
    just
    ncdu
    fastfetch
    distrobox
  ];

  users.users.erich = {
    isNormalUser = true;
    description = "Erich Ellsworth";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "podman"
      "docker"
    ];
    packages = with pkgs; [ ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # From: https://nixos.wiki/wiki/Environment_variables
  # This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
  # For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  home-manager.users.erich =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Programming Languages
        gforth
        uv

        # Editors
        helix

        # Tools
        newsboat
      ];

      programs.bash.enable = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "23.11";
    };

  # Enable podman
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      autoPrune.enable = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    oci-containers.backend = "podman";
  };

  # Expose NTP server.
  networking.firewall.allowedTCPPorts = lib.mkAfter [
    123
    3389
  ];
  networking.firewall.allowedUDPPorts = lib.mkAfter [
    123
    3389
  ];

  networking.nameservers = [
    "100.82.239.88"
    "1.1.1.1"
    "1.0.0.1"
  ];

  # Possible fix for for "NetworkManager-wait-online.service failed"
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

}
