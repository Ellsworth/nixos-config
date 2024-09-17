{ config, pkgs, ... }:
{
  imports = [
    ../erich.nix
    ../modules/desktop.nix
    ../modules/remote-build-client.nix

    # Framework 13
    <nixos-hardware/framework/13-inch/7040-amd>

    # home-manager
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable bolt daemon to manager Thunderbolt devices.
  services.hardware.bolt.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Solution from https://discourse.nixos.org/t/rebuild-error-failed-to-start-network-manager-wait-online/41977
  systemd.network.wait-online.enable = false;
  systemd.services.systemd-udevd.restartIfChanged = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
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

  home-manager.users.erich =
    { pkgs, ... }:
    {
      home.packages = [ ];
      programs.bash.enable = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "23.11";
    };

  # List services that you want to enable:

  # KDE Partition manager
  # TODO: Move all desktop env. stuff to desktop.nix, or create a kde.nix.
  programs.partition-manager.enable = true;

  ## Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.setXAuthLocation = true;

  # Open ports in the firewall.
  # TODO: Move this to erich.nix
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
