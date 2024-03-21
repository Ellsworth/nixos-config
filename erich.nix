{
  config,
  pkgs,
  ...
}: {
  imports = [
    <home-manager/nixos>
  ];

  # Auto-upgrade system.
  system.autoUpgrade.enable = true;

  # Enable garbage collector.
  nix.gc.automatic = true;

  # Optimise storage.
  nix.optimise.automatic = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    pkgs.gitFull
    pkgs.alejandra
    pkgs.wget
  ];

  users.users.erich = {
    isNormalUser = true;
    description = "Erich Ellsworth";
    extraGroups = ["networkmanager" "wheel" "docker" "dialout"];
    packages = with pkgs; [];
  };

  home-manager.users.erich = {pkgs, ...}: {
    home.packages = [
      # Programming Languages
      pkgs.gforth

      ## Editors
      pkgs.helix
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
}
