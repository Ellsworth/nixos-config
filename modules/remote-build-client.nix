{ config, pkgs, ... }: {
  nix.buildMachines = [
    {
      hostName = "artemis";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [ "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }

    {
      hostName = "ceres";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 1;
      speedFactor = 1;
      supportedFeatures = [ "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  nix.settings.trusted-public-keys =
    [ "artemis:Y4Bz+sblcfwMbaSb9OoPZ5OM5Xh8KGS3S8zuhkMJSCk=" ];
}
