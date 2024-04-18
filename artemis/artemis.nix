# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    <home-manager/nixos>
    ../erich.nix
    ../modules/desktop.nix
    ../modules/vm.nix
  ];

  # Add nvme module (?)
  boot.initrd.kernelModules = ["nvme"];

  # NTFS Support
  boot.supportedFilesystems = ["ntfs"];

  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
    };
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
  };

  boot.initrd.luks.devices."luks-7b10477c-1312-4b3a-81ab-d7369ef60444".device = "/dev/disk/by-uuid/7b10477c-1312-4b3a-81ab-d7369ef60444";
  networking.hostName = "artemis"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Local timezone for dual-booting.
  time.hardwareClockInLocalTime = true;

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

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

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
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [];

  home-manager.users.erich = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;

    home.packages = [
      (pkgs.mumble.override {pulseSupport = true;})
      pkgs.cargo
      pkgs.rustc
      pkgs.rustfmt
      pkgs.clippy
      pkgs.rust-analyzer
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Partition manager needs a daemon to work.
  programs.partition-manager.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22 5000];
  networking.firewall.allowedUDPPorts = [22 5000];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Allows for a device to serve it's nix cache. Port 5000(?)
  services.nix-serve = {
    enable = true;
  };
  nixpkgs.config.secret-key-files = /home/erich/nixos-config/cache-priv-key.pem;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
