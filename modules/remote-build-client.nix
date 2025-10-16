{ config, pkgs, ... }:
{
  nix.buildMachines = [
    {
      hostName = "artemis";
      systems = []"x86_64-linux" "aarch64-linux"];
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
  # optional, useful when the builder has a faster internet connection than yours
  # TODO: re-enable this.
  #nix.extraOptions = ''
  #  builders-use-substitutes = true
  #'';

}
