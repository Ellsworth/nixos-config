# services.syncthing.settings.devices
{ pkgs, ... }:
{
  services = {
    syncthing = {
      folders = {
        "games" = {
          path = "/home/erich/Games";
          devices = [ "vega" ];
        };
      };
    };
  };
}
