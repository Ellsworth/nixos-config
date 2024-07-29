{ config, pkgs, ... }: {
  imports = [ <home-manager/nixos> ];

  # Auto-upgrade system.
  system.autoUpgrade.enable = true;

  # Enable garbage collector.
  nix.gc.automatic = true;

  # Optimise storage.
  nix.optimise.automatic = true;

  # Allow for updating of device firmware.
  services.fwupd.enable = true;

  # Consider users as trusted.
  nix.settings.trusted-users = [ "@wheel" "erich" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  nix.settings.experimental-features = [ "nix-command" ];

  # Automatically change the timezone.
  services.automatic-timezoned.enable = true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    # Required for custom NixOS build script to work.
    pkgs.gitFull
    pkgs.nixfmt

    # System Utils.
    pkgs.wget
    pkgs.killall
    pkgs.htop
  ];

  users.users.erich = {
    isNormalUser = true;
    description = "Erich Ellsworth";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" ];
    packages = with pkgs; [ ];
  };

  home-manager.users.erich = { pkgs, ... }: {
    home.packages = [
      # Programming Languages
      pkgs.gforth

      # Editors
      pkgs.helix

      ## Tools
      pkgs.htop

      pkgs.newsboat
    ];

    programs.bash.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };

  # Enable docker.
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    enableOnBoot = true;
  };

  # Tailscale.
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";

  # SSH keys
  users.users."erich".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3yEyI+ih4/rc4tNcXOImlUUCMJ1n/h6DpjXTBAyiL9 artemis"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSVvYsapiP3wSXptz3D3y3VRtpB1SS8Os4Gfk5g4xaT ceres"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILQ27ZwmB/SkEB/zfg3LuJJ/PMEyCGTz9qUfgsTUnoJ1 apollo"
  ];

  # Chrony NTP Service
  services.chrony = {
    enable = true;
    servers = [ "pool.ntp.org" "time.nist.gov" "10.253.0.102" ];
  };
}
