# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [
    <home-manager/nixos>
    ../erich.nix
    ../modules/desktop.nix
    #    ../modules/vm.nix
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraPkgs = pkgs: [
        winetricks
        xdelta
        xxd
      ];
    })
    veracrypt
  ];

  home-manager.users.erich =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;

      home.packages = with pkgs; [
        (mumble.override { pulseSupport = true; })
        ryujinx
        dolphin
        melonDS
      ];
    };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  services.synergy = {
    server.enable = true;
    server.autoStart = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Tailscale behavior
  services.tailscale.useRoutingFeatures = "both";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
