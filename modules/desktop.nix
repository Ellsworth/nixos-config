# This config defines some safe settings for a system installed with a GUI.
{ config, pkgs, ... }: {
  imports = [ <home-manager/nixos> ./syncthing.nix ];

  # Enable Flatpak
  services.flatpak.enable = true;

  home-manager.users.erich = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      # Music
      psst
      vlc

      # Utilities
      bitwarden
      firefox
      discord
      vesktop
      free42
      obsidian

      # KDE
      francis

      # Programming
      kitty

      # Games
      prismlauncher

      libreoffice-qt
      hunspell
      hunspellDicts.en_US
    ];

    programs.bash.enable = true;

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        streetsidesoftware.code-spell-checker
        rust-lang.rust-analyzer
        yzhang.markdown-all-in-one
        usernamehw.errorlens
        charliermarsh.ruff
      ];
    };
  };

  # Temporary optimisations for gaming
  programs.gamemode.enable = true;

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
