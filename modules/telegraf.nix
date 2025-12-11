{
  config,
  pkgs,
  lib,
  ...
}:

{

  systemd.services.telegraf.path = [
    "/run/wrappers"
    pkgs.smartmontools
    pkgs.nvme-cli
  ];

  services.telegraf = {
    enable = true;

    # Token and other secrets loaded from .env
    environmentFiles = [ "/home/erich/nixos-config/.env" ];

    extraConfig = {
      agent = {
        interval = "300s";
        round_interval = true;
        flush_interval = "10s";
        metric_batch_size = 1000;
      };

      global_tags = {
        host = config.networking.hostName;
        env = "prod";
      };

      inputs = {
        cpu = [
          {
            percpu = true;
            totalcpu = true;
            report_active = true;
          }
        ];

        # Enable SMART monitoring (NVMe + SATA)
        smart = [
          {
            path_smartctl = "/run/current-system/sw/bin/smartctl";
            path_nvme = "/run/current-system/sw/bin/nvme";
            enable_extensions = [ "auto-on" ];
            use_sudo = true;
            interval = "300s";
            attributes = true;
          }
        ];
      };

      outputs = {
        influxdb_v2 = [
          {
            urls = [ "$INFLUX_HOST" ];
            token = "$INFLUX_TOKEN";
            organization = "default";
            bucket = "telegraf";
          }
        ];
      };
    };
  };

  # Allow Telegraf to run smartctl without a password
  security.sudo.extraRules = [
    {
      users = [ "telegraf" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/smartctl";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Ensure Telegraf is started
  systemd.services.telegraf.wantedBy = [ "multi-user.target" ];
}
