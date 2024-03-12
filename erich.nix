{
  config,
  pkgs,
  ...
}: {
  imports = [
    <home-manager/nixos>
  ];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  users.users.erich = {
    isNormalUser = true;
    description = "Erich Ellsworth";
    extraGroups = ["networkmanager" "wheel" "docker" "dialout"];
    packages = with pkgs; [];
  };

  home-manager.users.erich = {pkgs, ...}: {
    home.packages = [
      # System Utilities
      pkgs.gitFull
      pkgs.alejandra

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
}
