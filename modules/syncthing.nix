# services.syncthing.settings.devices
{pkgs, ...}: {
  services = {
    syncthing = {
      enable = true;
      user = "erich";
      dataDir = "/home/erich/Documents";
      configDir = "/home/erich/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI

      settings = {
        devices = {
          "vega" = {id = "XYL5QMF-OU6SERN-6VI7P4S-V4XYG4A-3I2ZU73-SGYO4JO-ORSK74K-QNJVBQA";};
          "Erich-PC" = {id = "LC6KLET-LSXD5AE-GW7V2AX-QR3JQ5C-NLE2X2L-LBEFWGW-QUMKNDZ-RHRL2Q6";};
          "Artemis" = {id = "S57LBR6-NGGVOIX-XK5DMMP-WTV32RT-6Q2H3RJ-LCO3PBE-KCEWVU3-JGAZ5QM";};
        };

        folders = {
          "documents" = {
            # Name of folder in Syncthing, also the folder ID
            path = "/home/erich/Documents"; # Which folder to add to Syncthing
            devices = ["vega" "Erich-PC" "Artemis"]; # Which devices to share the folder with
          };
          "music" = {
            path = "/home/erich/Music";
            devices = ["vega" "Erich-PC" "Artemis"];
          };
          "pictures" = {
            path = "/home/erich/Pictures";
            devices = ["vega" "Erich-PC" "Artemis"];
          };
        };
      };
    };
  };
}
