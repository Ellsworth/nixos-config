# services.syncthing.settings.devices
{ pkgs, ... }:
{
  services = {
    syncthing.settings.folders = {
      "games" = {
        path = "/home/erich/Games/Emulators";
        devices = [ "Vega" ];
      };
    };
  };
}
