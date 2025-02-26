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
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # KDE packages
    kdePackages.kcalc
    kdePackages.yakuake
    kdePackages.konversation
    kdePackages.krdp
    kdePackages.kleopatra
    kdePackages.dolphin

    # Pomoduro
    francis

    # hyprland packages
    kitty # required for the default Hyprland config
    waybar
    wofi
  ];

  # Partition manager needs a daemon to work.
  programs.partition-manager.enable = true;

  programs.hyprland.enable = true; # enable Hyprland

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
        vesktop
        free42
        anki

        # Programming
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

        # Chat
        retroshare
      ];

      programs.bash.enable = true;

      programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          streetsidesoftware.code-spell-checker
          # rust-lang.rust-analyzer
          yzhang.markdown-all-in-one
          usernamehw.errorlens
          charliermarsh.ruff
          ms-vscode-remote.remote-containers
          julialang.language-julia
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
    font-awesome
  ];
}
