{ config, pkgs, ... }:
{
  imports = [ <home-manager/nixos> ];

  home-manager.users.erich =
    { pkgs, ... }:
    {
      programs.ssh.enable = true;
      programs.ssh.matchBlocks = {
        vega = {
          hostname = "100.121.95.93";
          user = "root";
        };
        ceres = {
          hostname = "100.82.239.88";
          user = "root";
        };
        apollo = {
          hostname = "100.127.227.54";
        };
        artemis = {
          hostname = "100.75.40.55";
        };
        "github.com" = {
          user = "git";
          hostname = "github.com";
        };
      };
    };

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

}
