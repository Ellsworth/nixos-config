{ config, pkgs, ... }:
{
  imports = [ <home-manager/nixos> ];

  home-manager.users.erich =
    { pkgs, ... }:
    {
      programs.ssh.enable = true;
      programs.ssh.matchBlocks = {
        vega = {
          port = 22;
          hostname = "100.121.95.93";
          user = "root";
        };
      };
    };

}
