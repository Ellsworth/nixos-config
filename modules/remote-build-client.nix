{ config, pkgs, ... }:
{
  nix.buildMachines = [
    {
      hostName = "artemis";
      sshUser = "nix-ssh";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      protocol = "ssh-ng";
      maxJobs = 2;
      speedFactor = 2;
      supportedFeatures = [
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }

    {
      hostName = "ceres";
      sshUser = "nix-ssh";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      protocol = "ssh-ng";
      maxJobs = 1;
      speedFactor = 1;
      supportedFeatures = [
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;

  nix.settings = {
    substituters = [
      "ssh-ng://nix-ssh@artemis"
      "ssh-ng://nix-ssh@apollo"
      "ssh-ng://nix-ssh@ceres"
      "ssh-ng://nix-ssh@iris"
      "https://cache.nixos.org"
    ];
    trusted-substituters = [
      "ssh-ng://nix-ssh@artemis"
      "ssh-ng://nix-ssh@apollo"
      "ssh-ng://nix-ssh@ceres"
      "ssh-ng://nix-ssh@iris"
    ];
    fallback = true;
    connect-timeout = 3;
    stalled-download-timeout = 5;
  };

  # optional, useful when the builder has a faster internet connection than yours
  # TODO: re-enable this.
  #nix.extraOptions = ''
  #  builders-use-substitutes = true
  #'';

}
