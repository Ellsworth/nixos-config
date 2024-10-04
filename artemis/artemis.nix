# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    <home-manager/nixos>
    ../erich.nix
    ../modules/desktop.nix
    ../modules/vm.nix
    ../modules/syncthing-games.nix
  ];

  # Run latest Linux kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Add nvme module (?)
  boot.initrd.kernelModules = [ "nvme" ];

  # NTFS Support
  boot.supportedFilesystems = [ "ntfs" ];

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ ];

  home-manager.users.erich =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      home.packages = with pkgs; [
        (mumble.override { pulseSupport = true; })
        pkgs.ryujinx
        lutris
        dolphin
      ];
    };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
