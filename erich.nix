{ config, pkgs, ... }: {
  imports = [ <home-manager/nixos> 
    modules/ssh.nix
  ];

  # Auto-upgrade system.
  system.autoUpgrade.enable = true;

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  
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

  home-manager.users.erich = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Programming Languages
      gforth

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
    servers = [ "pool.ntp.org" "time.nist.gov" ];
    extraConfig = "makestep 1 -1";
  };
}
