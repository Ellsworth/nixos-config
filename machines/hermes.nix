{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../erich.nix
    ../modules/remote-build-client.nix
    ../modules/syncthing.nix
  ];

  networking.hostName = "hermes";

  # Create a swapfile
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16 GB
    }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 20; # default is 60
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow reboot to apply changes.
  system.autoUpgrade.allowReboot = true;

  # Tailscale behavior
  services.tailscale.useRoutingFeatures = "server";

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    libraspberrypi

  ];

  home-manager.users.erich =
    { pkgs, ... }:
    {
      programs.bash.enable = true;

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.05";
    };

    virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "America/Chicago";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [ 
        "--network=host" 
        #"--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
