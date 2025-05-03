{ config
, pkgs
, lib
, ...
}:
{

  nixpkgs.crossSystem.system = "aarch64-linux";
  imports = [
    # Include the results of the hardware scan.
    #./hardware-configuration.nix

    #../erich.nix
    ../modules/remote-build-client.nix

    # home-manager
    <home-manager/nixos>

    # Pi 3 bits
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    <nixos-hardware/raspberry-pi/3>
  ];

  #nixpkgs.overlays = [
  #  (final: super: {
  #    makeModulesClosure = x:
  #      super.makeModulesClosure (x // { allowMissing = true; });
  #  })
  #];

  users.users.erich = {
    isNormalUser = true;
    description = "Erich Ellsworth";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
    ];
    packages = with pkgs; [ ];
  };

  sdImage.compressImage = false;

  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  #nixpkgs.crossSystem.system = "aarch64-linux";
  #nixpkgs.hostPlatform.system = "aarch64-linux";

  # Enable networking
  #networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  programs.ssh.setXAuthLocation = true;

  # SSH keys
  users.users."erich".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3yEyI+ih4/rc4tNcXOImlUUCMJ1n/h6DpjXTBAyiL9 artemis"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSVvYsapiP3wSXptz3D3y3VRtpB1SS8Os4Gfk5g4xaT ceres"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgrQ68WfJgDpLPNCESP8ZuBpE13+C36Y1HVQ8u71bCT apollo"
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
