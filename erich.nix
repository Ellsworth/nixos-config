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
    settings.experimental-features = [ "nix-command" ];
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
    extraGroups = [ "networkmanager" "wheel" "dialout" "gamemode"];
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

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  programs.ssh.setXAuthLocation = true;

  # SSH keys
  users.users."erich".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3yEyI+ih4/rc4tNcXOImlUUCMJ1n/h6DpjXTBAyiL9 artemis"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSVvYsapiP3wSXptz3D3y3VRtpB1SS8Os4Gfk5g4xaT ceres"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgrQ68WfJgDpLPNCESP8ZuBpE13+C36Y1HVQ8u71bCT apollo"
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

  # Chrony NTP Service
  services.chrony = {
    enable = true;
    servers = [ "pool.ntp.org" "time.nist.gov" ];
    extraConfig = "makestep 1 -1";
  };
}
