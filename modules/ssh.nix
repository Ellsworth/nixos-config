{ config, pkgs, ... }:
let
  myKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG3yEyI+ih4/rc4tNcXOImlUUCMJ1n/h6DpjXTBAyiL9 artemis"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSVvYsapiP3wSXptz3D3y3VRtpB1SS8Os4Gfk5g4xaT ceres"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINgrQ68WfJgDpLPNCESP8ZuBpE13+C36Y1HVQ8u71bCT apollo"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ+dC835zM2HFylIcSTVUkS851ymrrqNgQ071lWzYNpH iris"
  ];
in
{
  home-manager.users.erich =
    { pkgs, ... }:
    {
      programs.ssh.enable = true;
      programs.ssh.enableDefaultConfig = false;
      programs.ssh.settings = {
        vega = {
          hostname = "100.121.95.93";
          user = "root";
        };
        ceres = {
          hostname = "100.82.239.88";
        };
        apollo = {
          hostname = "100.127.227.54";
        };
        artemis = {
          hostname = "100.69.229.43";
        };
        iris = {
          hostname = "100.111.229.5";
        };
        vesta = {
          user = "ellsworth";
          hostname = "100.111.15.81";
        };
        "github.com" = {
          user = "git";
          hostname = "github.com";
        };
        "leap2" = {
          user = "wqi7";
          hostname = "leap2.txstate.edu";
          proxyJump = "fire";
        };
        "backup" = {
          user = "erich";
          hostname = "162.251.13.122";
          port = 14142;
        };
        "seton" = {
          user = "erich";
          hostname = "192.168.213.199";
          port = 14142;
          proxyJump = "backup";
        };
        "hipe" = {
          user = "hipe6-thrc";
          hostname = "100.100.73.40";
          port = 22;
        };
      };
    };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  programs.ssh.setXAuthLocation = true;

  programs.ssh.extraConfig = ''
    Host artemis
      HostName 100.69.229.43
      ConnectTimeout 3
      Port 22

    Host ceres
      HostName 100.82.239.88
      ConnectTimeout 3
      Port 22

    Host apollo
      HostName 100.127.227.54
      ConnectTimeout 3
      Port 22

    Host iris
      HostName 100.111.229.5
      ConnectTimeout 3
      Port 22
  '';

  # SSH keys
  users.users."erich".openssh.authorizedKeys.keys = myKeys;

  nix.sshServe = {
    enable = true;
    protocol = "ssh-ng";
    write = true;
    trusted = true;
    keys = myKeys;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

}
