{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ../erich.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "iris";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Disable NetworkManager to prevent conflicts with systemd-networkd on this VPS
  networking.networkmanager.enable = false;

  # Force IPv6-only DNS nameservers instead of the global IPv4 ones in erich.nix
  networking.nameservers = lib.mkForce [
    "2606:4700:4700::1111" # Cloudflare IPv6
    "2001:4860:4860::8888" # Google IPv6
  ];

  # Networkd configuration for static/IPv6 setup
  networking.useNetworkd = true;
  networking.useDHCP = false;

  systemd.network.networks."10-ens3" = {
    matchConfig.Name = "ens3";

    # Assign the IP as a single host /128 address
    address = [ "2a11:6c7:2500:840d::2/128" ];
    routes = [
      # Explicit link-scoped host route to the gateway over ens3
      {
        Destination = "2a11:6c7:2500:840d::1/128";
        Scope = "link";
      }
      # Default internet route via the gateway, pinning your source IP
      {
        Gateway = "2a11:6c7:2500:840d::1";
        PreferredSource = "2a11:6c7:2500:840d::2";
      }
    ];

    # Set up IPv6 DNS servers
    networkConfig = {
      DNS = [
        "2606:4700:4700::1111" # Cloudflare
        "2001:4860:4860::8888" # Google
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
}
