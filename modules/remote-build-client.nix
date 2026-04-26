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

  nix.settings.substituters = [
    "ssh-ng://nix-ssh@artemis"
    "ssh-ng://nix-ssh@ceres"
  ];
  # optional, useful when the builder has a faster internet connection than yours
  # TODO: re-enable this.
  #nix.extraOptions = ''
  #  builders-use-substitutes = true
  #'';

}
