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
    packages = with pkgs; [
      firefox
      kate

      #  thunderbird
    ];
    shell = pkgs.nushell;
  };

  home-manager.users.erich = {pkgs, ...}: {
    home.packages = [
      #pkgs.arduino-ide
      pkgs.gitFull
      pkgs.python3
      pkgs.psst
      #pkgs.discord
      pkgs.bitwarden

      # Programming Languages
      pkgs.gforth

      ## Rust
      pkgs.rustc
      pkgs.cargo
      pkgs.rust-analyzer

      ## Editors
      #      pkgs.vscode
      pkgs.helix
      #pkgs.kwrite
      pkgs.octaveFull

      # Games
      pkgs.prismlauncher
    ];

    programs.bash.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };
}
