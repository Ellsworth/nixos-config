{ config, pkgs, ... }:

{
  home-manager.users.erich =
    { pkgs, ... }:
    {
      # Home Manager needs a bit of information about you and the paths it should
      # manage.
      home.username = "erich";
      home.homeDirectory = "/home/erich";

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "23.11";

      home.packages = with pkgs; [
        # Programming Languages
        gforth
      ];

      programs.helix = {
        enable = true;
        defaultEditor = true;
      };

      programs.bash.enable = true;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
}
