{ config, pkgs, lib, ... }: {
  imports = [ <home-manager/nixos> 
    modules/ssh.nix
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
    settings.experimental-features = [ "nix-command" "flakes"];
    settings.trusted-users = [ "@wheel" "erich" ];
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
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };

  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    # Required for custom NixOS build script to work.
    gitFull
    nixfmt-rfc-style

    # System Utils.
    wget
    killall
    htop
    fastfetch
    distrobox
    podman-compose
  ];

  users.users.erich = {
    isNormalUser = true;
    description = "Erich Ellsworth";
    extraGroups = [ "networkmanager" "wheel" "dialout"];
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

  home-manager.users.erich = { pkgs, ... }: {
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

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Chrony NTP Service
  services.chrony = {
    enable = true;
    servers = [ "pool.ntp.org" "time.nist.gov" "100.75.40.55" "100.82.239.88" ];
    extraConfig = ''
      makestep 0.1 1
      allow 100.0.0.0/8
    '';
  };

  # Possible fix for for "NetworkManager-wait-online.service failed"
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  # Local timezone for dual-booting.
  time.hardwareClockInLocalTime = true;

}
