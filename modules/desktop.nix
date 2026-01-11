# This config defines some safe settings for a system installed with a GUI.
{ config, pkgs, ... }:
{
  imports = [
    ./syncthing.nix
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  nix.extraOptions = ''
    download-buffer-size = 536870912
  '';

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

  # Enable autodiscovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable sound with pipewire.
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
    unstable.kdePackages.plasma-vault
    kdePackages.plasma-browser-integration
    kdePackages.francis

    # Agentic IDE
    antigravity

    # TXST VPN
    openconnect
    networkmanager-openconnect # Optional: for GUI integration

    # Remote desktop
    remmina

    # Misc apps
    wireshark
    obsidian
  ];

  # Partition manager needs a daemon to work.
  programs.partition-manager.enable = true;

  # Wireshark network analyzer
  programs.wireshark.enable = true;
  users.users.erich.extraGroups = [ "wireshark" ];

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
        bitwarden-desktop
        firefox
        vesktop
        free42
        plus42
        hexchat

        # Programming
        octaveFull
        arduino-ide

        # Games
        prismlauncher

        # Office
        thunderbird
        libreoffice-qt
        hunspell
        hunspellDicts.en_US
        zotero
      ];
      programs.bash.enable = true;

      programs.vscode = {
        enable = true;
        profiles.default.extensions = with pkgs.vscode-extensions; [
          rust-lang.rust-analyzer
          yzhang.markdown-all-in-one
          usernamehw.errorlens
          charliermarsh.ruff
          ms-vscode-remote.remote-containers
        ];
      };
    };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    protontricks.enable = true;
  };

  # Install fonts.
  fonts.packages = with pkgs; [
    intel-one-mono
    ibm-plex
    _3270font
    font-awesome
    atkinson-hyperlegible-mono
    atkinson-hyperlegible-next

  ];
}
