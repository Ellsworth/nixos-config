# This config defines some safe settings for a system installed with a GUI.
{ config, pkgs, ... }:
{
  imports = [
    <home-manager/nixos>
    ./syncthing.nix
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable and configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Make sure that Nix doesn't impact system responsiveness.
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  # KDE packages
  environment.systemPackages = with pkgs; [
    kdePackages.yakuake
    kdePackages.kcalc
    kdePackages.konversation

    # Pomoduro
    francis
  ];

  # Partition manager needs a daemon to work.
  programs.partition-manager.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;

  home-manager.users.erich =
    { pkgs, ... }:
    {
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

        # Programming
        kitty
        octaveFull
        arduino-ide
        logisim-evolution

        # Games
        prismlauncher

        # Office
        thunderbird
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

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Install fonts.
  fonts.packages = with pkgs; [
    intel-one-mono
    ibm-plex
    _3270font
  ];
}
