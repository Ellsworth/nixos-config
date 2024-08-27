# This config defines some safe settings for a system installed with a GUI.
{ config, pkgs, ... }: {
  imports = [ <home-manager/nixos> ./syncthing.nix ];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  users.users.erich = {
    isNormalUser = true;
    description = "Erich Ellsworth";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" ];
    packages = with pkgs; [ ];
  };

  home-manager.users.erich = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    home.packages = [
      # Music
      pkgs.psst
      pkgs.vlc

      # Utilities
      pkgs.bitwarden
      pkgs.firefox
      pkgs.discord
      pkgs.vesktop
      pkgs.free42
      pkgs.obsidian

      # Programming
      pkgs.x3270
      pkgs.kitty
      pkgs.uv

      # Games
      pkgs.prismlauncher

      pkgs.libreoffice-qt
      pkgs.hunspell
      pkgs.hunspellDicts.en_US
    ];

    programs.bash.enable = true;

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        streetsidesoftware.code-spell-checker
        rust-lang.rust-analyzer
        yzhang.markdown-all-in-one
        usernamehw.errorlens
      ];
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };

  # Install fonts.
  fonts.packages = with pkgs; [ intel-one-mono ibm-plex _3270font ];
}
